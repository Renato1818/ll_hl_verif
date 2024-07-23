package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;

public class SequenceModifySpecification extends Specification {
	
	private final PVLVariableExpression seq;
	
	private final Expression index;
	
	private final Expression value;

	public SequenceModifySpecification(PVLClass corr_class,
									   PVLSystem pvl_system,
									   PVLVariableExpression seq,
									   Expression ind,
									   Expression val) {
		super(corr_class, pvl_system);
		this.seq = seq;
		this.index = ind;
		this.value = val;
	}

	public String toString() {
		return seq.toStringNoSem() + "[" + index.toStringNoSem() + " -> " + value.toStringNoSem() + "];";
	}
}
