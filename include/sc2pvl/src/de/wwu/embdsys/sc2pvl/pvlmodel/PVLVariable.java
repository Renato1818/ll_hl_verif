package de.wwu.embdsys.sc2pvl.pvlmodel;

import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Internal representation for pvl variables.
 */
public class PVLVariable {

	/**
	 * Name of the PVL variable.
	 */
	protected String name = "";

	/**
	 * Type of the PVL type.
	 */
	protected String type = "";

	/**
	 * If the variable is a class field this can contain the declaration.
	 */
	protected Expression dec = null;

	/**
	 * Instance of the class the variable is declared in
	 */
	protected PVLClassInstance instance;

	/**
	 * Corresponding SCVariable if exists.
	 */
	protected SCVariable scvar = null;

	/**
	 * If the variable is a class field this is a reference to the class this field
	 * belongs to.
	 */
	protected PVLClass corr_class;

	/**
	 * Standard constructor, sets the name and type of the PVL variable.
	 * 
	 * @param name Name of the variable
	 * @param type Type of the variable
	 */
	public PVLVariable(String name, String type, PVLClass corr_class) {
		this.name = name;
		this.type = type;
		this.corr_class = corr_class;
	}

	/**
	 * Standard constructor, sets the name and type of the PVL variable.
	 * 
	 * @param name       Name of the variable
	 * @param type       Type of the variable
	 * @param corr_class The Class the variable is a type of
	 * @param ins        Class instance where the variable is declared in
	 */
	public PVLVariable(String name, String type, PVLClass corr_class, PVLClassInstance ins) {
		this.name = name;
		this.type = type;
		this.corr_class = corr_class;
		this.instance = ins;
	}

	/**
	 * Gets the name of the variable.
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name of the variable.
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * Gets the type of the variable.
	 */
	public String getType() {
		return type;
	}

	/**
	 * Sets the type of the variable.
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * Sets the expression corresponding to the declaration of the variable.
	 */
	public void setDeclaration(Expression dec) {
		this.dec = dec;
	}

	/**
	 * Gets the Expression corresponding to the declaration of the variable.
	 */
	public Expression getDeclaration() {
		return dec;
	}

	/**
	 * Sets the SCVariable.
	 */
	public void setSCVariable(SCVariable var) {
		this.scvar = var;
	}

	/**
	 * Returns the SCVariable.
	 */
	public SCVariable getSCVariable() {
		return scvar;
	}

	/**
	 * Returns the class that variable is a type of.
	 */
	public PVLClass getCorrClass() {
		return corr_class;
	}

	/**
	 * Sets the class that variable is a type of.
	 */
	public void setCorrClass(PVLClass corr_class) {
		this.corr_class = corr_class;
	}

	/**
	 * Returns the class instance this variable belongs to.
	 */
	public PVLClassInstance getInstance() {
		return instance;
	}

	/**
	 * Sets the class instance this variable belongs to.
	 */
	public void setInstance(PVLClassInstance instance) {
		this.instance = instance;
	}

	/**
	 * Generates a string representation which corresponds to the syntax of fields
	 * in PVL.
	 */
	public String toString() {
		return type + " " + name + ";";
	}

	/**
	 * Generates a string representation without the type.
	 */
	public String toStringNoType() {
		return name + ";";
	}
	
	public boolean equals(PVLVariable other) {
		if (other == null) return false;
		return name.equals(other.name) && type.equals(other.type) && corr_class.equals(other.corr_class);
	}

}
