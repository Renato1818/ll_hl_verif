package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class RequiresSpecification extends Specification {
	Specification requires;
		
	public RequiresSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification requires) {
		super(corr_class, pvl_system);
		this.requires = requires;
	}

	public Specification getRequires() {
		return requires;
	}
	
	public void setRequires(Specification requires) {
		this.requires = requires;
	}
	
	@Override
	public String toString() {
		return "requires " + requires.toString().replace(";", "") + ";";
	}
}
