package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

/**
 * Represents a PVL Expression of the Array Access statement. Syntax of the
 * expression: var[access];
 */
public class PVLArrayAccessExpression extends PVLVariableExpression {

	@Serial
	private static final long serialVersionUID = -2342698993882433116L;
	/**
	 * List storing the access point of the array. List is used to stay consistent
	 * with the SystemC ArrayAccessExpression.
	 */
	private List<Expression> access;

	/**
	 * Constructor representing an array access in PVL. Statement is of form
	 * array[access];
	 * 
	 * @param n      Node -> not used here so null
	 * @param array  PVLVariable representing the array
	 * @param access access point of the array
	 */
	public PVLArrayAccessExpression(Node n, PVLVariable array, List<Expression> access, PVLClass pvl_class,
			PVLSystem pvl_system) {
		super(n, array, pvl_class);
		this.access = access;
	}

	/**
	 * Gets the access point of the array.
	 */
	public List<Expression> getAccess() {
		return access;
	}

	/**
	 * Sets the access point of the array.
	 */
	public void setAccess(List<Expression> access) {
		this.access = access;
	}

	/**
	 * Generates a string representation which corresponds to the syntax of the
	 * declaration statement in PVL.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder(!label.equals("") ? label + ": " + var.toStringNoType() : var.toStringNoType());
		for (Expression e : access) {
			ret.append("[").append(e.toStringNoSem()).append("]");
		}
		return ret + ";";
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
