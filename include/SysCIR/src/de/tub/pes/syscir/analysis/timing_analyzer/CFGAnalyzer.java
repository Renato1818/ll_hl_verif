package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCVariable;

/**
 * 
 * @author mario
 * 
 * Analyzer class for one CFG of a SystemC Process.
 * 
 * Perform a breadth first search through the CFG and 
 * track the time bounds.
 * If there is parallel synchronization with other processes, it
 * is assumed that there exists a CFGAnalyzer for each.
 * Depending analyses are invoked when an event by another process is
 * awaited.
 *
 */
public class CFGAnalyzer {
	
	private static Logger logger = LogManager.getLogger(CFGAnalyzer.class.getName());

	private static final List<CFGAnalyzer> allCFGAnalyzers = new LinkedList<CFGAnalyzer>();

	private CFG<TimedAtomicBlock> cfg;

	/** flag to indicate peq_cb for non-blocking transport */
	private boolean isCB;

	// BFS variables
	private Queue<TimedAtomicBlock> q = new LinkedList<TimedAtomicBlock>();
	private Queue<TimedAtomicBlock> blocked = new LinkedList<TimedAtomicBlock>();
	//private Map<TimedAtomicBlock, Integer> visited = new HashMap<TimedAtomicBlock, Integer>();
	private long WCET = 0;
	private long BCET = 0;
	// set up start node and time
	private TimedAtomicBlock currAB;
	private TimedAtomicBlock goal;

	private boolean isBlocked = false;
	private boolean initialized = false;
	private boolean isFinished  = false;
	private static int numCFGAnalyzers = 0;
	private final int id;


	public CFGAnalyzer(CFG<TimedAtomicBlock> cfg) {
		this.cfg = cfg;
		id = numCFGAnalyzers++;
		allCFGAnalyzers.add(this);
	}
	
	/**
	 * Find the process analyzer that contains ab
	 * @param ab The requested atomic block.
	 * @return The matching analyzer.
	 */
	public static CFGAnalyzer findDedicatedAnalyzer(TimedAtomicBlock ab) {
		for (CFGAnalyzer dedicatedAnalyzer : allCFGAnalyzers) {
			if (dedicatedAnalyzer.getCFG().getAllNodes().contains(ab)) {
				return (dedicatedAnalyzer);
			}
		}
		logger.error("Atomic Block without analyzer");
		return null;
	}
	
	public CFG<TimedAtomicBlock> getCFG() {
		return cfg;
	}

	public void setCFG(CFG<TimedAtomicBlock> cfg) {
		this.cfg = cfg;
	}

	public void setDynamic(boolean b) {
		isCB = b;
	}
	
	/**
	 * @return Whether the process is a PEQ callback.
	 */
	public boolean isCB() {
		return isCB;
	}
	
	/**
	 * Get all nodes between from and to, including from and to.
	 * Between means all nodes which have from in their parent tree
	 * and to in their child tree.
	 * There must not be any leaves in between.
	 * 
	 * @param from
	 * @param to
	 * @return A queue of all nodes [from, to] in BFS order
	 */
	public Queue<TimedAtomicBlock> findNodesBetween(TimedAtomicBlock from, TimedAtomicBlock to) {
		Queue<TimedAtomicBlock> nodes = new LinkedList<TimedAtomicBlock>();
		Queue<TimedAtomicBlock> q = new LinkedList<TimedAtomicBlock>();
		HashMap<TimedAtomicBlock, Boolean> visited = new HashMap <TimedAtomicBlock, Boolean>(); // initialized false
		TimedAtomicBlock TABNode = from;
		
		q.add(from);
		while(!q.isEmpty()) {

			TABNode = q.poll();
			nodes.add(TABNode);

			if(TABNode != to) {// don't add successors of to
				// analyze successors
				for (TimedAtomicBlock child : cfg.getSuccessors(TABNode)) {
					TimedAtomicBlock TABChild = child;
					if (TABChild == null) logger.error("inconsistent path"); // but all path should end with to
					if( !visited.containsKey(child) ) {
						q.add(child);
						visited.put(child, true);
					}
				}
			}

		}
		return nodes;
	}
	
