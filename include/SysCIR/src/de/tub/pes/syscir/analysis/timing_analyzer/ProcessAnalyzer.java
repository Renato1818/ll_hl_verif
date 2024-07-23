package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCSocketInstance;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.GoalAnnotation;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.NewArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.NewExpression;
import de.tub.pes.syscir.sc_model.expressions.RefDerefExpression;
import de.tub.pes.syscir.sc_model.expressions.ReturnExpression;
import de.tub.pes.syscir.sc_model.expressions.SCPortSCSocketExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.SwitchExpression;
import de.tub.pes.syscir.sc_model.expressions.TimeUnitExpression;
import de.tub.pes.syscir.sc_model.expressions.UnaryExpression;
import de.tub.pes.syscir.sc_model.variables.SCEvent;
import de.tub.pes.syscir.sc_model.variables.SCPeq;
import de.tub.pes.syscir.sc_model.variables.SCTIMEUNIT;
import de.tub.pes.syscir.sc_model.variables.SCTime;

public class ProcessAnalyzer extends TADefaultExpressionHanlder {

	private static Logger logger = LogManager.getLogger(ProcessAnalyzer.class.getName());

	private SCProcess process;
	
	/**
	 * Control flow graph with Timed Atomic Blocks as nodes.
	 */
	private CFG<TimedAtomicBlock> cfg;

	private CFGAnalyzer cfgAnalyzer;

	/**
	 * The currently active timed atomic block.
	 */
	private TimedAtomicBlock currTAB;
	
	private Map<Expression, Long> WCtimeVarMapping;

	/**
	 * This Timed Atomic Block represents the node containing the GoalAnnotation.
	 * If a Annotation was found, the current TAB will be set as goal for the 
	 * process analysis.
	 */
	private TimedAtomicBlock goalTAB;

	private List<SCVariable> inEvents;

	private List<SCVariable> outEvents;

	private long processWCET = -1;
	private long processBCET = Long.MAX_VALUE;

	private Collection<TimedAtomicBlock> timedAtomicBlocks;

	private List<TimedAtomicBlock> currRetBlocks;

	/**
	 * first block of the CFG -> all function ends are joined
	 */
	private TimedAtomicBlock startAB;

	/**
	 * last block of the CFG -> all function ends are joined
	 */
	private TimedAtomicBlock endAB;

;

	public ProcessAnalyzer(SCProcess process) {
		this.process = process;
		// new cfg for each process
		this.cfg = new CFG<TimedAtomicBlock>(TimedAtomicBlock.class);
		this.cfgAnalyzer = new CFGAnalyzer(cfg);
		this.inEvents = new LinkedList<SCVariable>();
		this.outEvents = new LinkedList<SCVariable>();
		timedAtomicBlocks = new LinkedList<TimedAtomicBlock>();
		WCtimeVarMapping = new HashMap<Expression, Long>();
	}



	/**
	 * @param exprList Expressions to analyze may be empty
	 */
	private void analyzeExpressionList(List<Expression> exprList) {
		if (exprList.isEmpty()) return;
		for (Expression expr : exprList) {
			analyzeExpression(expr);
		}
		//		currTAB.setIsEndNode(true);
	}

	/**
	 * Traverse the function call graph and analyze the expressions.
	 * Build Timed Atomic Blocks in a CFG.
	 */
	public void analyze() {

		// assume thread
		// analyze the corresponding function
		SCFunction f = process.getFunction();
		inEvents.addAll(process.getSensitivity());

		if (f.getConsumesTime() || cfgAnalyzer.isCB()) {
			// analyze function and sub functions
			analyzeFunction(f);
			startAB = f.getEntryTAB();
			endAB = f.getExitTAB(); // this is not the last node, analyzeFunctions adds an empty new one
			timedAtomicBlocks = cfg.getAllNodes();
		}
		else {
			currTAB = cfg.createNode();
			currTAB.setStaticExecutionTime(0);
		}
	}

	/**
	 * Create Atomic Blocks in CFG structure for 
	 * this function.
	 * Creates an entry and an exit Atomic Block.
	 * 
	 * @param f The function to analyze.
	 */
	private void analyzeFunction(SCFunction f) {
//		if (f.isExtendedTimingAnalyzed()) {
		// TODO cfg.cloneSubTree() or similar
//		}
//		else {
		List<TimedAtomicBlock> retBlocks = new LinkedList<TimedAtomicBlock>();
		currRetBlocks = retBlocks;
		// new entry node for each function
		currTAB = cfg.appendNewNode(currTAB);
		f.setEntryTAB(currTAB);
		f.setExtendedTimingAnalyzed(true);

		// analyze function and sub functions
		analyzeExpressionList(f.getBody());

		// a new join tab for all function exits
		currTAB = cfg.appendNewNode(currTAB);
		f.setExitTAB(currTAB);
		currRetBlocks = retBlocks;
		for (TimedAtomicBlock retBlock : currRetBlocks) {
			cfg.addEdge(retBlock, currTAB);
		}
	}

