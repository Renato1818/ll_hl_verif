package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSizeExpression;

public class SizeSpecification extends Specification {
	
	private PVLSizeExpression var;
	
	private Expression bound;
	
	private String op;

	public SizeSpecification(PVLClass corr_class,
							 PVLSystem pvl_system,
							 PVLSizeExpression size_var,
							 String op,
							 Expression bound) {
		super(corr_class, pvl_system);
		this.setVar(size_var);
		this.setBound(bound);
		this.setOp(op);
	}

	public PVLSizeExpression getVar() {
		return var;
	}

	public void setVar(PVLSizeExpression var) {
		this.var = var;
	}

	public Expression getBound() {
		return bound;
	}

	public void setBound(Expression bound) {
		this.bound = bound;
	}

	public String getOp() {
		return op;
	}

	public void setOp(String op) {
		this.op = op;
	}
	
	public String toString() {
		return var.toString().replace(";", "") + " " + op + " " + bound.toString().replace(";", "") + ";";
	}
}
