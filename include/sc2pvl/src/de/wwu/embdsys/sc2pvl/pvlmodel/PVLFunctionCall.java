package de.wwu.embdsys.sc2pvl.pvlmodel;

import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.expressions.Expression;

public class PVLFunctionCall {

	private Expression function_call;
	
	private SCFunction sc_func;
	
	private PVLFunction pvl_func;
	
	private PVLClass called_in;

	public PVLFunctionCall(Expression function_call, SCFunction sc_func, PVLFunction pvl_func, PVLClass called_in) {
		super();
		this.function_call = function_call;
		this.sc_func = sc_func;
		this.pvl_func = pvl_func;
		this.called_in = called_in;
	}

	public Expression getFunctionCall() {
		return function_call;
	}

	public void setFunctionCall(Expression function_call) {
		this.function_call = function_call;
	}

	public SCFunction getSCFunc() {
		return sc_func;
	}

	public void setSCFunc(SCFunction sc_func) {
		this.sc_func = sc_func;
	}

	public PVLFunction getPVLFunc() {
		return pvl_func;
	}

	public void setPVLFunc(PVLFunction pvl_func) {
		this.pvl_func = pvl_func;
	}
	
	public PVLClass getCalledIn() {
		return called_in;
	}
	
	public void setCalledIn(PVLClass called_in) {
		this.called_in = called_in;
	}
	
}
