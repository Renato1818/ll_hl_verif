package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class ResourceCallSpecification extends Specification {

	VariableSpecification instance;
	String resource;
	
	//TODO: think about how to do this without a string!
	public ResourceCallSpecification(PVLClass corr_class, PVLSystem pvl_system, VariableSpecification instance, String resource) {
		super(corr_class, pvl_system);
		this.instance = instance;
		this.resource = resource;
	}

	public VariableSpecification getInstance() {
		return instance;
	}

	public void setInstance(VariableSpecification instance) {
		this.instance = instance;
	}

	public String getResource() {
		return resource;
	}

	public void setResource(String resource) {
		this.resource = resource;
	}
	
	public String toString() {
		String ret;
		if(instance!= null) ret = instance.toString().replace(";","") + "." + resource + "();";
		else ret =  resource + "();";
		return ret;
	}

}
