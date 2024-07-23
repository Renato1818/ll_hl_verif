package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

/**
 * Represents a PVL Expression of the Array Declaration statement. Syntax of the
 * expression: Type var = new Type[amount]; var[0] = ..; var[1] = ...;
 *
 */
public class PVLArrayExpression extends Expression {

	@Serial
	private static final long serialVersionUID = 6705239639684098704L;

	/**
	 * The array that is declared.
	 */
	private PVLVariable variable;

	/**
	 * Initial values of the array, can be null.
	 */
	private LinkedList<Expression> initialValues;

	/**
	 * Size of the array.
	 */
	private Expression size;

	/**
	 * Constructor representing an array declaration with initial values statement
	 * in PVL. Statement is of form Type var = new Type[amount]; var[0] = ..; var[1]
	 * = ...;
	 * 
	 * @param n         Node -> not used here just needed to extend Expression
	 * @param v         array that is declared
	 * @param firstInit initial values of the declared variable
	 */
	public PVLArrayExpression(Node n, PVLVariable v, List<Expression> firstInit, Expression size) {
		this(n, v);
		setInitialValues(firstInit);
		this.size = size;
	}

	/**
	 * Constructor representing an array declaration without initial values
	 * statement in PVL. Statement is of form Type var;
	 * 
	 * @param n Node -> not used here just needed to extend Expression
	 * @param v array that is declared
	 */
	public PVLArrayExpression(Node n, PVLVariable v) {
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
	 * Returns the initial values. null if no initial value is given.
	 */
	public List<Expression> getInitialValues() {
		return initialValues;
	}

	/**
	 * Sets the initial values.
	 */
	public void setInitialValues(List<Expression> val) {
		if (val != null) {
			initialValues = new LinkedList<Expression>(val);
		}
	}

	/**
	 * Gets the size of the array.
	 */
	public Expression getSize() {
		return size;
	}

	/**
	 * Sets the size of the array.
	 */
	public void setSize(Expression size) {
		this.size = size;
	}

	/**
	 * Generates a string representation which corresponds to the syntax of the
	 * declaration statement in PVL.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder(super.toString());
		ret.append(variable.toStringNoType().replace(";", ""));
		ret.append(" = new ").append(variable.getType()).append("[").append(size).append("]").append(";");
		if (initialValues != null && initialValues.size() > 0) {
			for (int i = 0; i < initialValues.size(); i++) {
				ret.append("\n");
				ret.append(variable.getName()).append("[").append(i).append("] = ").append(initialValues.get(i).toString().replace(";", ""));
				ret.append(";");
			}

			ret.append(";");
		}
		return ret.toString();
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public LinkedList<Expression> crawlDeeper() {
		return new LinkedList<Expression>(initialValues);
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {
	}
}
