package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import java.util.LinkedList;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

public class SequenceAccessSpecification extends VariableSpecification {
	
	private LinkedList<Specification> access;
	public SequenceAccessSpecification(PVLSystem pvl_system, PVLClass corr_class, PVLVariable var, LinkedList<Specification> access ) {
		super(pvl_system, corr_class, var);
		this.access = access;
	}

	public LinkedList<Specification>  getAccess() {
		return access;
	}

	public void setAccess(LinkedList<Specification>  access) {
		this.access = access;
	}

	public String toString() {
		StringBuilder ret = new StringBuilder(var.toStringNoType());
		for (Specification e : access) {
			ret.append("[").append(e.toString().replace(";", "")).append("]");
		}
		return ret + ";";
	}
}
