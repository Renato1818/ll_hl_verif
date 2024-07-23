package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLEventVariable;

public class PVLEventExpression extends Expression {
	
	@Serial
	private static final long serialVersionUID = -6567213763038003913L;
	
	private final PVLEventVariable event;
	
	public PVLEventExpression(Node n, PVLEventVariable event) {
		super(n);
		this.event = event;
	}

	@Override
	public LinkedList<Expression> crawlDeeper() {
		return null;
	}

	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {}

	public String toString() {
		return event.toString() + ";";
	}
}
