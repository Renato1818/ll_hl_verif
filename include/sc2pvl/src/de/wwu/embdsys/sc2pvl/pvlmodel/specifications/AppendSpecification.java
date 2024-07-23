package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class AppendSpecification extends Specification {
	
	private Specification seq;
	
	private Expression val;

	public AppendSpecification(PVLClass corr_class, PVLSystem pvl_system, Specification seq, Expression val) {
		super(corr_class, pvl_system);
		this.seq = seq;
		this.val = val;
	}

	public Specification getSeq() {
		return seq;
	}

	public void setSeq(Specification seq) {
		this.seq = seq;
	}

	public Expression getVal() {
		return val;
	}

	public void setVal(Expression val) {
		this.val = val;
	}
	
	public String toString() {
		return seq.toStringNoSem() + " ++ " + val.toStringNoSem();
	}
}
