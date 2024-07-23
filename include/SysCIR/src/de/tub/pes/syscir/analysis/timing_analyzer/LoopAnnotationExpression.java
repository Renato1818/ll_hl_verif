package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

public class LoopAnnotationExpression extends Expression {

	private static final long serialVersionUID = 4143335370345682893L;

	public LoopAnnotationExpression(Node n) {
		super(n);
		// TODO Auto-generated constructor stub
	}

	public LoopAnnotationExpression(Node n, String label) {
		super(n, label);
		// TODO Auto-generated constructor stub
	}

	public LoopAnnotationExpression(Node n, Expression parent) {
		super(n, parent);
		// TODO Auto-generated constructor stub
	}

	public LoopAnnotationExpression(Node n, String label, Expression parent) {
		super(n, label, parent);
		// TODO Auto-generated constructor stub
	}

	@Override
	public LinkedList<Expression> crawlDeeper() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void replaceInnerExpressions(
			List<Pair<Expression, Expression>> replacements) {
		// TODO Auto-generated method stub

	}

}
