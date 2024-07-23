/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCTime;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Block of expressions that are necessarily executed in one time slice
 * and under the same condition.
 * 
 * Atomic blocks are created after each wait.
 * In addition a new timed atomic block is created for every 
 * split in the CFG and on every loop entry and exit.
 * 
 * @author mario
 *
 */
public class TimedAtomicBlock implements Cloneable {
	
	private static Logger logger = LogManager.getLogger(TimedAtomicBlock.class.getName());

	/** all notifications that are fired in this atomic block */
	private List<EventNotificationExpression> eventNotificationExpressions;
	
	/**
	 * Counts all atomic blocks.
	 */
	private static int numTimedAtomicBlocks = 0;

	/**
	 * Individual identifier for each block.
	 */
	private final int id;

	/**
	 * contains all expression of this atomic block
	 */
	private List<Expression> expressionList;

	/**
	 * The latest time point when this TAB may be executed.
	 * -1 == inf.
	 */
	private long latestExecution = -1;
	
	/**
	 * A special edge to the loop begin.
	 */
	private TimedAtomicBlock loopBack;

	/**
	 * Count how often the this block could possibly be executed.
	 * Increased in loop or SC_THREAD.
	 * @see frequencyKnown
	 */
	private int maxExecutionFrequency = 1;

	/**
	 * The maximum iteration count of the loops this block is in.
	 * From the inside to the outside.
	 */
	private ArrayList<Integer> maxLoopIterations = new ArrayList<Integer>();

	/**
	 * The best case delays of the loops this block is in.
	 * From the inside to the outside.
	 */
	private ArrayList<Long> staticLoopBCETs = new ArrayList<Long>();

	/**
	 * The worst case delays of the loops this block is in.
	 * From the inside to the outside.
	 */
	private ArrayList<Long> staticLoopWCETs = new ArrayList<Long>();

	/**
	 * If this node has an inEvent and is in a loop
	 * we save all the communication delays here.
	 * This array shall contain all explicit W/BCETs for each execution
	 * as far as calculated.
	 * The index is the iteration number, not the execution number.
	 * First iteration means second execution.
	 */
	private ArrayList<Pair<Long, Long>> iterationBounds = new ArrayList<Pair<Long,Long>>();
	
	/**
	 * This is the indexer for the iterationBound array.
	 * Save this here for the analysis to know which iteration
	 * to set in the array.
	 * Necessary because nodes can be analyzed(updated) multiple times
	 * in the same iteration.
	 * This counter is only increased when the end of the loop is reached
	 * for the next analysis as a write index.
	 * The iterationBounds array and the counter start with 0
	 * for the first execution. That means iterationCounter==executionCount-1
	 */
	private int iterationCounter = 0;

	/**
	 * List of events which are sent out by this TAB. 
	 */
	private List<SCVariable> outEvents;

	private List<TimedAtomicBlock> possibleNotifiers;

	/**
	 * exact time, if possible
	 */
	private long staticExecutionDelay = 0;
	
//	/**
//	 * CFG dependent Variable, which determines the execution time.
//	 */
//	private SCTime executionTimeVariable;
//	
//	/**
//	 * The modification that is performed if this Atomic Block is executed.
//	 */
//	private TimeVariableModificator tvm;

	/**
	 * The TAB will block until one of this events occur.
	 * Have to be multiple for sensitivity list.
	 */
	private Set<SCVariable> inEvents;

	/**
	 * signal if this flag is part of a conditional cfg branch
	 */
	private boolean isConditional = false;

	private List<TimedAtomicBlock> possibleReceivers;

	private TimedAtomicBlock bCNotifier;

	private TimedAtomicBlock wCNotifier;

	/**
	 * only for peq cb (not normal wait delay)
	 */
	private long notificationDelay = 0;

	private int numVisits = 0;


	/**
	 * default CTOR
	 */
	public TimedAtomicBlock() {
		super();
		this.id = numTimedAtomicBlocks++;
		this.eventNotificationExpressions = new LinkedList<EventNotificationExpression>();
		this.expressionList = new ArrayList<Expression>();
		this.outEvents = new LinkedList<SCVariable>();
		this.possibleNotifiers = new LinkedList<TimedAtomicBlock>();
		this.possibleReceivers = new LinkedList<TimedAtomicBlock>();
		this.inEvents = new HashSet<SCVariable>();
	}

	/**
	 * Get the total number of blocks created.
	 * @return the numTimedAtomicBlocks
	 */
	public static int getNumTimedAtomicBlocks() {
		return numTimedAtomicBlocks;
	}

