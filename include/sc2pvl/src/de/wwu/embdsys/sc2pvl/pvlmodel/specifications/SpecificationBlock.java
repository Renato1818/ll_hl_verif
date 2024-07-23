package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import java.util.List;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class SpecificationBlock extends Specification{

	List<Specification> specs;
	
	public SpecificationBlock(List<Specification> specs, PVLClass corr_class, PVLSystem pvl_system) {
		super(corr_class, pvl_system);
		this.specs = specs;
	}
	
	public String toString() {
		StringBuilder ret = new StringBuilder();
		for(Specification spec : specs) {
			ret.append(spec.toString().trim().replaceAll(";$", ""));
			ret.append(" **\n");
		}
		if(specs.size() > 0) ret = new StringBuilder(ret.substring(0, ret.lastIndexOf("**")));
		return ret.toString();
	}
}
