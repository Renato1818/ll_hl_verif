package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;

public class PVLProcessIDExpression extends Expression {
	
	@Serial
	private static final long serialVersionUID = 8760301966505706375L;
	private final PVLClass cls;

	public PVLProcessIDExpression(Node n, PVLClass cls) {
		super(n);
		this.cls = cls;
	}

	@Override
	public LinkedList<Expression> crawlDeeper() {
		return null;
	}

	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {}

	public String toString() {
		return "" + cls.getRunnableId();
	}
}
