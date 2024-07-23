package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

/**
 * Represents an assert speficiation.
 * Syntax of the specification: assert spec;
 * @author pablohm
 *
 */
public class AssertSpecification extends Specification{
	
	/**
	 * The specification that needs to be asserted.
	 */
	Specification assert_spec;
	
	/**
	 * Default constructor initializing the field.
	 * @param assert_spec the specification to assert
	 */
	public AssertSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification assert_spec) {
		super(corr_class, pvl_system);
		this.assert_spec = assert_spec;
	}
	
	/**
	 * Returns the specification to assert.
	 */
	public Specification getAssert() {
		return assert_spec;
	}

	/**
	 * Sets the specification to assert.
	 * @param new_assert the new specification
	 */
	public void setAssert(Specification new_assert) {
		this.assert_spec = new_assert;
	}
	
	/**
	 * Generates a string representation which corresponds to the syntax of the assert specification in PVL.
	 */
	@Override
	public String toString() {
		return "assert " + assert_spec.toString().replace(";", "") + ";";
	}
}