	public void analyze() {
		analyze(null, null);
	}
	/**
	 * Do BFS and save min/max cost(time) to every block and accumulate for the process.
	 * The WCET until a TimedAtomicBlock is executed is exclusive the execution time of the TAB itself.
	 * This function does the initialization when starting the analysis. 
	 * 
	 * TODO do syncPoints (maybe)
	 * TODO mark critical path 
	 * return true;
	 * @param to The End Atomic Block or synchronization point.
	 */
	public void analyze(TimedAtomicBlock from, TimedAtomicBlock to) {


		if (to != null) {
			if(areAllEdgesAnalyzed(to)) {
				return;
			}
		}
		
		if (from == null && !blocked.isEmpty()) {
			TimedAtomicBlock b = blocked.poll();
			b.visit();
			q.add(b);
		}
		// called first time -> set time to zero
		else if ( from == null || (from == cfg.getStartNode() && !initialized)){
			if (!initialized) {
				goal = to;
				initialized = true;
			}
			from = cfg.getStartNode();
			from.setET(0, BCET, WCET);
			from.visit();
			q.add(from);
		}
		else if (isCB) {
			if ( !q.contains(cfg.getStartNode())) {
				cfg.getStartNode().visit();
				q.add(cfg.getStartNode()); 
			}
		}
		// from other node expect time to be stored in node
		else {
			// get the latest
			BCET = from.getBCET();
			WCET = from.getWCET();
			// assume right visit value
			q.add(from);
		}

		analyzeCFG();
	}
	
	/**
	 * Just an isolated function for overview.
	 * Call analyze(...).
	 * Iterate over all nodes and track BCET/WCET.
	 * Work on local variables.
	 */
	private void analyzeCFG() {

		while(!q.isEmpty()) {
			// analyze what is in queue
			currAB = q.poll();
			// restore the time for the current path
			BCET = currAB.getBCET();
			if (BCET == Long.MAX_VALUE) { logger.warn("found max value in BCET"); }
				
			WCET = currAB.getWCET();
			if (WCET == -1) { logger.warn("found unknown in WCET"); }

			if (!areAllEdgesAnalyzed(currAB)) {
				if (q.isEmpty()) logger.error("missing predecessor but not in queue");
				q.add(currAB); // missing predecessors must be in queue
				continue;
			}
			if (currAB.equals(goal)) { // don't analyze goal itself
				isFinished = true;
				return;
			}

			if ( !analyzeNode(currAB)) continue;

			// analyze successors
			Set<TimedAtomicBlock> successors = cfg.getSuccessors(currAB);
			for (TimedAtomicBlock succ : successors) {
				int numInEdges = cfg.getNumPredecessors(succ);
				succ.visit();
				// overwrite min/max ?
				succ.updateTime(currAB.getIterationCounter(), BCET, WCET);
				if ( (succ.getNumVisits() == numInEdges) && (!q.contains(succ))) {
					// if the node already is in queue, don't add twice
					q.add(succ);
				}
				if (succ.getNumVisits() > numInEdges) {
					logger.error("visiting node more often than in edges!");
				}
			}
		} // queue empty
		// last node?
		if (cfg.getSuccessors(currAB).size() == 0) {
			if(!isCB)isFinished = true;
		}
	}
	
	/**
	 * @param n The node to analyze.
	 * @return True if the node was updated, false if dependent on blocked process
	 */
	private boolean analyzeNode(TimedAtomicBlock n) {
		if ( n.hasInEvents()) { 
			Pair<Long, Long> newET = handleWaitingNode(n);
			if (newET == null) {
				boolean analysesDone = true;
				for (TimedAtomicBlock notifier : n.getPossibleNotifiers()) {
					analysesDone &= isAnalyzed(notifier);
				}
				if (analysesDone) {
					logger.debug("no possible notifiers anymore, blocking analysis here");
				}
				blocked.add(currAB);
				return false;
			}
			BCET = newET.getFirst();
			WCET = newET.getSecond();
			//continue; // just save, and go on with other paths
		} 
		else {
			long delay = n.getStaticExecutionDelay(); // add time
			WCET += delay;
			BCET += delay;
		}
		
		// handle end of loop
		TimedAtomicBlock loopBegin = n.getLoopBack();
		if (loopBegin != null) {
			return handleLoopEnd(n);
		}
		return true;
	}
	
