package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import java.util.LinkedList;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class LoopInvariantSpecification extends Specification{

	LinkedList<Specification> invariants;

	public LoopInvariantSpecification(PVLClass corr_class, PVLSystem pvl_system,
			LinkedList<Specification> invariants) {
		super(corr_class, pvl_system);
		this.invariants = invariants;
	}

	public LinkedList<Specification> getInvariants() {
		return invariants;
	}

	public void setInvariants(LinkedList<Specification> invariants) {
		this.invariants = invariants;
	}
	
	public String toString() {
		StringBuilder ret = new StringBuilder("loop_invariant ");
		for(Specification spec : invariants) {
			ret.append(spec.toString().replace(";", ""));
			ret.append(" ** \n");
		}
		
		if (invariants.size() > 0) {
			ret = new StringBuilder(ret.substring(0, ret.lastIndexOf("** \n")));
		}
		ret.append(";");
		return ret.toString();
	}

	
	
	
}
