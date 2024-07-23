package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

public class ArrayPermSpecification extends Specification {
	
	private final PVLVariable array;
	
	private final String permission;

	public ArrayPermSpecification(PVLClass corr_class, PVLSystem pvl_system, PVLVariable array, String perm) {
		super(corr_class, pvl_system);
		this.array = array;
		this.permission = perm;
	}
	
	public String toString() {
		return "Perm(" + array.toStringNoType().replace(";", "") + "[*], " + permission + ");";
	}

}
