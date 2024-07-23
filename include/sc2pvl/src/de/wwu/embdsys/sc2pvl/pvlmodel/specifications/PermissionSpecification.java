package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class PermissionSpecification extends Specification {

	private VariableSpecification var;
	private float perm;
	
	public PermissionSpecification(PVLClass corr_class, PVLFunction corr_function, PVLSystem pvl_system, VariableSpecification var, float perm) {
		super(corr_class,corr_function, pvl_system);
		this.var = var;
		this.perm = perm;
	}

	public PermissionSpecification(PVLClass corr_class, PVLSystem pvl_system, VariableSpecification var, float d) {
		super(corr_class, pvl_system);
		this.var = var;
		this.perm = d;
	}

	public VariableSpecification getVar() {
		return var;
	}

	public void setVar(VariableSpecification var) {
		this.var = var;
	}

	public float getPerm() {
		return perm;
	}

	public void setPerm(float perm) {
		this.perm = perm;
	}

	@Override
	public String toString() {
		String ret = "Perm(" + var.toString().replace(";", "") + ", ";
		if(perm == 1) ret += "write";
		else if (perm > 0) ret +="read";
		else ret+= perm;
		ret +=");";
		return ret;
	}
	
	
	
}
