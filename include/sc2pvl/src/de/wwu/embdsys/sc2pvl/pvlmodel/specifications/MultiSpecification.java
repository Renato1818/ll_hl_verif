package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import java.util.List;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class MultiSpecification extends Specification {
	
	private final List<Expression> conds;
	
	private final String op;

	public MultiSpecification(PVLClass corr_class, PVLSystem pvl_system, List<Expression> conds, String op) {
		super(corr_class, pvl_system);
		this.conds = conds;
		this.op = op;
	}

	public String toString() {
		if(conds == null || conds.size() == 0) return "";
		StringBuilder ret = new StringBuilder("(");
		for(Expression e : conds) {
			ret.append("(").append(e.toStringNoSem()).append(")");
			ret.append(" ");
			ret.append(op);
			ret.append(" ");
		}
		ret = new StringBuilder(ret.substring(0, ret.lastIndexOf(op)));
		ret.append(");");
		return ret.toString();
	}
}
