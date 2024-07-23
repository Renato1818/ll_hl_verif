package de.wwu.embdsys.sc2pvl.pvlmodel;

import java.util.LinkedList;
import java.util.List;

/**
 * Internal representation of a class instance.
 * Encapsulates the relevant information for each class instance (ids, events, etc.).
 */
public class PVLClassInstance extends PVLVariable {

	/**
	 * Class of the instance.
	 */
	private PVLClass instance_type;
	/**
	 * Class where the instance is instantiated in.
	 */
	private PVLClass instantiated_in;
	/**
	 * Whether the corresponding class is runable.
	 */
	private boolean runnable;
	/**
	 * Ids for all events that are connected to the instance.
	 */
	private int[] event_ids;
	
	/**
	 * All instances of binded ports.
	 */
	private List<PVLClassInstance> ports;
	
	/**
	 * Base constructor initializing the fields.
	 * @param instance_name Name of the instance variable
	 * @param instance_type Class of the instance
	 * @param instantiated_in Class the instance is initialized in
	 */
	public PVLClassInstance(String instance_name, PVLClass instance_type, PVLClass instantiated_in) {
		super(instance_name, instance_type.getName(), instance_type);
		this.instance_type = instance_type;
		this.instantiated_in = instantiated_in;
		this.ports = new LinkedList<PVLClassInstance>();
	}
	
	/**
	 * Returns the type of the instance variable.
	 */
	public PVLClass getInstanceType() {
		return instance_type;
	}

	/**
	 * Sets the type of the instance variable
	 */
	public void setInstanceType(PVLClass instance_type) {
		this.instance_type = instance_type;
	}
	/**
	 * Returns the class where the variable is declared in.
	 */
	public PVLClass getInstantiatedIn() {
		return instantiated_in;
	}
	/**
	 * Sets the class where the variable is declared in.
	 */
	public void setInstantiatedIn(PVLClass instantiated_in) {
		this.instantiated_in = instantiated_in;
	}
	/**
	 * Returns whether the class is runnable.
	 */
	public boolean isRunnable() {
		return runnable;
	}

	/**
	 * Sets the runnable field.
	 */
	public void setRunnable(boolean runnable) {
		this.runnable = runnable;
	}

	/**
	 * Returns all event ids.
	 */
	public int[] getEventIds() {
		return event_ids;
	}

	/**
	 * Sets the event ids.
	 */
	public void setEventIds(int[] event_ids) {
		this.event_ids = event_ids;
	}
	
	/**
	 * Returns all binded instances.
	 */
	public List<PVLClassInstance> getPorts() {
		return ports;
	}

	/**
	 * Sets all binded instances.
	 */
	public void setPorts(List<PVLClassInstance> ports) {
		this.ports = ports;
	}

	/**
	 * Adds a binded instance.
	 */
	public void addPortBinding(PVLClassInstance port) {
		this.ports.add(port);
	}
	/**
	 * Returns a string representation of the instance.
	 */
	public String toString() {
		return instance_type.getName() + " " + name + ";";
	}
	
}
