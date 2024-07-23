package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Represents a PVL Expression of the Fork Statement. Syntax of the expression:
 * fork exp;
 *
 */
public class PVLForkExpression extends Expression {

	@Serial
	private static final long serialVersionUID = 1882174110825724902L;
	/**
	 * Expression of the fork statement
	 */
	protected Expression exp;

	/**
	 * Standard constructor representing the fork expression in PVL
	 * 
	 * @param n   Node -> not used here just needed to extend Expression
	 * @param exp Expression in fork exp;
	 */
	public PVLForkExpression(Node n, Expression exp) {
		super(n);
		this.exp = exp;
	}

	/**
	 * Returns the expression of the statement
	 */
	public Expression getExp() {
		return exp;
	}

	/**
	 * Sets the expression of the statement
	 */
	public void setExp(Expression exp) {
		this.exp = exp;
	}

	/**
	 * Generates a string representation which corresponds to the syntax of the fork
	 * statement in PVL.
	 */
	@Override
	public String toString() {
		return "fork " + exp.toString().replace(";", "") + ";";
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public LinkedList<Expression> crawlDeeper() {
		return null;
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {
	}
}
