/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.analysis.Analyzer;
import de.tub.pes.syscir.analysis.TimeConsumptionAnalyzer;
import de.tub.pes.syscir.analysis.data_race_analyzer.AtomicBlock;
import de.tub.pes.syscir.analysis.data_race_analyzer.DataRaceAnalyzer;
import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCConnectionInterface;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPortInstance;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCSocketInstance;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.ExpressionBlock;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCEvent;
import de.tub.pes.syscir.sc_model.variables.SCPeq;

/**
 * Top module for timing analysis for SystemC.
 * 
 * Call analyze(SCSystem scs) to perform a timing analysis
 * on the model.
 * The SystemC model need to have annotated static loop frequencies.
 * You can annotate a // GOAL inside of the SystemC processes
 * if you want the analysis to stop at a certain point.
 * The getBCET/WCET() of the process returns the time bound of the goal.
 * 
 * Psuedo code:
 * (1) Build CFG for each process with time delays annotated to nodes.
 * (2) Map all notifications between the processes.
 * (3) BFS on all CFGs and calculate time bounds for all atomic blocks
 * or until the goal is found.
 * 
 * The BCET,WCET for each segment of SystemC instructions are calculated
 * and stored.
 * The BCET,WCET for the processes are stored in the process analyzers.
 * 
 * Time in the analysis is represented as signed 64-Bit (long) value
 * -> Applicable for systems till 18446.74407371 SC_SEC
 * 18446.74407371 == (2⁶⁴-1)*10⁻¹⁵
 * 
 * No floating point time values like wait(3.2,SC_NS).
 * 
 * Event cancellation is not handled -> all delayed events will be fired at the time.
 * 
 * @author mario
 *
 */
public class TimingAnalyzer implements Analyzer {
	
	private static Logger logger = LogManager.getLogger(TimingAnalyzer.class.getName());

	/**
	 * After analysis, contain the WCET of the longest process
	 */
	private long WCET = Long.valueOf(-1); // -1 =>infinity
	
	private SCSystem scSystem;

	private List<TimedAtomicBlock> timedAtomicBlocks;
	
	/**
	 * Timing contexts for all processes and analyzer functions.
	 */
	private List<ProcessAnalyzer> processAnalyzers;
	
/* -------------- functions --------------------------- */
	public TimingAnalyzer() {
		super();
		this.timedAtomicBlocks = new LinkedList<TimedAtomicBlock>();
		this.processAnalyzers = new LinkedList<ProcessAnalyzer>();
	}

	@Override
	public void analyze(SCSystem scs) {
		scSystem = scs;

		// call simple timing analysis; alrdy done ??
		TimeConsumptionAnalyzer tca = new TimeConsumptionAnalyzer();
		tca.analyze(scSystem);
		
		//List<SCConnectionInterface> ports = scSystem.getPortSocketInstances();
		

		logger.info("Start Timing Analyzer");
		long startTime = System.nanoTime();
		for(SCClassInstance classInstance : scs.getInstances()){

			SCClass scClass = classInstance.getSCClass();
			if (scClass == null) {
				logger.error("Found no instances in system");
				return;
			}

			// 1. segmentation
			for(SCProcess scProcess : scClass.getProcesses()){
				logger.info("Process: " + scProcess.getName() + " found in class: " + scClass.getName());
				// one cfg for each process
				ProcessAnalyzer pA = new ProcessAnalyzer(scProcess);
				processAnalyzers.add(pA);
				pA.analyze();
			}
			for (SCVariable member : scClass.getMembers()) {
				if (member instanceof SCPeq) {
					logger.info("Peq with callback found in class: " + scClass.getName());
					processAnalyzers.add(transformPEQWithCB((SCPeq)member));
				}
			}
		}

			
		// 2. analyze dependencies
		analyzeProcessDependencies();

		// 3. find critical path and WCET
		logger.info("Starting graph analysis. Number of processes: " + processAnalyzers.size()
				+ ", total number of Atomic Blocks: " + TimedAtomicBlock.getNumTimedAtomicBlocks());
		long algoStartTime = System.nanoTime();
		for (ProcessAnalyzer pA : processAnalyzers) {
			if (pA.getGoalTAB() != null) { // if goal annotated
				pA.analyzeCFG();  // only analyze this
				// print
				logger.info("Procces " + pA.getProcess().getName() 
						+ " WCET: " + pA.getWCET());
				WCET = (pA.getWCET() > WCET)? pA.getWCET() : WCET;
				break;
			}
			// else all
			pA.analyzeCFG();
			// print
			logger.info("Procces " + pA.getProcess().getName() 
					+ " WCET: " + pA.getWCET());
			WCET = (pA.getWCET() > WCET)? pA.getWCET() : WCET;
		}
		long endTime = System.nanoTime();
		logger.info("Timing analyzer needed " + (endTime-startTime)/(double)1000000
				 + " ms. Graph algorithm needed: " + (endTime-algoStartTime)/(double)1000000 + " ms");


	}
	