	/**
	 * Currently unused, maybe use for validation.
	 * @param n
	 */
	private void updateReceivers(TimedAtomicBlock n) {
		if ( !n.getPossibleReceivers().isEmpty()) {
			for (TimedAtomicBlock recv : n.getPossibleReceivers()) {
				// get only analyzed ones
				// analyze receivers once again
				CFGAnalyzer ana = findDedicatedAnalyzer(recv);
				if ( !ana.isBlocked) {
					ana.q.add(recv);
				}
			}
		}
	}

	
	/**
	 * Try to determine the delay caused by the loop
	 * @param loopEnd
	 * @return True if whole loop is calculated
	 */
	private boolean handleLoopEnd(TimedAtomicBlock loopEnd) {
		TimedAtomicBlock loopBegin = loopEnd.getLoopBack();
		int innerMaxLoopIterations = loopEnd.getMaxLoopIterations().get(0);
		Queue<TimedAtomicBlock> loopNodes = findNodesBetween(loopBegin, loopEnd);

		// if loop has communication nodes handle again
		boolean isComLoop = false;
		for (TimedAtomicBlock ln : loopNodes) {
			if (ln.hasInEvents()) {
				isComLoop = true;
				break;
			}
		}
		// go again through com loops with fixed iterations count
		if (isComLoop && innerMaxLoopIterations > 0) {
			if (loopEnd.getIterationBounds().size() < innerMaxLoopIterations) {
				// maybe set this already when std analysis fills BCET/WCET
				// belately enter first execution
				loopBegin.updateLoopedExecutionTime(loopBegin.getIterationCounter(), loopBegin.getBCET(), loopBegin.getWCET());

				for (TimedAtomicBlock ln : loopNodes) {
					// mark loop as ready for next iteration analysis
					// if this is the first inner loop this starts with 1
					ln.setIterationCounter(ln.getIterationCounter()+1);
					ln.setNumVisits(0);
				}
				// update start time for next execution
				loopBegin.updateTime(BCET, WCET);
				// we haven't annotated all values yet ?
				// so go again
				loopBegin.visit();
				q.add(loopBegin);
				return false;
			}
			// all iterations are analyzed
			BCET = loopEnd.getBCET(innerMaxLoopIterations-1);
			WCET = loopEnd.getWCET(innerMaxLoopIterations-1);
			loopEnd.setIterationCounter(0);
			return true;
		}// end finite com loop
		// infinite com loop
		else if (isComLoop && innerMaxLoopIterations == 0) {
			loopBegin.updateLoopedExecutionTime(loopBegin.getIterationCounter(), loopBegin.getBCET(), loopBegin.getWCET());
			for (TimedAtomicBlock ln : loopNodes) {
				ln.setIterationCounter(ln.getIterationCounter()+1);
				ln.setNumVisits(0);
			}
			for(TimedAtomicBlock ab : findNodesBetween(loopEnd, goal)) {
				if (!ab.equals(loopEnd)) ab.updateTime(Long.MAX_VALUE, Long.MAX_VALUE);
			}
			if (isCB) {
				// increase minimum time to get the next peq call
				if (BCET < Long.MAX_VALUE) BCET++;
				if (WCET < Long.MAX_VALUE) WCET++;
			}
			loopBegin.updateTime(BCET, WCET);
			blocked.add(loopBegin); // only add to block, only analyze on demand (resume())
			return false; // nodes after loop are never analyzed
		}

		// loop has static delay
		long oneIterationWCET = WCET - loopBegin.getWCET();
		long oneIterationBCET = BCET - loopBegin.getBCET();

		// loop has finite iterations
		// when exiting loop, increase time with the BCET/WCET of the loop
		// and add new latest execution time to all TAB inside the loop
		if (innerMaxLoopIterations > 0) {
			// calc the delays
			long wholeLoopWCET =  innerMaxLoopIterations * oneIterationWCET;
			long wholeLoopBCET =  innerMaxLoopIterations * oneIterationBCET;
			long missingIterationsWCET = wholeLoopWCET - oneIterationWCET;
			long missingIterationsBCET = wholeLoopBCET - oneIterationBCET;
			// add to process WCET, but only the missing
			WCET += missingIterationsWCET;
			BCET += missingIterationsBCET;
			// store static delay of one iteration and calc latest ET
			for (TimedAtomicBlock TAB : this.findNodesBetween(loopBegin, currAB)) {
				TAB.setLatestExecution(TAB.getLatestExecution() + missingIterationsWCET);
				loopEnd.addStaticLoopET(oneIterationBCET, oneIterationWCET);
			}
		}
		// for infinite but static loops store delay for one iteration
		if (innerMaxLoopIterations == 0) {
			for (TimedAtomicBlock TAB : this.findNodesBetween(loopBegin, currAB)) {
				TAB.setLatestExecution(-1);
				loopEnd.addStaticLoopET(oneIterationBCET, oneIterationWCET);
			}
			WCET = Long.MAX_VALUE;
			BCET = Long.MAX_VALUE;
		}
		else if (innerMaxLoopIterations < 0 ) logger.error("unknown iteration frequency");
		return true;
	}


