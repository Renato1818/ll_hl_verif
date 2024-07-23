package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;

/**
 * Representation of a sequence declaration expression. Syntax of the
 * expression: sequence = [values[0], ... , values[n]];
 *
 */
public class PVLSequenceDeclarationExpression extends Expression {

	@Serial
	private static final long serialVersionUID = -3577460490759629175L;
	/**
	 * The sequence to be declared.
	 */
	PVLVariableExpression sequence;
	/**
	 * The values of the sequence.
	 */
	List<Expression> values;

	/**
	 * Standard constructor.
	 * 
	 * @param n        Node -> not used here just needed to extend expression
	 * @param sequence The sequence to be declared
	 * @param values   The values of the seuqence
	 */
	public PVLSequenceDeclarationExpression(Node n, PVLVariableExpression sequence, List<Expression> values) {
		super(n);
		this.sequence = sequence;
		this.values = values;
	}

	/**
	 * Returns the declared sequence.
	 */
	public PVLVariableExpression getSequence() {
		return sequence;
	}

	/**
	 * Sets the sequence.
	 */
	public void setSequence(PVLVariableExpression sequence) {
		this.sequence = sequence;
	}

	/**
	 * Returns the values of the declaration.
	 */
	public List<Expression> getValues() {
		return values;
	}

	/**
	 * Sets the values of the declaration.
	 */
	public void setValues(List<Expression> values) {
		this.values = values;
	}

	/**
	 * Adds a value to the declaration.
	 */
	public void addValue(Expression value) {
		values.add(value);
	}

	/**
	 * Returns a string representation of the expression.
	 */
	public String toString() {
		StringBuilder ret = new StringBuilder(sequence.toString().replace(";", "") + " = [");
		for (Expression value : values) {
			ret.append(value.toString().replace(";", ""));
			ret.append(",");
		}
		if (values.size() > 0)
			ret = new StringBuilder(ret.substring(0, ret.lastIndexOf(",")));
		ret.append("];");
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
