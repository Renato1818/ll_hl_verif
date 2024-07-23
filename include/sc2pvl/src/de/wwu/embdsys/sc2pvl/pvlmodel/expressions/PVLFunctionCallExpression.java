package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;

/**
 * Represents a PVL Expression of a Function Call. Syntax of the expression:
 * function(parameters);
 */
public class PVLFunctionCallExpression extends Expression {

	@Serial
	private static final long serialVersionUID = -7766030960094084740L;
	/**
	 * Function that is called.
	 */
	private PVLFunction function;
	/**
	 * List of parameters.
	 */
	private List<Expression> parameters;

	/**
	 * Standard constructor.
	 * 
	 * @param n         Node -> not used here just needed to extend Expression
	 * @param function  Function that is called
	 * @param params    Function parameter
	 */
	public PVLFunctionCallExpression(Node n, PVLFunction function, List<Expression> params) {
		super(n);
		setFunction(function);
		setParameters(params);
	}

	/**
	 * Sets the function.
	 */
	public void setFunction(PVLFunction function) {
		this.function = function;
	}

	/**
	 * Returns the function.
	 */
	public PVLFunction getFunction() {
		return function;
	}

	/**
	 * Sets the parameter list.
	 */
	public void setParameters(List<Expression> params) {
		if (params == null) {
			params = new LinkedList<Expression>();
		}
		this.parameters = params;
	}

	/**
	 * Add multiple parameters.
	 */
	public void addParameters(List<Expression> params) {
		this.parameters.addAll(params);
	}

	/**
	 * Add a parameter.
	 */
	public void addSingleParameter(Expression param) {
		this.parameters.add(param);
	}

	/**
	 * Returns all parameters.
	 */
	public List<Expression> getParameters() {
		return this.parameters;
	}

	/**
	 * Generates a string representation of the function call.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder();
		/*if(!pvl_class.equals(function.getCorrClass())) {
			if(pvl_class.getFieldByType(function.getCorrClass().getName()) == null) {
			 PVLVariable seqvar = ((PVLMainClass) pvl_system.getClassByName("Main")).getFieldByType(function.getCorrClass().getName());
			 PVLNestedVariable mseqaccess = new PVLNestedVariable(function.getCorrClass().getFieldByType("Main"), seqvar);
			 ret+=mseqaccess.toStringNoType()+"."; }
		}*/
		ret.append(function.getName()).append("(");
		if (parameters != null) {
			for (Expression e : parameters) {
				ret.append(e.toString().replace(";", "")).append(", ");
			}
			if (parameters.size() > 0) {
				ret = new StringBuilder(ret.substring(0, ret.length() - 2));
			}
		}
		ret.append(");");
		return ret.toString();
	}

	/**
	 * not used - needed to extend Expression
	 */
	public LinkedList<Expression> crawlDeeper() {
		return null;
	}

	/**
	 * not used - needed to extend Expression
	 */
	@Override
	public void replaceInnerExpressions(List<Pair<Expression, Expression>> replacements) {
		//
	}

}