	public CFG<TimedAtomicBlock> getCFG() {
		return cfg;
	}

	public CFGAnalyzer getCfgAnalyzer() {
		return cfgAnalyzer;
	}



	public TimedAtomicBlock getGoalTAB() {
		return goalTAB;
	}

	public long getWCET() {
		return processWCET;
		//return (processWCET == -1) ? findWCETPath(cfg) : processWCET;
	}

	public Collection<TimedAtomicBlock> getTimedAtomicBlocks() {
		return timedAtomicBlocks;
	}

	public void setGoalTAB(TimedAtomicBlock goalTAB) {
		this.goalTAB = goalTAB;
	}

	public SCProcess getProcess() {
		return process;
	}

	public TimedAtomicBlock getEndAB() {
		return endAB;
	}



	public void addConnectionInterface(SCSocketInstance socket,
			SCSocketInstance connectedSocket) {
	}

	/**
	 * Track +=, = for the variable tVar forward through the expressions
	 * and annotate the calculated value to all wait calls.
	 * 
	 * @param callValue The initial value for the time variable.
	 * @param exprList List of expressions to analyze.
	 * @param tVar The variable to track.
	 * @return
	 */
	private long analyzeSCTimeVarFW(long callValue, List<Expression> exprList, SCTime tVar) {
		TimeVariableAnalyzerFW a = new TimeVariableAnalyzerFW(tVar, callValue);
		for (Expression expr : exprList) {
			a.analyzeExpression(expr);
		}
		WCtimeVarMapping.putAll(a.getWCTimeMap());
		return a.getTime();
	}

	/**
	 * Analyze communication delays and find critical path.
	 * Requires all CFG structures to be ready.
	 * AnalyzeExpressions has to be called first.
	 */
	public void analyzeCFG() {
		if (goalTAB == null) {
			goalTAB = endAB;
		}
		cfgAnalyzer.analyze(null, goalTAB);
		processBCET = goalTAB.getBCET(0);
		processWCET = goalTAB.getWCET(0);
	}
	
	@Override
	public String toString() {
		return "Analyzer for " + process;
	}



	/* ------------- expression handler 'interface' methods here ------------- */
	@Override
	public void handleAccessExpression(AccessExpression aE) {
		currTAB.addExpression(aE);
		Expression right = aE.getRight();
		if (right instanceof FunctionCallExpression) { 
			FunctionCallExpression fctCall = (FunctionCallExpression)right;
			SCFunction fct = fctCall.getFunction();

			// catch transport, call is already resolved
			if (fct.getName().equals("b_transport") 
					|| fct.getName().equals("nb_transport_fw") 
					|| fct.getName().equals("nb_transport_bw") )
			{ 
				// get the sc_time delay call parameter
				Expression delayCallParamExpr;
				SCTime delayArg;
				if (fct.getName().equals("b_transport")) {
					delayCallParamExpr = fctCall.getParameters().get(1); // call parameter
					delayArg = (SCTime)fct.getParameters().get(1).getVar(); // function variable
				}
				else {
					delayCallParamExpr = fctCall.getParameters().get(2); 
					delayArg = (SCTime)fct.getParameters().get(2).getVar(); 
				}
				if (delayCallParamExpr instanceof SCVariableExpression) {
					SCVariable callVar = ((SCVariableExpression)delayCallParamExpr).getVar();
					if (callVar instanceof SCTime) {
						// get the time value when calling b_transport
						TimeVariableAnalyzer tva = new TimeVariableAnalyzer();
						long callValue = tva.getTimeFromExpression(delayCallParamExpr);

						// analyze the value inside the function and annotate when wait is called
						long retVal = analyzeSCTimeVarFW(callValue, fct.getBody(), delayArg);

						// go on annotating the returned value
						List<Expression> siblingExprns = aE.getParent().crawlDeeper();
						List<Expression> fwExprns = siblingExprns.subList(siblingExprns.indexOf(aE), siblingExprns.size()-1);
						analyzeSCTimeVarFW(retVal, fwExprns, (SCTime)callVar);
					}
				}
			}
			// in any case follow function call graph
			analyzeFunction(fct);
		}
		
	}

