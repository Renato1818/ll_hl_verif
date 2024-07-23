package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Represents a PVL Expression of the lock Statement. Syntax of the expression:
 * unlock exp;
 * 
 * @author Pauline Blohm
 *
 */
public class PVLUnlockExpression extends Expression {

	@Serial
	private static final long serialVersionUID = -7119163038277781622L;
	/**
	 * Expression of the unlock statement
	 */
	protected Expression exp;

	/**
	 * Standard constructor representing the unlock expression in PVL
	 * 
	 * @param n   Node -> not used here just needed to extend Expression
	 * @param exp Expression in unlock exp;
	 */
	public PVLUnlockExpression(Node n, Expression exp) {
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
	 * Generates a string representation which corresponds to the syntax of the
	 * unlock statement in PVL.
	 */
	@Override
	public String toString() {
		return "unlock " + exp.toString().replace(";", "") + ";";
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
