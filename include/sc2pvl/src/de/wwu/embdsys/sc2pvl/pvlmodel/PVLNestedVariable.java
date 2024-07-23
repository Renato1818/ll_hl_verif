package de.wwu.embdsys.sc2pvl.pvlmodel;

/**
 * Internal representation of a nested variable. E.g. used to represent access
 * of fields of an instance: m.ready
 */
public class PVLNestedVariable extends PVLVariable {

	/**
	 * Outer variable of the nesting. May also be a nested variable.
	 */
	PVLVariable outer_var;
	PVLVariable inner_var;

	/**
	 * Standard constructor.
	 * 
	 * @param name       Name of the inner variable
	 * @param type       type of the inner variable
	 * @param corr_class Class where this variable is declared
	 * @param outer      Outer variable
	 */
	public PVLNestedVariable(String name, String type, PVLClass corr_class, PVLVariable outer) {
		super(name, type, corr_class);
		this.outer_var = outer;
		this.inner_var = new PVLVariable(name,type, corr_class);
	}

	/**
	 * Standard constructor.
	 * 
	 * @param outer Outer variable.
	 * @param inner Inner variable.
	 */
	public PVLNestedVariable(PVLVariable outer, PVLVariable inner) {
		super(inner.getName(), inner.getType(), inner.getCorrClass());
		this.outer_var = outer;
		this.inner_var = inner;
	}

	/**
	 * Returns the outer variable.
	 */
	public PVLVariable getOuterVar() {
		return outer_var;
	}

	/**
	 * Sets the outer variable.
	 */
	public void setOuterVar(PVLVariable outer_var) {
		this.outer_var = outer_var;
	}

	public PVLVariable getInnerVar() {
		return inner_var;
	}

	public void setInnerVar(PVLVariable inner_var) {
		this.inner_var = inner_var;
	}

	/**
	 * Returns a string representation of the nested variable.
	 */
	public String toString() {
		return outer_var.toStringNoType().replace(";", "") + "." + inner_var.toStringNoType();
	}

	/**
	 * Returns a string representation of the nested variable.
	 */
	public String toStringNoType() {
		return outer_var.toStringNoType().replace(";", "") + "." + inner_var.toStringNoType();
	}

}