	@Override
	public void handleReturnExpression(ReturnExpression expr) {
		currTAB.addExpression(expr);
		currRetBlocks.add(currTAB);
	}

	@Override
	public void handleFunctionCallExpression(FunctionCallExpression fctCall) {
		currTAB.addExpression(fctCall);
		SCFunction fct = fctCall.getFunction();

		// catch wait 
		if (fct.getName().equals("wait") ){ 
			List<Expression> params = fctCall.getParameters();

			if (params.isEmpty()) { // => wait(), 
				for (SCEvent e : this.process.getSensitivity()) {
					if (currTAB.getInEvents().add(e) == false) {
						logger.error("Multipiple ocurence of the same sc_event in sensitivity"
								+ " list or multiple wait() in one AB.");
					}
				}
			}

			else if (params.size() == 1) { // wait(sc_time t) || wait(sc_event e)
				Expression eFirst = params.get(0);
				if ( eFirst instanceof SCVariableExpression) {
					SCVariable var = ((SCVariableExpression) eFirst).getVar();
					if (var instanceof SCEvent) {
						this.inEvents.add( (SCEvent)var );
						currTAB.addWaitForSCEvent( (SCEvent)var );
						currTAB.setStaticExecutionTime(-1);
					}
					else if ( WCtimeVarMapping.containsKey(fctCall) ) {
						// has been fw analyzed -> set as if static
						currTAB.setStaticExecutionTime(WCtimeVarMapping.get(fctCall));
					}
					else if (var instanceof SCTime) {
						TimeVariableAnalyzer tva =  new TimeVariableAnalyzer();
						currTAB.setStaticExecutionTime(tva.getTimeFromVariable((SCTime) var, fctCall));
					}
				}
			}

			else if (params.size() == 2) { // wait(int t, SCTIMEUNIT u)
				Expression eFirst = params.get(0);
				Expression eSec = params.get(1);
				long waitTime = -1;
				if (eFirst instanceof ConstantExpression){ // fixed numeral in source code
					waitTime = Long.valueOf(((ConstantExpression)eFirst).toString());
				}
				else if (eFirst instanceof SCVariableExpression) {
					SCVariable t = ((SCVariableExpression)eFirst).getVar();
					if (t.isConst() && t.hasInitialValue() ) {
						String initString = t.getInitializationString();
						String numberString = initString.substring(2);
						numberString = numberString.trim();
						waitTime = Long.valueOf(numberString);
					}
				}
				if (waitTime >= 0) {
					if (eSec instanceof TimeUnitExpression) {
						SCTIMEUNIT timeUnit = ((TimeUnitExpression)eSec).getTimeUnit();
						// max == 15 -> means femto, thus multiply with 10^(15-exponent) 
						int exponent =  15 - Math.abs(timeUnit.getExponent());
						for (int i = 0; i < exponent; i++) {
							waitTime *= 10; // 64 bit needed
						}
						currTAB.setStaticExecutionTime(waitTime); // save time for the block
					}
				}
				else { logger.error("unhandled wait call"); }
			}
			// after wait always a new TAB
			currTAB = cfg.appendNewNode(currTAB);
			return;
		} // end wait

		// other fctCall than wait
		if (fct.hasRecursions()) { 
			logger.error("recursion occurred"); 
			return; 
		}

		if (fct.isExtendedTimingAnalyzed()) {
			// add another edge to the function
			if ( !cfg.addEdge(currTAB, fct.getEntryTAB())) {
				logger.error("current or function entry tab not in CFG");
			}
			// and from the function back to the CFG
			currTAB = cfg.appendNewNode(currTAB);

			if ( !cfg.addEdge(fct.getExitTAB(), currTAB)) {
				logger.error("current or function exit tab not in CFG");
			}
			return;
		}
		analyzeFunction(fct);
	}


	@Override
	public void handleBinaryExpression(BinaryExpression binExpr) {
		Expression rightExpr = binExpr.getRight();
		currTAB.addExpression(binExpr); 
		if (rightExpr instanceof FunctionCallExpression) {
			analyzeExpression(rightExpr);
		}
		else if (rightExpr instanceof AccessExpression) {
			analyzeExpression(rightExpr);
		}
	}


