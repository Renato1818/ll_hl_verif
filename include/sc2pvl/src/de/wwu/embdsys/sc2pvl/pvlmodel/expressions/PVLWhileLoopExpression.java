package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;

/**
 * Represents a PVL Expression of the While Loop Statement. Syntax of the
 * expression: while(condition) {body}
 *
 */
public class PVLWhileLoopExpression extends PVLLoopExpression {

	@Serial
	private static final long serialVersionUID = 5612140362341151724L;

	/**
	 * Standard constructor for the For loop.
	 * 
	 * @param n         Node -> not used here just needed to extend Expression
	 * @param l         -> not used here just needed to extend Expression
	 * @param cond      Condition of the loop
	 * @param body      body of the Loop
	 * @param corrClass Class this loop is used in
	 */
	public PVLWhileLoopExpression(Node n, String l, Expression cond, List<Expression> body, PVLClass corrClass, List<Expression> path_condition) {
		super(n, l, cond, body, corrClass, path_condition);
	}

	/**
	 * Generates a string representation of the loop expression.
	 */
	public String toString() {
		StringBuilder ret = new StringBuilder();
		for (Specification s : getSpecifications()) {
			ret.append(s.toString()).append("\n");
		}
		ret.append("while (").append(getCondition().toString().replace(";", "")).append(") {");
		List<Expression> loopBody = getLoopBody();
		for (Expression e : loopBody) {
			if (e != null) {
				ret.append("\n").append(e.toString());
			}
		}
		return ret + "\n}";
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
