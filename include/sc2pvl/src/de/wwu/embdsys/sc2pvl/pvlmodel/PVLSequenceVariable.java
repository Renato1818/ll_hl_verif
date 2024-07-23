package de.wwu.embdsys.sc2pvl.pvlmodel;

public class PVLSequenceVariable extends PVLVariable {

	/**
	 * Defines whether the sequence contains runnable objects.
	 */
	private boolean runnable;

	/**
	 * Standard constructor.
	 * 
	 * @param name       Name of the sequence variable
	 * @param type       Type of the sequence
	 * @param runnable   Whether the sequence contains runnable objects
	 * @param corr_class Class the variable is declared in
	 */
	public PVLSequenceVariable(String name, String type, boolean runnable, PVLClass corr_class) {
		super(name, type, corr_class);
		this.runnable = runnable;
	}

	/**
	 * Returns whether the sequence contains runnable objects.
	 */
	public boolean isRunnable() {
		return runnable;
	}

	/**
	 * Sets whether the sequence contains runnable objects.
	 */
	public void setRunnable(boolean runnable) {
		this.runnable = runnable;
	}
	
	@Override
	public String getType() {
		return "seq<" + type + ">";
	}

	/**
	 * Returns a string representation of the variable.
	 */
	public String toString() {
		return getType() + " " + name + ";";
	}

}
