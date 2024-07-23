package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

public class PVLSizeExpression extends Expression {
	
	@Serial
	private static final long serialVersionUID = 6142205482838797223L;
	
	private Expression sequence;

	public PVLSizeExpression(Node n, Expression sequence) {
		super(n);
		this.setSequence(sequence);
	}

	public Expression getSequence() {
		return sequence;
	}

	public void setSequence(Expression sequence) {
		this.sequence = sequence;
	}
	
	public String toString() {
		return "|" + sequence.toString().replace(";", "") + "|;";
	}

	@Override
	public LinkedList<Expression> crawlDeeper() {
		return null;
	}

	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {}
}
