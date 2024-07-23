package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class Specification {

	PVLFunction corr_function;
	PVLClass corr_class;
	Expression corr_loop;
	PVLSystem pvl_system;
	
	
	public Specification(PVLClass corr_class, PVLFunction corr_function, PVLSystem pvl_system) {
		super();
		this.corr_function = corr_function;
		this.pvl_system = pvl_system;
		this.corr_class = corr_class;
	}
	
	public Specification(PVLClass corr_class, PVLFunction corr_function, Expression corr_loop, PVLSystem pvl_system) {
		super();
		this.corr_loop = corr_loop;
		this.corr_function = corr_function;
		this.pvl_system = pvl_system;
	}

	public Specification(PVLClass corr_class, PVLSystem pvl_system) {
		super();
		this.corr_class = corr_class;
		this.pvl_system = pvl_system;
	}

	public PVLFunction getCorr_function() {
		return corr_function;
	}
	public void setCorr_function(PVLFunction corr_function) {
		this.corr_function = corr_function;
	}
	public PVLClass getCorr_class() {
		return corr_class;
	}
	public void setCorr_class(PVLClass corr_class) {
		this.corr_class = corr_class;
	}
	public Expression getCorr_loop() {
		return corr_loop;
	}
	public void setCorr_loop(Expression corr_loop) {
		this.corr_loop = corr_loop;
	}

	@Override
	public String toString() {
		return "";
	}

	public String toStringNoSem() {
		return this.toString().replace(";", "");
	}
	
	
}
