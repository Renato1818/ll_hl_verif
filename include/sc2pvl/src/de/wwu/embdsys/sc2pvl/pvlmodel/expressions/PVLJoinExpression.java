package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Represents a PVL Expression of the Join Statement. Syntax of the expression:
 * join exp;
 *
 */
public class PVLJoinExpression extends Expression {

	@Serial
	private static final long serialVersionUID = -7813079026912747135L;
	/**
	 * Expression of the join statement
	 */
	protected Expression exp;

	/**
	 * Standard constructor representing the join expression in PVL
	 * 
	 * @param n   Node -> not used here just needed to extend Expression
	 * @param exp Expression in join exp;
	 */
	public PVLJoinExpression(Node n, Expression exp) {
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
	 * Generates a string representation which corresponds to the syntax of the join
	 * statement in PVL.
	 */
	@Override
	public String toString() {
		return "join " + exp.toString().replace(";", "") + ";";
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public LinkedList<Expression> crawlDeeper() {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {
		// TODO Auto-generated method stub

	}
}
