package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import java.util.List;

public interface Specifiable {
	
	public List<Specification> getSpecifications();
	public void setSpecifications(List<Specification> specs);
	public void appendSpecification(Specification spec);
	
}