	/**
	 * Go through all possible notifiers and
	 * calculate the nearest communication bounds.
	 * 
	 * @param recv atomic block to analyze.
	 * @return The new calculated BCET/WCET bounds
	 */
	private Pair<Long, Long> handleWaitingNode(TimedAtomicBlock recv) {
		Set<SCVariable> inEvents = recv.getInEvents();
		// 1. Max time to event possible?
		// if cyclic dependent, estimate one period
		List<TimedAtomicBlock> notifiers = recv.getPossibleNotifiers();
		if (notifiers == null || notifiers.isEmpty()) {
			logger.error("no notifier for the following event(s) found: ", inEvents.toString());
			return null;
		}

		long newBCET = Long.MAX_VALUE;
		long newWCET = Long.MAX_VALUE;

		// go through all possible notifiers
		for (TimedAtomicBlock notifier : notifiers) {
			CFGAnalyzer ana = findDedicatedAnalyzer(notifier);
			boolean bcSet = false; // for each notifier try until both are set
			boolean wcSet = false;
			do {
				// possible notify time points of current notifier
				// only take as valid if all path are analyzed
				//if (ana.areAllEdgesAnalyzed(notifier)) {
				isBlocked = true;
				ana.resume(); // blocked is checked above
				//TODO Bug: if analysis is blocked in conditional path we must calculate the BCET
				// for all parallel paths because this could notify another process which therefore
				// responds with a notification that could lead to a earlier BCET in this node.
				isBlocked = false;
					long bcct = calcBCCT(notifier);
					long wcct = calcWCCT(notifier);
					assert(wcct >= bcct); // if bc is set wc must be set, too

					if (bcct > -1) {
						newBCET = Math.min(bcct, newBCET);
						//recv.setBCNotifier(notifier);
						bcSet = true;
					}
					if (wcct > -1) {
						newWCET = Math.min(wcct, newWCET); 
						//recv.setWCNotifier(notifier);
						wcSet = true;
					}
				//}
				if (bcSet && wcSet) { break; } 
			}while ( !ana.isBlocked && !isAnalyzed(notifier) );
		}
		if ( (newBCET < Long.MAX_VALUE) && (newWCET < Long.MAX_VALUE) ) { // check if notifier was found for both
			return new Pair<Long, Long>(newBCET,newWCET);
		}
		return null;
	}

	/**
	 * The earliest time when both intervals cut.
	 * As long as the WCET of the notifier is after the BCET of the waiter
	 * this is the max of the BCET of the notifier and the waiter
	 * @return The calculated best case communication time. -1 if not possible.
	 */
	private long calcBCCT(TimedAtomicBlock notifier) {
		Long bCSendTime = null;
		Pair<Long, Long> sendTimes = getNextETWithWCNTAfter(BCET, notifier);
		if (sendTimes == null) return -1;
		bCSendTime = sendTimes.getFirst(); 
		return Math.max(bCSendTime, BCET);
	}

	/** 
	 * The earliest possible point of communication has to be after WCET, otherwise 
	 * the notification could be missed.
	 * The worst-case com time is the notifiers WCET belonging to the BCET after the waiters WCET
	 * @return The worst case communication time, null if there is no worst case notification
	 * later than the current WCET
	 */
	private long calcWCCT(TimedAtomicBlock notifier) {
		Long wCSendTime = null;
		Pair<Long, Long> sendTimes = getNextETWithBCETAfter(WCET, notifier);
		if (sendTimes == null) return -1; 
		wCSendTime = sendTimes.getSecond();
		return wCSendTime;
	}

	/**
	 * Get the execution time bounds with a worst case notification time 
	 * (WCNT) after the passt time value.
	 * latest possible notification time must be greater than wait time point
	 * @param t The time point after which the WCNT has to be.
	 * @param notifier The atomic block that holds the notification
	 * @return (BCNT, WCNT) if valid else null
	 */
	private Pair<Long, Long> getNextETWithWCNTAfter(long t, TimedAtomicBlock notifier) {
		long notificationDelay = notifier.getNotificationDelay();
		// check if array is filled
		for (int i=0; i < notifier.getIterationBounds().size(); i++) {
			if ( (notifier.getWCET(i)+notificationDelay) >= t ) {
				Pair<Long, Long> ets = new Pair<Long, Long> (
						notifier.getBCET(i)+notificationDelay, notifier.getWCET(i)+notificationDelay);
				return ets;
			}
		}
		// if static, we can calculate
		ArrayList<Long> loopBCETs = notifier.getStaticLoopBCETs();
		if (loopBCETs.size() == 0) return null;
		ArrayList<Long> loopWCETs = notifier.getStaticLoopWCETs();
		ArrayList<Integer> maxLoopIteratsions = notifier.getMaxLoopIterations();
		assert(loopBCETs.size() == loopWCETs.size());
		assert(loopBCETs.size() == maxLoopIteratsions.size());

		long currWCET = notifier.getWCET(0);
		// go through loops 
		for (int i = 0; i < loopWCETs.size(); i++) {
			long loopBCET = loopBCETs.get(i);
			long loopWCET = loopWCETs.get(i);
			int loopIterations = maxLoopIteratsions.get(i);

			// check if loop is long enough
			if ( (notifier.getWCET() + loopWCET*loopIterations) < t) { 
				// no, check next outer loop
				continue;
			} // else
			// begin with two, the analyzed values are already for the first iteration
			for (int j = 2; j <= loopIterations ; j++) {
				currWCET += loopWCET;
				if (currWCET >= t) {
					Pair<Long, Long> bounds = new Pair<Long, Long>(
							notifier.getBCET() + (loopBCET*i), currWCET);
					return bounds;
				}
			}
		}
		// so it's a unanalyzed communication loop
		return null;
	}

