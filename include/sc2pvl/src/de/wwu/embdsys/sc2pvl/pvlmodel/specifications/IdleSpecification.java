package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class IdleSpecification extends Specification {

	VariableSpecification var;
	
	public IdleSpecification(PVLClass corr_class, PVLSystem pvl_system, VariableSpecification var) {
		super(corr_class, pvl_system);
		this.var = var;
	}

	public VariableSpecification getVar() {
		return var;
	}

	public void setVar(VariableSpecification var) {
		this.var = var;
	}

	@Override
	public String toString() {
		return "idle(" + var.toString().replace(";", "") + ") ";
	}
}
