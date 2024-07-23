package de.wwu.embdsys.sc2pvl.pvlmodel;

/**
 * Internal representation of a variable that is a sequence element. Used to
 * represent sequence[access];
 */
public class PVLSequenceAccessVariable extends PVLVariable {

	/**
	 * Index where the sequence is accessed.
	 */
	private final int access;

	/**
	 * Standard constructor.
	 * 
	 * @param corr_class Class where the variable is declared in
	 * @param var        Sequence variable
	 * @param access     Index that is accessed.
	 */
	public PVLSequenceAccessVariable(PVLClass corr_class, PVLVariable var, int access) {
		super(var.getName(), var.getType(), corr_class);
		this.access = access;
	}

	/**
	 * String representation of the sequence access.
	 */
	public String toString() {
		return super.toStringNoType().replace(";", "").replace(";", "") + "[" + access + "]";
	}

	/**
	 * String representation of the sequence access.
	 */
	public String toStringNoType() {
		return super.toStringNoType().replace(";", "").replace(";", "") + "[" + access + "]";
	}
}
