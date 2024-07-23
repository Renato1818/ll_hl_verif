package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLNestedVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSequenceAccessVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

public class VariableSpecification extends Specification{

	protected PVLVariable var;

	public VariableSpecification(PVLSystem pvl_system, PVLClass corr_class, PVLVariable var) {
		super(corr_class, pvl_system);
		this.var = var;
	}

	public VariableSpecification(PVLClass corr_class,PVLFunction corr_function,Expression corr_loop, PVLSystem pvl_system, PVLVariable var) {
		super(corr_class,corr_function,corr_loop, pvl_system);
		this.var = var;
	}

	public VariableSpecification(PVLClass corr_class, PVLFunction corr_function, PVLSystem pvl_system, PVLVariable var) {
		super(corr_class,corr_function, pvl_system);
		this.var = var;
	}

	public PVLVariable getVar() {
		return var;
	}

	public void setVar(PVLVariable var) {
		this.var = var;
	}

	@Override
	public String toString() {
		if(var instanceof PVLNestedVariable || var instanceof PVLSequenceAccessVariable) {
			return super.toString() + var.toString().replace(";", "") + ";";
		}
		else {
			return super.toString() + var.getName() + ";";
		}
		/*
		if(var.getCorr_class().equals(corr_class)) {
			return super.toString() + var.getName() + ";";
		}
		else {
			String name = var.getName();
			if(var instanceof PVLNestedVariable) name = var.toString();
			PVLVariable ref_corr = corr_class.getFieldByType(var.getCorr_class().getName());
			if(ref_corr!= null) {
				return super.toString() + ref_corr.getName() + "."+ name + ";";
			}
			else if(var.getCorr_class().getName().equals("Main")) {
				PVLVariable main_ref = corr_class.getFieldByType("Main");
				return main_ref.getName() + "."  +name + ";";
			}
			else if(pvl_system.getClassByName("Main").getFieldByType(var.getCorr_class().getName()) != null){
				//check in main
				PVLVariable corr_main = pvl_system.getClassByName("Main").getFieldByType(var.getCorr_class().getName());
				PVLVariable main_ref = corr_class.getFieldByType("Main");
				return main_ref.getName() + "." + corr_main.getName()+"." + name + ";";
			}
			else {
				return "fixthis." + var.getCorr_class().getName()+"." + name + ";";
			}
		}*/
	}
}
