package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

/**
 * Represent a variable declaration in PVL. Expression is of the form Type var;
 * or Type var = initialValue;
 *
 */
public class PVLVariableDeclarationExpression extends Expression {

	@Serial
	private static final long serialVersionUID = -3245075009455366053L;

	/**
	 * The variable that is declared.
	 */
	private PVLVariable variable;

	/**
	 * Initial value of the variable, can be null.
	 */
	private Expression initialValue;

	/**
	 * Constructor representing a variable declaration with an initial value
	 * statement in PVL. Statement is of form Type var = initialValue;
	 * 
	 * @param n         Node -> not used here just needed to extend Expression
	 * @param v         variable that is declared
	 * @param firstInit initial value of the declared variable
	 */
	public PVLVariableDeclarationExpression(Node n, PVLVariable v, Expression firstInit) {
		this(n, v);
		setInitialValue(firstInit);
	}

	/**
	 * Constructor representing a variable declaration without an initial value
	 * statement in PVL. Statement is of form Type var;
	 * 
	 * @param n Node -> not used here just needed to extend Expression
	 * @param v variable that is declared
	 */
	public PVLVariableDeclarationExpression(Node n, PVLVariable v) {
		super(n);
		setVariable(v);
	}

	/**
	 * Returns the variable to be declared.
	 */
	public PVLVariable getVariable() {
		return this.variable;
	}

	/**
	 * Sets the variable to be declared.
	 */
	public void setVariable(PVLVariable variable) {
		this.variable = variable;
	}

	/**
	 * Returns the initial value. null if no initial value is given.
	 */
	public Expression getInitialValue() {
		return initialValue;
	}

	/**
	 * Sets the initial value.
	 */
	public void setInitialValue(Expression val) {
		if (val != null) {
			val.setParent(this);
			initialValue = val;
		}
	}

	/**
	 * Generates a string representation which corresponds to the syntax of the
	 * declaration statement in PVL.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder(super.toString());
		ret.append(variable.toString().replace(";", ""));
		if (initialValue != null) {
			ret.append(" = ");
			ret.append(initialValue.toString().replace(";", ""));
		}
		ret.append(";");
		return ret.toString();
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public LinkedList<Expression> crawlDeeper() {
		LinkedList<Expression> ret = new LinkedList<Expression>();
		ret.add(initialValue);
		return ret;
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {
	}
}
