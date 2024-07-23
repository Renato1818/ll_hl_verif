package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableDeclarationExpression;

public class ForAllSpecification extends Specification {
	
	private final PVLVariableDeclarationExpression iterator;
	
	private final Expression cond;
	
	private final Specification body;

	public ForAllSpecification(PVLClass corr_class,
							   PVLSystem pvl_system,
							   PVLVariableDeclarationExpression iterator,
							   Expression cond,
							   Specification body) {
		super(corr_class, pvl_system);
		this.iterator = iterator;
		this.cond = cond;
		this.body = body;
	}
	
	public String toString() {
		String res = "(\\forall " + iterator.toStringNoSem() + "; ";
		if (cond != null) {
			res += cond.toStringNoSem() + "; ";
		}
		res += body.toStringNoSem() + ");";
		return res;
	}

}
