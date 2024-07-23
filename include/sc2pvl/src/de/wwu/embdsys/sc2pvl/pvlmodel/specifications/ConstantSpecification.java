package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class ConstantSpecification extends Specification{

	String value;
	
	public ConstantSpecification(PVLClass corr_class, PVLSystem pvl_system, String value) {
		super(corr_class, pvl_system);
		this.value = value;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return value;
	}

}