	public void addEventNotification(EventNotificationExpression en) {
		this.eventNotificationExpressions.add(en);
	}

	public void addExpression(Expression expr) {
		this.expressionList.add(expr);
	}
	
	public void addPossibleNotifier(TimedAtomicBlock notifier) {
		this.possibleNotifiers.add(notifier) ;
	}

	public void addWaitForSCEvent(SCVariable var) {
		inEvents.add(var);
	}
	
	public List<SCVariable> getNotifyEvents() {
		List<SCVariable> events = new LinkedList<SCVariable>();
		for (EventNotificationExpression eN : eventNotificationExpressions) {
			events.add( ((SCVariableExpression)eN.getEvent()).getVar() );
		}
		return events;
	}
	
	public List<EventNotificationExpression> getEventNotifications() {
		return eventNotificationExpressions;
	}

	public long getLatestExecution() {
		return latestExecution;
	}

	public int getMaxExecutionFrequency() {
		return maxExecutionFrequency;
	}

	public ArrayList<Integer> getMaxLoopIterations() {
		return this.maxLoopIterations;
	}

	/**
	 * Use this to set an iteration in the CFG.
	 * This edge is not taken in the normal CFG traversal.
	 * 
	 * @param to The Timed Atomic Block to which to return.
	 */
	public void setLoopBack(TimedAtomicBlock to) {
		this.loopBack = to;
	}

	/**
	 * @return The node where the loop started.
	 */
	public TimedAtomicBlock getLoopBack() {
		return this.loopBack;
	}

	public long getWCET() {
		Pair<Long, Long> ets = iterationBounds.get(iterationBounds.size()-1);
		return ets.getSecond();
	}

	/**
	 * @return The earliest estimated execution time.
	 */
	public long getBCET() {
		Pair<Long, Long> ets = iterationBounds.get(iterationBounds.size()-1);
		return ets.getFirst();
	}
	
	/** It is the last node of the process. */
//	private boolean isEndNode = false;
	
	public List<SCVariable> getOutEvents() {
		return outEvents;
	}
	
	public List<TimedAtomicBlock> getPossibleNotifiers() {
		return possibleNotifiers;
	}
	
	public long getStaticExecutionDelay() {
		return staticExecutionDelay;
	}
	
	public Set<SCVariable> getInEvents() {
		return inEvents;
	}
	
	public void setEventNotification(List<EventNotificationExpression> enL) {
		this.eventNotificationExpressions = enL;
	}

	public void setEventNotifications(
			List<EventNotificationExpression> eventNotifications) {
		this.eventNotificationExpressions = eventNotifications;
	}

	public void setLatestExecution(long latestExecution) {
		this.latestExecution = latestExecution;
	}

	public void setMaxExecutionFrequency(int maxExecutionFrequency) {
		this.maxExecutionFrequency = maxExecutionFrequency;
	}

	/**
	 * @param index the iteration, must be less or equal 
	 * the array size
	 * @param bCET
	 * @param wCET
	 */
	public void setET(int index, long bCET, long wCET) {
		Pair<Long, Long> bounds = 
				new Pair<Long, Long>(bCET, wCET);
		if (iterationBounds.size() == index) {
			iterationBounds.add(bounds);
		}
		iterationBounds.set(index, bounds);
	}

	public void setOutEvents(List<SCVariable> notifySCEvents) {
		this.outEvents = notifySCEvents;
	}

	public void setPossibleNotifiers(List<TimedAtomicBlock> notifiers) {
		this.possibleNotifiers = notifiers;
	}

	public void setStaticExecutionTime(long staticExecutionTime) {
		this.staticExecutionDelay = staticExecutionTime;
	}

	@Override
	public String toString() {
		return "TimedAtomicBlock [name=" + this.getID()
				+ ", staticDelay=" + staticExecutionDelay
				+ ", inEvents=" + inEvents
				+ ", outEvents=" + outEvents
				+ ", maxExecutionFrequency=" + maxExecutionFrequency
				+ ", ET=" + iterationBounds.toString() + "\n"
				+ "[Expressions : " + expressionList.toString() + " \n";
	}

	public int getID() {
		return id;
	}

	public void addNotifySCEvent(SCVariable event) {
		this.outEvents.add(event);
	}

	/**
	 * @return Whether this block is inside a loop.
	 */
	public boolean isInLoop() {
		return (maxExecutionFrequency > 1)? true : false;
	}

