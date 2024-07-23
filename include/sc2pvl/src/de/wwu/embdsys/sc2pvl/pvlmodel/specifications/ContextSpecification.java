package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class ContextSpecification extends Specification {

	Specification context;
		
	public ContextSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification context) {
		super(corr_class, pvl_system);
		this.context = context;
	}

	public Specification getContext() {
		return context;
	}
	
	public void setContext(Specification context) {
		this.context = context;
	}
	
	@Override
	public String toString() {
		return "context " + context.toString().replace(";", "") + ";";
	}
}
