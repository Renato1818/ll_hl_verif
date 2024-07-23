package de.wwu.embdsys.sc2pvl.engine;

import java.util.LinkedList;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

/**
 * Creates a PVLFunction object corresponding to the given SystemC function.
 *
 */
public class FunctionTransformer {

	/**
	 * The original ScFunction.
	 */
	private final SCFunction sc_func;
	/**
	 * The corresponding PVLFunction
	 */
	private final PVLFunction pvl_func;
	/**
	 * The class the PVLFunction belongs to.
	 */
	private final PVLClass parent_class;
	/**
	 * Reference to the PVL System.
	 */
	private final PVLSystem pvl_system;

	/**
	 * Default constructor, creates a new FunctionTransformer instance.
	 * 
	 * @param sc_func    the systemC function to transform
	 * @param pvl_func   an empty PVLFunction object which will be used to store the
	 *                   transformed function
	 * @param pvl_system the PVLSystem that the transformed function will belong to
	 */
	public FunctionTransformer(SCFunction sc_func, PVLFunction pvl_func, PVLClass parentClass, PVLSystem pvl_system) {
		this.sc_func = sc_func;
		this.pvl_func = pvl_func;
		this.parent_class = parentClass;
		this.pvl_system = pvl_system;
	}

	/**
	 * Default constructor, creates a new FunctionTransformer instance.
	 * 
	 * @param sc_func    the systemC function to transform
	 * @param pvl_system the PVLSystem that the transformed function will belong to
	 */
	public FunctionTransformer(SCFunction sc_func, PVLClass parentClass, PVLSystem pvl_system) {
		this.sc_func = sc_func;
		this.pvl_func = new PVLFunction("");
		this.parent_class = parentClass;
		this.pvl_system = pvl_system;
	}

	/**
	 * Returns the transformed function.
	 *
	 */
	public PVLFunction getFunction() {
		return pvl_func;
	}

	/**
	 * Creates the function.
	 */
	public void createFunction() {
		// TODO: think about invalid inputs?
		// get name and return type
		pvl_func.setName(sc_func.getName());
		pvl_func.setReturnType(sc_func.getReturnType());
		pvl_func.setCorrClass(parent_class);
		// set pure unless it contains expressions that must not be in a pure function
		pvl_func.setPure(true);

		// transform parameters
		LinkedList<PVLVariable> parameters = new LinkedList<PVLVariable>();
		VariableTransformer var_trans = new VariableTransformer(pvl_system, parent_class);
		for (SCParameter par : sc_func.getParameters()) {
			parameters.add(var_trans.createVariable(par));
		}
		pvl_func.setParameters(parameters);

		// transform local variables
		LinkedList<PVLVariable> variables = new LinkedList<PVLVariable>();
		for (SCVariable var : sc_func.getLocalVariables()) {
			variables.add(var_trans.createVariable(var));
		}
		pvl_func.setLocalVariables(variables);

		// transform body
		LinkedList<Expression> body = new LinkedList<Expression>();
		LinkedList<PVLVariable> used_var = new LinkedList<PVLVariable>();
		ExpressionTransformer exp_trans = new ExpressionTransformer(pvl_system, parent_class, pvl_func);
		for (Expression exp : sc_func.getBody()) {
			LinkedList<Expression> create = exp_trans.createExpression(exp, used_var, new LinkedList<Expression>());
			if (create != null)
				body.addAll(create);
		}

		pvl_func.setBody(body);
		pvl_system.addSpecifiable(pvl_func);
		pvl_system.getFunctions().put(new Pair<SCFunction, PVLClass>(sc_func, parent_class), pvl_func);
	}

}
