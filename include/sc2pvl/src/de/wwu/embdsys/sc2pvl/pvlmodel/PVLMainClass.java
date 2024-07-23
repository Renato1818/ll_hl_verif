package de.wwu.embdsys.sc2pvl.pvlmodel;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Internal representation of the Main class of the PVL System.
 * Extends the regular PVL classes by adding special sequence variables. * 
 */
public class PVLMainClass extends PVLClass {

	/**
	 * Sequence variable consisting of one  boolean entry for each runnable instance.
	 */
	private PVLSequenceVariable process_state;
	/**
	 * Sequence variable consisting of one integer entry for each runnable instance.
	 */
	private PVLSequenceVariable event_state;
	
	private final LinkedList<Expression> all_not_ready_cond;
	
	/**
	 * Base constructor.
	 */
	public PVLMainClass() {
		super("Main");
		all_not_ready_cond = new LinkedList<Expression>();
	}

	/**
	 * Returns all sequence fields that are class sequences.
	 */
	public LinkedList<PVLSequenceVariable>  getAllClassSequenceFields() {
		LinkedList<PVLSequenceVariable> class_sequences = new LinkedList<>();
		for(PVLVariable field: getFields()) {
			if(field instanceof PVLSequenceVariable && !(field.getType().equals("int") || field.getType().equals("boolean"))) {
				class_sequences.add((PVLSequenceVariable) field);
			}
		}
		return class_sequences;
	}
	
	/**
	 * Returns all  sequence fields that are not class sequences.
	 */
	public LinkedList<PVLSequenceVariable>  getAllNotClassSequenceFields() {
		return new LinkedList<PVLSequenceVariable>(List.of(process_state, event_state));
	}
	
	/**
	 * Returns the process state sequence.
	 */
	public PVLSequenceVariable getProcessState() {
		return process_state;
	}

	/**
	 * Sets the process state sequence.
	 */
	public void setProcessState(PVLSequenceVariable process_state_seq) {
		this.process_state = process_state_seq;
	}

	/**
	 * Returns the event state sequence.
	 */
	public PVLSequenceVariable getEventState() {
		return event_state;
	}
	
	/**
	 * Sets the event state sequence.
	 */
	public void setEventState(PVLSequenceVariable event_state_seq) {
		this.event_state = event_state_seq;
	}
	
	/**
	 * Returns the multicondition that no process can be ready
	 */
	public LinkedList<Expression> getAllNotReadyCond() {
		return all_not_ready_cond;
	}
}
