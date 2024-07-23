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
 * Represents a PVL Expression of the For Loop Statement. Syntax of the
 * expression: for(initializer, condition, iterator) {body}
 *
 */
public class PVLForLoopExpression extends PVLLoopExpression {

	@Serial
	private static final long serialVersionUID = 7218778888229449694L;
	/**
	 * Initializer of the Loop.
	 */
	private Expression initializer;
	/**
	 * Iterator of the Loop.
	 */
	private Expression iterator;

	/**
	 * Standard constructor for the For loop.
	 * 
	 * @param n           Node -> not used here just needed to extend Expression
	 * @param l           -> not used here just needed to extend Expression
	 * @param initializer Initializer of the loop
	 * @param condition   Condition of the loop
	 * @param iterator    Iterator of the loop
	 * @param body        body of the Loop
	 * @param corrClass   Class this loop is used in
	 */
	public PVLForLoopExpression(Node n, String l, Expression initializer, Expression condition, Expression iterator,
			List<Expression> body, PVLClass corrClass, List<Expression> path_condition) {
		super(n, l, condition, body, corrClass, path_condition);
		setInitializer(initializer);
		setIterator(iterator);
	}

	/**
	 * Generates a string representation of the loop expression.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder();
		for (Specification s : getSpecifications()) {
			ret.append(s.toString()).append("\n");
		}
		ret.append("for (").append(initializer.toString().replace(";", "")).append("; ").append(getCondition().toString().replace(";", "")).append("; ").append(iterator.toString().replace(";", "")).append(") {");
		for (Expression e : getLoopBody()) {
			ret.append("\n").append(e.toString());
		}
		return ret + "\n}";
	}

	/**
	 * Returns the initializer.
	 */
	public Expression getInitializer() {
		return initializer;
	}

	/**
	 * Sets the initializer.
	 */
	public void setInitializer(Expression initializer) {
		this.initializer = initializer;
		this.initializer.setParent(this);
	}

	/**
	 * Returns the iterator.
	 */
	public Expression getIterator() {
		return iterator;
	}

	/**
	 * Sets the iterator.
	 */
	public void setIterator(Expression iterator) {
		this.iterator = iterator;
		this.iterator.setParent(this);
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