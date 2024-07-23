package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

/**
 * Class representing a PVL variable in an expression. Allows to use variables
 * in expression statements like var = 4;
 *
 */
public class PVLVariableExpression extends Expression {

	@Serial
	private static final long serialVersionUID = 8668836872085108390L;

	/**
	 * PVL variable that is used in an expression.
	 */
	protected PVLVariable var;

	/**
	 * The class the expression is in - not neccesarily the class the variable is
	 * declared in!
	 */
	private PVLClass pvl_class;

	/**
	 * Standard constructor representing a PVL variable that is used in an
	 * expression.
	 * 
	 * @param n Node -> not used here just needed to extend Expression
	 * @param v Variable that is used
	 */
	public PVLVariableExpression(Node n, PVLVariable v, PVLClass pvl_class) {
		super(n);
		this.var = v;
		this.pvl_class = pvl_class;
	}

	/**
	 * Returns the variable.
	 */
	public PVLVariable getVar() {
		return var;
	}

	/**
	 * Sets the variable.
	 */
	public void setVar(PVLVariable var) {
		this.var = var;
	}

	/**
	 * Returns the PVL class the expression is in.
	 */
	public PVLClass getPVLClass() {
		return pvl_class;
	}

	/**
	 * Sets the PVL class the expression is in.
	 */
	public void setPVLClass(PVLClass pvl_class) {
		this.pvl_class = pvl_class;
	}

	/**
	 * Generates a string representation which contains the name of the PVL
	 * variable.
	 */
	@Override
	public String toString() {
		return super.toString() + var.toStringNoType() + ";";
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public LinkedList<Expression> crawlDeeper() {
		return new LinkedList<Expression>();
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {
	}
}
