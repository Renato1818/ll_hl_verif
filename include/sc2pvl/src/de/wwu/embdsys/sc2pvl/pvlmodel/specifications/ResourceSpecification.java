package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class ResourceSpecification extends Specification {
	Specification spec;
	String name;
	
	public ResourceSpecification(String name, Specification spec, PVLClass corr_class, PVLSystem pvl_system) {
		super(corr_class, pvl_system);
		this.spec = spec;
		this.name = name;
	}

	public Specification getSpecification() {
		return spec;
	}

	public void setSpecification(Specification spec) {
		this.spec = spec;
	}
	
	public String toString() {
		String ret = "resource " + name + "() = ";
		ret += spec.toString().replace(";", "");
		ret += ";";
		return ret;
	}
}
