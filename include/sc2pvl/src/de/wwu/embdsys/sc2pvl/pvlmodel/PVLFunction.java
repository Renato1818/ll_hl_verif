package de.wwu.embdsys.sc2pvl.pvlmodel;

import java.util.LinkedList;
import java.util.List;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specifiable;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;

/**
 * Internal representation of a pvl function.
 *
 */
public class PVLFunction implements Specifiable {

	/**
	 * Name of the PVL function.
	 */
	protected String name = "";

	/**
	 * List of Parameters of the PVL function.
	 */
	protected List<PVLVariable> parameters;

	/**
	 * Return type of the PVL function.
	 */
	protected String returnType = "";

	/**
	 * Defines whether the PVL function is static.
	 */
	protected boolean isStatic = false;

	/**
	 * Defines whether the PVL function is pure.
	 */
	protected boolean pure = false;

	/**
	 * Defines whether the PVL function is abstract.
	 */
	protected boolean isAbstract = false;

	/**
	 * Body of the PVL function represented by a list of expressions.
	 */
	protected List<Expression> body;

	/**
	 * List of local Variables of the PVL function.
	 */
	protected List<PVLVariable> localVariables;

	/**
	 * The class this function belongs to.
	 */
	protected PVLClass corr_class;

	protected boolean waiting;
	/**
	 * List of specifications for the function annotation.
	 */
	protected List<Specification> specifications;

	/**
	 * Standard constructor, sets the name of the PVL function and initializes the
	 * lists.
	 * 
	 * @param name Name of the function
	 */
	public PVLFunction(String name) {
		this.name = name;
		this.parameters = new LinkedList<PVLVariable>();
		this.body = new LinkedList<Expression>();
		this.specifications = new LinkedList<Specification>();
	}

	public PVLFunction(PVLFunction pvlfunc) {
		this.name =pvlfunc.getName();
		this.parameters=pvlfunc.getParameters();
		this.body=pvlfunc.getBody();
		this.specifications=pvlfunc.getSpecifications();
		this.returnType=pvlfunc.getReturnType();
		this.isStatic=pvlfunc.isStatic();
		this.isAbstract=pvlfunc.isAbstract();
		this.pure=pvlfunc.isPure();
		this.waiting=pvlfunc.isWaiting();
		this.corr_class=pvlfunc.getCorrClass();
		this.localVariables = pvlfunc.localVariables;
	}

	/**
	 * Gets the name of the PVL function.
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name of the PVL function.
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * Gets the list of parameters of the PVL function.
	 */
	public List<PVLVariable> getParameters() {
		return parameters;
	}

	/**
	 * Sets the list of parameters of the PVL function.
	 */
	public void setParameters(List<PVLVariable> parameters) {
		this.parameters = parameters;
	}

	/**
	 * Adds a parameter to the list of parameters of the PVL function.
	 */
	public void addParameter(PVLVariable parameter) {
		this.parameters.add(parameter);
	}

	/**
	 * Gets the return type of the PVL function.
	 */
	public String getReturnType() {
		return returnType;
	}

	/**
	 * Sets the return type of the PVL function.
	 */
	public void setReturnType(String returnType) {
		this.returnType = returnType;
	}

	/**
	 * Return whether the PVL function is static.
	 */
	public boolean isStatic() {
		return isStatic;
	}

	/**
	 * Sets whether the PVL function is static.
	 */
	public void setStatic(boolean isStatic) {
		this.isStatic = isStatic;
	}

	/**
	 * Gets the body of the PVL function as a list of expressions.
	 */
	public List<Expression> getBody() {
		return body;
	}

	/**
	 * Sets the body of the PVL function.
	 */
	public void setBody(List<Expression> body) {
		this.body = body;
	}

	/**
	 * Adds an expression to the end of the body of the PVL function.
	 */
	public void addExpression(Expression expression) {
		this.body.add(expression);
	}

	/**
	 * Returns all local variables of the function.
	 */
	public List<PVLVariable> getLocalVariables() {
		return localVariables;
	}

	/**
	 * Sets the local variables of the function.
	 */
	public void setLocalVariables(List<PVLVariable> localVariables) {
		this.localVariables = localVariables;
	}

	/**
	 * Returns the class this function belongs to.
	 */
	public PVLClass getCorrClass() {
		return corr_class;
	}

	/**
	 * Sets the class this function belongs to.
	 */
	public void setCorrClass(PVLClass corr_class) {
		this.corr_class = corr_class;
	}

	/**
	 * Returns the specifications for this function.
	 */
	public List<Specification> getSpecifications() {
		return specifications;
	}

	/**
	 * Sets the specification of the function.
	 */
	public void setSpecifications(List<Specification> specifications) {
		this.specifications = specifications;
	}

	/**
	 * Adds a specification to the end of the function annotation.
	 */
	public void appendSpecification(Specification s) {
		specifications.add(s);
	}
	
	/**
	 * Adds a specification to the beginning of the function annotation.
	 */
	public void prependSpecification(Specification s) {
		specifications.add(0, s);
	}

	/**
	 * Returns whether the function is pure.
	 */
	public boolean isPure() {
		return pure;
	}

	/**
	 * Sets the pure property of the function.
	 */
	public void setPure(boolean pure) {
		this.pure = pure;
	}

	/**
	 * Returns whether the function is abstract.
	 */
	public boolean isAbstract() {
		return isAbstract;
	}

	/**
	 * Sets the abstract property of the function.
	 */
	public void setAbstract(boolean isAbstract) {
		this.isAbstract = isAbstract;
	}

	public boolean isWaiting() {
		return waiting;
	}

	public void setWaiting(boolean waiting) {
		this.waiting = waiting;
	}

	/**
	 * Produces a string representing the function in the PVL language syntax.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder();
		ret.append("//Auto-generated specifications of the function ").append(name).append(":\n");
		for (Specification spec : getSpecifications()) {
			ret.append(spec.toString());
			ret.append("\n");
		}
		if (pure)
			ret.append("pure ");
		ret.append(returnType).append(" ").append(name).append("(");

		for (PVLVariable parameter : getParameters()) {
			ret.append(parameter.getType()).append(" ").append(parameter.getName());
			ret.append(", ");
		}

		if (parameters.size() > 0) {
			ret = new StringBuilder(ret.substring(0, ret.lastIndexOf(", ")));
		}
		ret.append(")");

		if (!isAbstract) {
			ret.append("{\n");

			for (Expression expression : getBody()) {
				if (expression != null) {
					ret.append(expression.toString());
					ret.append("\n");
				}
			}

			ret.append("}");
		} else {
			ret.append(";");
		}
		return ret.toString();
	}

}