	/**
	 * For each receiver atomic block iterate over all other processes
	 * and find possible notifiers.
	 * If match was found, remember the notifier in the receiver AB
	 */
	private void analyzeProcessDependencies() {
		if (processAnalyzers.size() == 1) {
			logger.info("Only one process in the system. Skipping communication dependency analysis");
			return;
		}
		logger.info("Evaluating communication dependencies");
		
		for (ProcessAnalyzer pReciever : processAnalyzers) { 						// go through receiver processes
			for (TimedAtomicBlock TABReceiver: pReciever.getTimedAtomicBlocks()) { 	// through all TABs
				Set<SCVariable> inEvents = TABReceiver.getInEvents();
				if (inEvents.isEmpty()) {
					continue;
				}
				for (SCVariable inEvent : inEvents) { 									// through all sensitive events
					for (ProcessAnalyzer pNotifier : processAnalyzers) {				// through all other processes
						if ( pNotifier.equals(pReciever) ) {							// except myself
							continue;
						}
						for (TimedAtomicBlock TABNotifier : pNotifier.getTimedAtomicBlocks() ) { // through all sender TABs
							if ( TABNotifier.getNotifyEvents().contains(inEvent) && (!TABNotifier.isConditional()) ) {	// which send one of the events
								TABReceiver.addPossibleNotifier(TABNotifier);
								TABNotifier.addPossibleReceiver(TABReceiver);
									logger.debug(
											"Dependency between receiver (process " +  pReciever.getProcess().getName() 
											+ ", TAB: " + TABReceiver.getID() + " )"  
											+ "and in (process: " + pNotifier.getProcess().getName()
											+ ", TAB: "  + TABNotifier.getID() + " )"
											+ "\n event: " + inEvent.toString());
							}
						} // end notifier TABs
					} // end notifier processes
				} // end in events
				if (TABReceiver.getPossibleNotifiers().isEmpty()) {
					logger.error("No possible notifier for " + inEvents.toString() + "found");
				}
			} // end receiving TAB
		} // end receiving process

//		for (ProcessAnalyzer outPA : processAnalyzers) {
//			for (TimedAtomicBlock outTAB: outPA.getTimedAtomicBlocks()) {
//				if ( !outTAB.getEventNotifications().isEmpty() ) {
//					List<EventNotificationExpression> eventExpressions = outTAB.getEventNotifications();
//					for (EventNotificationExpression notification : eventExpressions) {
//						SCEvent outEvent = (SCEvent)((SCVariableExpression)notification.getEvent()).getVar();
//						for (ProcessAnalyzer inPA : processAnalyzers) {
//							for (TimedAtomicBlock inTAB: inPA.getTimedAtomicBlocks()) {
//								if ( inTAB.getWaitForSCEvents().isEmpty()) continue;
//								if ( inTAB.getWaitForSCEvents().contains(outEvent) ) {
//									inTAB.addPossibleNotifier(outTAB);
//									// TODO build DAC
//									dependencyGraph.addNode(outTAB);
//									dependencyGraph.addEdge(outTAB, inTAB);
//									logger.info(
//											"Dependency between out(process " +  outPA.getProcess().getName() 
//											+ ", TAB: " + outTAB.getID() + " )"  
//											+ "and in (process: " + inPA.getProcess().getName()
//											+ ", TAB: "  + inTAB.getID() + " )"
//											+ "\n event: " + outEvent.toString());
//								}
//							}
//						}
//					}
//				}
//			}
//		}
		
	}

	public List<ProcessAnalyzer> getProcessAnalyzers() {
		return processAnalyzers;
	}

	public long getWCET() {
		return WCET;
	}
	
	/**
	 * Transform the PEQ callback to be compliant with our analysis.
	 * 
	 * 
	 * (1) Add a first node that has to wait for the PEQ event. 
	 * (2) Put whole cb into an infinite loop.
	 * (3) -> done in CFG analysis advance time by the smallest possible unit
	 * that the analysis evaluates the callback only once for one time point.
	 * 
	 * SystemC realizes the cb for each PEQ as a SC_THREAD.
	 * We create one new process and process analyzer for each PEQ.
	 * For all events notified inside the callback, the notification is
	 * the last execution depending on the execution times of the first 
	 * atomic block.
	 * 
	 * @param peq
	 * @return The newly constructed process analyzer.
	 */
	private ProcessAnalyzer transformPEQWithCB(SCPeq peq) {
		SCFunction callback = peq.getCallback();
		SCProcess cbProcess = new SCProcess(callback.getName());
		cbProcess.setFunction(callback);
		ProcessAnalyzer cbAnalyzer = new ProcessAnalyzer(cbProcess);
		cbAnalyzer.getCfgAnalyzer().setDynamic(true);
		TimedAtomicBlock dummyStart = cbAnalyzer.getCFG().createNode();
		dummyStart.addWaitForSCEvent(peq);
		cbAnalyzer.setCurrTAB(dummyStart);
		cbAnalyzer.setStartAB(dummyStart);
		cbAnalyzer.analyze(); 
		for (TimedAtomicBlock ab : cbAnalyzer.getCFG().getAllNodes()) {
			ab.setMaxExecutionFrequency(0); // all are infinitely looped
		}
		cbAnalyzer.getEndAB().setLoopBack(dummyStart);
		cbAnalyzer.getEndAB().addMaxLoopIteration(0);
		return cbAnalyzer;
	}
}
