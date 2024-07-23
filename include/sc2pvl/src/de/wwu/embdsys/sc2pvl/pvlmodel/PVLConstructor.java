package de.wwu.embdsys.sc2pvl.pvlmodel;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;

/**
 * Internal representation of a pvl constructor.
 */
public class PVLConstructor extends PVLFunction {

	/**
	 * List of pairs of field and constructor parameter that are mapped in the
	 * constructor body.
	 */
	private List<Pair<PVLVariable, PVLVariable>> initializations;

	/**
	 * List of all instances where the constructor was used.
	 */
	private final List<PVLClassInstance> instantiated;

	/**
	 * Standard constructor of the PVL constructor setting the name and initializing
	 * the lists.
	 * 
	 * @param name of the PVL class.
	 */
	public PVLConstructor(String name, PVLClass corr_class) {
		super(name);
		this.initializations = new LinkedList<Pair<PVLVariable, PVLVariable>>();
		this.instantiated = new LinkedList<>();
	}

	/**
	 * Constructor of the PVL constructor setting the name and initializing the
	 * lists.
	 * 
	 * @param corr_class the PVL class.
	 */
	public PVLConstructor(PVLClass corr_class) {
		super(corr_class.getName());
		this.initializations = new LinkedList<Pair<PVLVariable, PVLVariable>>();
		this.instantiated = new LinkedList<>();
	}

	/**
	 * Produces a string representing the constructor in the PVL language syntax.
	 */
	@Override
	public String toString() {
		StringBuilder ret = new StringBuilder();
		ret.append("//Auto-generated specifications of the constructor ").append(name).append(":\n");
		for (Specification spec : getSpecifications()) {
			ret.append(spec.toString());
			ret.append("\n");
		}
		ret.append(name).append("(");

		for (PVLVariable parameter : getParameters()) {
			ret.append(parameter.getType()).append(" ").append(parameter.getName());
			ret.append(", ");
		}

		if (parameters.size() > 0) {
			ret = new StringBuilder(ret.substring(0, ret.lastIndexOf(", ")));
		}
		ret.append("){\n");

		for (Expression expression : getBody()) {
			if (expression != null) {
				ret.append(expression.toString());
				ret.append("\n");
			}
		}

		ret.append("}");
		return ret.toString();
	}

	/**
	 * Returns all pairs of fields and parameters.
	 */
	public List<Pair<PVLVariable, PVLVariable>> getInitializations() {
		return initializations;
	}

	/**
	 * Sets the list of all pairs of fields and parameters.
	 */
	public void setInitializations(List<Pair<PVLVariable, PVLVariable>> initializations) {
		this.initializations = initializations;
	}

	/**
	 * Add a pair of field and parameter.
	 */
	public void addInitialization(PVLVariable field, PVLVariable param) {
		this.initializations.add(new Pair<PVLVariable, PVLVariable>(field, param));
	}

	/**
	 * Returns all uses of the constructor to initialize the class.
	 */
	public List<PVLClassInstance> getInstantiated() {
		return this.instantiated;
	}

	/**
	 * Add an instance where this constructor was used.
	 */
	public void addInstantiated(PVLClassInstance param) {
		this.instantiated.add(param);
	}

	/**
	 * Adds an expression to the body of the constructor.
	 */
	public void addExpressions(LinkedList<Expression> expression) {
		this.body.addAll(expression);
	}

}
