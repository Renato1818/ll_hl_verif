package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

/**
 * Represents a comparison speficiation.
 * Syntax of the specification eg. var1 == 1
 * @author pablohm
 *
 */
public class BinarySpecification extends Specification{

	/**
	 * Specification that is compared to another specification.
	 */
	private Specification left;
	/**
	 * The Specification to compare to
	 */
	private Specification right;
	/**
	 * The comparison operator.
	 */
	private String op;
	
	/**
	 * Default constructor initializing the fields.
	 * @param left the left side of the comparison
 	 * @param right the right side of the comparison
	 * @param op the comparison operator
	 */
	public BinarySpecification(PVLClass corr_class, PVLSystem pvl_system, Specification left,
			Specification right, String op) {
		super(corr_class, pvl_system);
		this.left = left;
		this.right = right;
		this.op = op;
	}

	/**
	 * Returns the left side of the comparison.
	 */
	public Specification getLeft() {
		return left;
	}

	/**
	 * Sets the left side of the comparison.
	 */
	public void setLeft(Specification left) {
		this.left = left;
	}

	/**
	 * Returns the right side of the comparison.
	 */
	public Specification getRight() {
		return right;
	}

	/**
	 * Sets the right side of the comparison.
	 */
	public void setRight(Specification right) {
		this.right = right;
	}

	/**
	 * Returns the operator of the comparison.
	 */
	public String getOp() {
		return op;
	}

	/**
	 * Sets the operator of the comparison.
	 */
	public void setOp(String op) {
		this.op = op;
	}

	/**
	 * Generates a string representation which corresponds to the syntax of the comparison specification in PVL.
	 */
	@Override
	public String toString() {
		return "(" + left.toString().replace(";", "") + " " +op + " " + right.toString().replace(";", "") + ");";
	}
}
