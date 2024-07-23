package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import java.util.LinkedList;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;


public class MultiConditionSpecification extends Specification {
	private LinkedList<Specification> conditions;
	
	private String op;

	public MultiConditionSpecification(PVLClass corr_class, PVLSystem system, LinkedList<Specification> conditions, String op) {
		super(corr_class, system);
		this.conditions = conditions;
		this.op = op;
	}

	public LinkedList<Specification> getConditions() {
		return conditions;
	}

	public void setConditions(LinkedList<Specification> conditions) {
		this.conditions = conditions;
	}

	public String getOp() {
		return op;
	}

	public void setOp(String op) {
		this.op = op;
	}
	
	public String toString() {
		if(conditions.size() == 0) return "";
		StringBuilder ret = new StringBuilder("(");
		for(Specification e : conditions) {
			ret.append("(").append(e.toString().replace(";", "")).append(")");
			ret.append(" ");
			ret.append(op);
			ret.append(" ");
		}
		ret = new StringBuilder(ret.substring(0, ret.lastIndexOf(op)));
		ret.append(")");
		return ret.toString();
	}
}