	/**
	 * Get the execution time bounds (if any) with a best case notification time 
	 * (BCNT) after the passt time value.
	 * For looped ABs try to calculate or read from ET-list.
	 * 
	 * Use this for the worst case communication time (WCCT)
	 * 
	 * @param t The time point after which the BCNT has to be.
	 * @param notifier The atomic block that holds the notification.
	 * @return (BCNT, WCNT) if valid else null.
	 */
	private Pair<Long, Long> getNextETWithBCETAfter(long t, TimedAtomicBlock notifier) {
		long notificationDelay = notifier.getNotificationDelay();
		for (int i=0; i < notifier.getIterationBounds().size(); i++) {
			// true greater because equal time means non-deterministic execution
			if ( (notifier.getBCET(i)+notificationDelay) > t ) {
				return new Pair<Long, Long> (
						notifier.getBCET(i)+notificationDelay, notifier.getWCET(i)+notificationDelay);
			}
		}
		// check if we have a static loop
		ArrayList<Long> loopBCETs = notifier.getStaticLoopBCETs();
		if (loopBCETs.size() == 0) return null;
		ArrayList<Long> loopWCETs = notifier.getStaticLoopWCETs();
		ArrayList<Integer> maxLoopIteratsions = notifier.getMaxLoopIterations();
		assert(loopBCETs.size() == loopWCETs.size());
		assert(loopBCETs.size() == maxLoopIteratsions.size());

		long currBCET = notifier.getBCET();
		// go through loops 
		for (int i = 0; i < loopWCETs.size(); i++) {
			long loopBCET = loopBCETs.get(i);
			long loopWCET = loopWCETs.get(i);
			int loopIterations = maxLoopIteratsions.get(i);

			// check if loop is long enough
			if ( (notifier.getBCET() + loopBCET*loopIterations) < t) { 
				// no -> check next outer loop
				continue;
			} // else
			// begin with two, the analyzed values are already for the first iteration
			for (int j = 2; j <= loopIterations ; j++) {
				currBCET += loopBCET;
				if (currBCET >= t) {
					Pair<Long, Long> bounds = new Pair<Long, Long>(
							currBCET, notifier.getWCET()+(loopWCET*i));
					return bounds;
				}
			}
		}
		return null;
	}

	/**
	 * @param notifier The node to check.
	 * @return
	 */
	private boolean areAllEdgesAnalyzed(TimedAtomicBlock notifier) {
		return (cfg.getNumPredecessors(notifier) <= notifier.getNumVisits())? true : false;
	}
	
	/**
	 * @param n The atomic block.
	 * @return Whether n has its final time values.
	 */
	private boolean isAnalyzed(TimedAtomicBlock n) {
		return (areAllEdgesAnalyzed(n) && n.isLoopAnalysed());
	}

	/**
	 * Unlock and enqueue for analysis.
	 * 
	 * @param recv The Atomic Block to unlock.
	 * @return false if recv is not part of CFG or not blocked.
	 */
	public boolean unlockReceiver(TimedAtomicBlock recv) {
		if (!cfg.getAllNodes().contains(recv)) {
			return false;
		}
		if (blocked.remove(recv) ) {
			q.add(recv);
			return true;
		}
		return false;
	}
	
	/**
	 * Resume the CFG analysis if it was blocked before.
	 * Load the previously blocked atomic block into work list again.
	 * 
	 * @return Whether the analysis could be resumed or is still blocked.
	 */
	public boolean resume() {
		if (isBlocked) return false;
		if (isFinished) return false;
		analyze(blocked.poll(), null);
		return true;
	}

	// just for debug purpose 
	@Override
	public String toString() {
		return "CFG Analzer for process" + id;
	}
}