	public void setInEvents(Set<SCVariable> sensitivity) {
		this.inEvents = sensitivity;
	}

	public boolean hasInEvents() {
		if (inEvents.size() > 0) {
			return true;
		}
		return false;
	}

	/**
	 * Updates the BCET and WCET of this Atomic Block.
	 * 
	 * @param bCET The new BCET
	 * @param wCET The new WCET
	 * @return True if either one of the time values was overwritten.
	 */
	public boolean updateTime(long bCET, long wCET) {
		return updateLoopedExecutionTime(iterationCounter, bCET, wCET);
	}

	/**
	 * Updates the BCET and WCET of this Atomic Block.
	 * 
	 * @param index the iteration index
	 * @param bCET The new BCET
	 * @param wCET The new WCET
	 * @return True if either one of the time values was overwritten.
	 */
	public boolean updateTime(int index, long bCET, long wCET) {
		return updateLoopedExecutionTime(index, bCET, wCET);
	}
	
	/**
	 * Assume an entry with this index already exists.
	 * 
	 * @param index the iteration index.
	 * @param newBCET
	 * @return if updated or new.
	 */
	private boolean updateLoopedBCET(int index, long newBCET) {
		if (iterationBounds.size() <= index) {
			logger.error("index in iterationBounds not filled");
			return false;
		}
		if(newBCET < iterationBounds.get(index).getFirst()) {
			Pair<Long, Long> bounds = 
					new Pair<Long, Long>(newBCET,iterationBounds.get(index).getSecond());
			iterationBounds.set(index, bounds);
			return true;
		}
		return false;
	}

	/**
	 * Assume an entry with this index already exists.
	 * 
	 * @param index the iteration index.
	 * @param newWCET
	 * @return if updated or new.
	 */
	private boolean updateLoopedWCET(int index, long newWCET) {
		if (iterationBounds.size() <= index) {
			logger.error("index in iterationBounds not filled");
			return false;
		}
		if(newWCET > iterationBounds.get(index).getSecond()) {
			Pair<Long, Long> bounds = 
					new Pair<Long, Long>(iterationBounds.get(index).getFirst(), newWCET);
			iterationBounds.set(index, bounds);
			return true;
		}
		return false;
	}

	/**
	 * Add or update the ETs at index
	 * 
	 * @param index Array index and iteration count (== exectuionCount-1)
	 * @param newBCET
	 * @param newWCET
	 * 
	 * @return True if set or updated.
	 */
	public boolean updateLoopedExecutionTime(int index, long newBCET, long newWCET) {
		if (iterationBounds.size() == index) {
			Pair<Long, Long> bounds = 
					new Pair<Long, Long>(newBCET, newWCET);
			iterationBounds.add(bounds);
			return true;
		}
		else if (iterationBounds.size() < index){
			logger.error("scipped itarations while trying to add execution time");
		}
		boolean retVal = updateLoopedBCET(index, newBCET);
		retVal |= updateLoopedWCET(index, newWCET);
		return retVal;
	}
	
	/**
	 * Get the ETs in an array with an entry for each execution.
	 * @return iteration bounds.
	 */
	public ArrayList<Pair<Long, Long>> getIterationBounds() {
		return iterationBounds;
	}

	public void setIterationBounds(ArrayList<Pair<Long, Long>> iterationBounds) {
		this.iterationBounds = iterationBounds;
	}

	/**
	 * @return the iterationCounter to index the iterationBounds
	 */
	public int getIterationCounter() {
		return iterationCounter;
	}

	/**
	 * @param iterationCounter the iterationCounter to set
	 */
	public void setIterationCounter(int iterationCounter) {
		this.iterationCounter = iterationCounter;
	}

	/**
	 * This method determines whether further analysis will yield 
	 * later execution times.
	 * 
	 * @return Whether all loops this AB is in are completely analyzed.
	 */
	public boolean isLoopAnalysed() {
		if ( !isInLoop() ) return true;
		// static
		// check if all nested loops have assigned static ETs
		if ( maxLoopIterations.size() > 0 && 
				staticLoopWCETs.size() == maxLoopIterations.size() &&
				staticLoopBCETs.size() == maxLoopIterations.size() ) return true;

		// variable but already analyzed
		if ( iterationBounds.size() >= maxExecutionFrequency) {
			return true;
		}
		return false;
	}

	public TimedAtomicBlock getBCNotifier() {
		return bCNotifier;
	}

