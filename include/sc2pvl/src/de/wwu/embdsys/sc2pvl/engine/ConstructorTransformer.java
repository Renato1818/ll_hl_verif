package de.wwu.embdsys.sc2pvl.engine;

import java.util.LinkedList;

import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLArray;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLConstructor;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLArrayExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;

/**
 * Creates a PVLConstructor object corresponding to the given SystemC
 * constructor.
 *
 */
public class ConstructorTransformer {

	/**
	 * The original ScConstructor.
	 */
	private final SCFunction sc_cons;
	/**
	 * The PVL constructor.
	 */
	private PVLConstructor cons;
	/**
	 * Reference to the pvl system.
	 */
	private final PVLSystem pvl_system;
	/**
	 * Reference to the class the constructor belongs to.
	 */
	private final PVLClass pvl_class;

	/**
	 * Default constructor, creates a new ConstructorTransformer instance.
	 * 
	 * @param constructor the systemC constructor to transform
	 * @param pvl_class   the pvl class this constructor belongs to
	 */
	public ConstructorTransformer(SCFunction constructor, PVLClass pvl_class, PVLSystem pvl_system) {
		this.sc_cons = constructor;
		this.pvl_class = pvl_class;
		this.pvl_system = pvl_system;
	}

	/**
	 * Transforms the systemC constructor to a valid pvl constructor.
	 */
	public void createConstructor() {
		this.cons = new PVLConstructor(pvl_class.getName(), pvl_class);
		// add additional parameters
		// create main parameter
		PVLVariable main_param = new PVLVariable("m_param", "Main", pvl_class);
		cons.addParameter(main_param);
		// add initialization of main
		PVLVariable main = pvl_class.getMainRef();
		pvl_system.addClassInstance(pvl_system.getClassByName(main.getType()), main);
		cons.addExpression(new BinaryExpression(null, new PVLVariableExpression(null, main, pvl_class), "=",
				new PVLVariableExpression(null, main_param, pvl_class)));
		cons.addInitialization(main, main_param);

		// add parameters of the original ScConstructor
		if (sc_cons != null) {
			VariableTransformer var_trans = new VariableTransformer(pvl_system, pvl_class);
			// transform parameters
			for (SCParameter par : sc_cons.getParameters()) {
				if (!par.getVar().getType().equals("sc_module_name")) { // this is done because the first parameter is
																		// sc_module_name name (as seen in
					// System Design in SystemC p. 15) - TODO: is there a better way to do this?
					cons.addParameter(var_trans.createVariable(par));
				}
			}

			LinkedList<PVLVariable> variables = new LinkedList<PVLVariable>();
			ExpressionTransformer exp_trans = new ExpressionTransformer(pvl_system, pvl_class, cons);
			// transform body
			for (Expression exp : sc_cons.getBody()) {
				// remove sc_module(name()) calls in constructor - TODO: find out where they are
				// coming from
				if (!(exp instanceof FunctionCallExpression
						&& ((FunctionCallExpression) exp).getFunction().getName().equals("sc_module"))) {
					cons.addExpressions(exp_trans.createExpression(exp, variables, new LinkedList<Expression>()));
				}
			}
		}
		
		for(PVLVariable field : pvl_class.getFields()) {
			//instantiate arrays if needed
			if(field instanceof PVLArray && field.getDeclaration() == null) {
				PVLArrayExpression arraydec = new PVLArrayExpression(null, field);
				arraydec.setSize(((PVLArray) field).getSize());
				field.setDeclaration(arraydec);
				cons.addExpression(arraydec);
			}
		}

		pvl_system.addSpecifiable(cons);
	}

	/**
	 * Returns the constructor.
	 * 
	 * @return The constructor
	 */
	public PVLConstructor getConstructor() {
		return cons;
	}

}
