package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Represents a multi condition expression. Syntax of the expression:
 * condition[0] op condition[1] op ....
 * 
 */
public class PVLMultiConditionExpression extends Expression {

	@Serial
	private static final long serialVersionUID = -4275529479077323561L;

	/**
	 * List of all conditions.
	 */
	private LinkedList<Expression> conditions;

	/**
	 * Operator that is used to combine the conditions.
	 */
	private String op;

	/**
	 * 
	 * @param n          Node -> not used here just to extend Expression
	 * @param conditions Conditions that are combined
	 * @param op         Operator used to combine the conditions
	 */
	public PVLMultiConditionExpression(Node n, LinkedList<Expression> conditions, String op) {
		super(n);
		this.conditions = conditions;
		this.op = op;
	}

	/**
	 * Returns the list of conditions
	 */
	public LinkedList<Expression> getConditions() {
		return conditions;
	}

	/**
	 * Sets the list of conditions.
	 */
	public void setConditions(LinkedList<Expression> conditions) {
		this.conditions = conditions;
	}

	/**
	 * Returns the operator.
	 */
	public String getOp() {
		return op;
	}

	/**
	 * Sets the operator.
	 */
	public void setOp(String op) {
		this.op = op;
	}

	/**
	 * Returns a string representation of the expression.
	 */
	public String toString() {
		StringBuilder ret = new StringBuilder();
		for (Expression e : conditions) {
			ret.append(e.toString().replace(";", ""));
			ret.append(" ");
			ret.append(op);
			ret.append(" ");
		}
		if (ret.toString().contains(op)) {
			ret = new StringBuilder(ret.substring(0, ret.lastIndexOf(op)));
		}
		return ret.toString();
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