	@Override
	public void handleIfElseExpression(IfElseExpression ifElseExpr) {
		// we link each conditional path to the following ABs
		// if one path is empty we link directly
		TimedAtomicBlock start = currTAB;
		TimedAtomicBlock thenEnd = start;
		TimedAtomicBlock elseEnd = start;

		// new atomic block for each outcome of the condition
		// but don't add ifElseExpression. Expressions are analyzed/added separately 
		List<Expression> thenBlock = ifElseExpr.getThenBlock();
		if (!thenBlock.isEmpty()) {
			currTAB = cfg.appendNewNode(start);
			TimedAtomicBlock condBegin = currTAB;
			// start block with the condition (it's looped, too)
			// actually this should be represented by the edge
			currTAB.addExpression(ifElseExpr.getCondition()); 
			analyzeExpressionList(thenBlock);
			for (TimedAtomicBlock ab : cfgAnalyzer.findNodesBetween(condBegin, currTAB)) {
				ab.setConditional(true);
			}
			thenEnd = currTAB;
		}

		List<Expression> elseBlock = ifElseExpr.getElseBlock();
		if (!elseBlock.isEmpty()) {
			currTAB = cfg.appendNewNode(start);
			TimedAtomicBlock condBegin = start;
			analyzeExpressionList(elseBlock);
			for (TimedAtomicBlock ab : cfgAnalyzer.findNodesBetween(condBegin, currTAB)) {
				ab.setConditional(true);
			}
			elseEnd = currTAB;
		}
		// new AB to join the paths
		currTAB = cfg.appendNewNode(currTAB);
		cfg.addEdge(thenEnd, currTAB);
		cfg.addEdge(elseEnd, currTAB);
	}


	@Override
	public void handleSwitchExpression(SwitchExpression expression) {
		// TODO Auto-generated method stub
		logger.error("switch case not handled!");
	}

	/**
	 * assume max iteration as fixed. max=min
	 */
	@Override
	public void handleLoopExpression(LoopExpression loopExpr) {
		// new tab (same earliest execution time as predecessor but different latest ET)
		currTAB = cfg.appendNewNode(currTAB);

		TimedAtomicBlock loopStartTAB = currTAB;
		int innerMaxEF = loopExpr.getMaxCount();

		// analyze the loop
		List<Expression> body = loopExpr.getLoopBody();
		Expression condition = loopExpr.getCondition();
		if (condition != null && innerMaxEF <= 0) { 
			if (condition instanceof ConstantExpression) {
				ConstantExpression cE = (ConstantExpression)condition;
				if (cE.getValue().equals("true") || cE.getValue().equals("1")) {
					loopExpr.setMaxCount(0);
					innerMaxEF = 0;
				}
			}
			this.analyzeExpression(condition);
		}
		this.analyzeExpressionList(body);

		// add a reverted edge ( and set inner loop freq)
		currTAB.setLoopBack(loopStartTAB); 
		for (TimedAtomicBlock ab : cfgAnalyzer.findNodesBetween(loopStartTAB, currTAB)) {
			ab.addMaxLoopIteration(innerMaxEF);
			ab.setMaxExecutionFrequency(ab.getMaxExecutionFrequency()*innerMaxEF);
		}
		// new tab -> if two loops end at the same point, two tabs are created
		currTAB = cfg.appendNewNode(currTAB);
	}


	@Override
	public void handleEventNotificationExpression(
			EventNotificationExpression enE) {
		currTAB.addExpression(enE);
		if ( enE.getEvent() instanceof SCVariableExpression ) {
			SCVariableExpression eventExpr = (SCVariableExpression) enE.getEvent();
			SCVariable eventVar = eventExpr.getVar();
			// event e
			if (eventVar instanceof SCEvent) {
				SCEvent event = (SCEvent)eventExpr.getVar();
				outEvents.add(event);
				currTAB.addEventNotification(enE);
				currTAB.addNotifySCEvent(event);
				return;
			}
			// peq
			if (eventVar instanceof SCPeq) {
				//handlePEQWithCB((SCPeq)eventVar);
				outEvents.add(eventVar);
				currTAB.addEventNotification(enE);
				if (WCtimeVarMapping.containsKey(enE)) {
					currTAB.setNotificationDelay(WCtimeVarMapping.get(enE));
					currTAB.addNotifySCEvent((SCPeq)eventVar);
					return;
				}
				logger.error("couldnt calculate delay call param for peq.notify");
			}
			logger.error("unhandled event notification");
		}
	}

	@Override
	public void handleGoalAnnotation(GoalAnnotation expression) {
		if (getGoalTAB() == null) {
			setGoalTAB(currTAB);
		}
		else {
			logger.error("more than one goal");
		}
	}

	@Override
	public void handleDefaultExpression(Expression expression) {
		currTAB.addExpression(expression);
	}

	public void setCurrTAB(TimedAtomicBlock dummyStart) {
		currTAB = dummyStart;
	}

	public void setStartAB(TimedAtomicBlock ab) {
		startAB = ab;
	}

} // end class

