package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class OldSpecification extends Specification {

	Specification var;
	
	public OldSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification var) {
		super(corr_class, pvl_system);
		this.var = var;
	}

	public Specification getVar() {
		return var;
	}

	public void setVar(Specification var) {
		this.var = var;
	}

	@Override
	public String toString() {
		return "\\old(" + var.toString().replace(";", "") + ");";
	}
}
