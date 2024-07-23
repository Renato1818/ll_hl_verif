package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class EnsuresSpecification extends Specification {

	Specification ensure;
	
	public EnsuresSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification ensure) {
		super(corr_class, pvl_system);
		this.ensure = ensure;
	}
	
	public Specification getEnsure() {
		return ensure;
	}
	
	public void setEnsure(Specification ensure) {
		this.ensure = ensure;
	}
	
	@Override
	public String toString() {
		return "ensures " + ensure.toString().replace(";", "") + ";";
	}

	
}
