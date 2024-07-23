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
 * Represents a PVL Expression of the Sequence Access statement. Syntax of the
 * expression: var[access];
 * 
 * @author Pauline Blohm
 *
 */
public class PVLSequenceAccessExpression extends PVLVariableExpression {

	@Serial
	private static final long serialVersionUID = -6283743306798223660L;
	/**
	 * List storing the access point of the sequence. List is used to stay
	 * consistent with the SystemC sequenceAccessExpression.
	 */
	private List<Expression> access;

	/**
	 * Constructor representing an sequence access in PVL. Statement is of form
	 * sequence[access];
	 * 
	 * @param n        Node -> not used here so null
	 * @param sequence PVLVariable representing the sequence
	 * @param access   access point of the sequence
	 */
	public PVLSequenceAccessExpression(Node n, PVLVariable sequence, List<Expression> access, PVLClass pvl_class) {
		super(n, sequence, pvl_class);
		this.access = access;
	}

	/**
	 * Gets the access point of the sequence.
	 */
	public List<Expression> getAccess() {
		return access;
	}

	/**
	 * Sets the access point of the sequence.
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
		String ret = !label.equals("") ? label + ": " + var.toStringNoType() : var.toStringNoType();
		for (Expression e : access) {
			ret = ret.replace(";", "") + "[" + e.toStringNoSem() + "]";
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
