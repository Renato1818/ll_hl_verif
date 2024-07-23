package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class TriggerSpecification extends Specification {
	
	private final Specification spec;

	public TriggerSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification spec) {
		super(corr_class, pvl_system);
		this.spec = spec;
	}
	
	public String toString() {
		return "{: " + spec.toStringNoSem() + " :}";
	}

}