	public void setBCNotifier(TimedAtomicBlock notifier) {
		this.bCNotifier = notifier;
	}

	public TimedAtomicBlock getWCNotifier() {
		return wCNotifier;
	}

	public void setWCNotifier(TimedAtomicBlock notifier) {
		this.wCNotifier = notifier;
	}

//	public TimedAtomicBlock getBCReceiver() {
//		return bCReceiver;
//	}
//
//	public void setBCReceivers(List<TimedAtomicBlock> recvs) {
//		this.bCReceivers = recvs;
//	}
//
//	public List<TimedAtomicBlock> getWCReceivers() {
//		return wCReceivers;
//	}
//
//	public void setWCReceiver(TimedAtomicBlock recv) {
//		this.wCReceiver = recv;
//		
//	}

	public void addPossibleReceiver(TimedAtomicBlock tABReceiver) {
		possibleReceivers.add(tABReceiver);
	}

	public List<TimedAtomicBlock> getPossibleReceivers() {
		return possibleReceivers;
	}

	public boolean isConditional() {
		return isConditional;
	}

	public void setConditional(boolean isConditional) {
		this.isConditional = isConditional;
	}

	/**
	 * Set the iteration frequency of all nested loops which include this block.
	 * 
	 * @param loopIterations
	 */
	public void setMaxLoopIterations(ArrayList<Integer> loopIterations) {
		maxLoopIterations = loopIterations;
	}

	/**
	 * Set static BCETs for the loops that contain this tab.
	 * Array is assumed to address the loops from inside to 
	 * outside.
	 * 
	 * @param loopBCETs Enumeration of BC loop delays.
	 */
	public void setStaticLoopBCETs(ArrayList<Long> loopBCETs) {
		staticLoopBCETs = loopBCETs;
	}

	/**
	 * Get all worst case delays for all iterations of the 
	 * loops that contain this Atomic Block.
	 * The array starts with the inner most loop and 
	 * progressing to the outside.
	 * 
	 * @return Enumeration of nested best case loop delays
	 */
	public ArrayList<Long> getStaticLoopBCETs() {
		return staticLoopBCETs;
	}

	/**
	 * Set static WCETs for the loops that contain this tab.
	 * Array is assumed to address the loops from inside to 
	 * outside.
	 * 
	 * @param loopWCETs Enumeration of WC loop delays.
	 */
	public void setStaticLoopWCETs(ArrayList<Long> loopWCETs) {
		staticLoopWCETs = loopWCETs;
	}

	/**
	 * Add a delay for one iteration of a loop to the end
	 * of the array.
	 * The array then contains the loop delays starting with
	 * the inner most loop progressing to the outside.
	 * 
	 * @param bCET
	 * @param wCET
	 */
	public void addStaticLoopET(long bCET, long wCET) {
		staticLoopBCETs.add(bCET);
		staticLoopWCETs.add(wCET);
	}
	
	/**
	 * Get all worst case delays for all iterations of the 
	 * loops that contain this Atomic Block.
	 * The array starts with the inner most loop and 
	 * progressing to the outside.
	 * 
	 * @return Enumeration of nested worst case loop delays
	 */
	public ArrayList<Long> getStaticLoopWCETs() {
		return staticLoopWCETs;
	}

	/**
	 * Append one maxIteration value to the array containing
	 * iteration counts of all nested loops that contain this
	 * block.
	 * This can be (and is) set in the expression analysis.
	 * 
	 * @param innerMaxEF The maximum execution frequency of the loop.
	 */
	public void addMaxLoopIteration(int innerMaxEF) {
		maxLoopIterations.add(innerMaxEF);
	}

	/**
	 * @param i the iteration (==array)index
	 * @return BCET at i. iteration.
	 */
	public long getBCET(int i) {
		if (iterationBounds.size() == 0) return -1;
		return iterationBounds.get(i).getFirst();
	}

	/**
	 * @param i the iteration (==array) index
	 * @return WCET at i. iteration.
	 */
	public long getWCET(int i) {
		if (iterationBounds.size() == 0) return -1;
		return iterationBounds.get(i).getSecond();
	}

	/**
	 * Only for peq.notify
	 * @return The delay for peq.notify, else 0
	 */
	public long getNotificationDelay() {
		return notificationDelay;
	}

	public void setNotificationDelay(Long d) {
		notificationDelay = d;
	}

	public void visit() {
		numVisits++;
	}

	public int getNumVisits() {
		return numVisits;
	}

	public void setNumVisits(int i) {
		numVisits = i;
	}


}
