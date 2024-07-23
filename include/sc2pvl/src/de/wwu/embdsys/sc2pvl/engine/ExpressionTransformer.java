package de.wwu.embdsys.sc2pvl.engine;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPORTSCSOCKETTYPE;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.ArrayAccessExpression;
import de.tub.pes.syscir.sc_model.expressions.ArrayInitializerExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.BracketExpression;
import de.tub.pes.syscir.sc_model.expressions.BreakExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.ForLoopExpression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.NewExpression;
import de.tub.pes.syscir.sc_model.expressions.OutputExpression;
import de.tub.pes.syscir.sc_model.expressions.ReturnExpression;
import de.tub.pes.syscir.sc_model.expressions.SCClassInstanceExpression;
import de.tub.pes.syscir.sc_model.expressions.SCPortSCSocketExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableNonDetSet;
import de.tub.pes.syscir.sc_model.expressions.SwitchExpression;
import de.tub.pes.syscir.sc_model.expressions.UnaryExpression;
import de.tub.pes.syscir.sc_model.expressions.WhileLoopExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLEventVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLMainClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLNestedVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLArrayAccessExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLArrayExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLEventExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLForLoopExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLFunctionCallExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLLockExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLProcessIDExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSequenceAccessExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSizeExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLUnlockExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableDeclarationExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLWhileLoopExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specifiable;
import de.wwu.embdsys.sc2pvl.util.Constants;

/**
 * Handles the transformation of all covered SystemC expressions into PVL
 * expressions.
 *
 */
public class ExpressionTransformer {

	/**
	 * References to the PVl System.
	 */
	private final PVLSystem pvl_system;
	/**
	 * Class this expression is in.
	 */
	private final PVLClass pvl_class;
	/**
	 * Function this expression is in.
	 */
	private PVLFunction pvl_func;

	/**
	 * Standard constructor.
	 * 
	 * @param pvl_system References to the PVl System.
	 * @param pvl_class  Class the expressions are in.
	 */
	public ExpressionTransformer(PVLSystem pvl_system, PVLClass pvl_class) {
		this.pvl_system = pvl_system;
		this.pvl_class = pvl_class;
	}

	/**
	 * Standard constructor.
	 * 
	 * @param pvl_system References to the PVl System.
	 * @param pvl_class  Class the expressions are in.
	 * @param pvl_func   Function the expressions are in.
	 */
	public ExpressionTransformer(PVLSystem pvl_system, PVLClass pvl_class, PVLFunction pvl_func) {
		this.pvl_system = pvl_system;
		this.pvl_class = pvl_class;
		this.pvl_func = pvl_func;
	}

	public LinkedList<Expression> createExpression(Expression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		if (exp == null) {
			return null;
		}
		if (exp instanceof AccessExpression) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformAccessExpression((AccessExpression) exp, local_var, path_condition);
		}
		if (exp instanceof ArrayAccessExpression) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformArrayAccessExpression((ArrayAccessExpression) exp, local_var, path_condition);
		}
		if (exp instanceof BinaryExpression) {
			// if (pvl_func != null) pvl_func.setPure(false); // TODO
			return transformBinaryExpression((BinaryExpression) exp, local_var, path_condition);
		}
		if (exp instanceof BracketExpression) {
			return transformBracketExpression((BracketExpression) exp, local_var, path_condition);
		}
		if (exp instanceof ConstantExpression) {	// TODO
			return new LinkedList<Expression>(List.of(exp));
		}
		if (exp instanceof EventNotificationExpression) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformEventNotificationExpression((EventNotificationExpression) exp, local_var, path_condition);
		}
		if (exp instanceof FunctionCallExpression) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformFunctionCallExpression((FunctionCallExpression) exp, local_var, path_condition);
		}
		if (exp instanceof IfElseExpression) {
			return transformIfElseExpression((IfElseExpression) exp, local_var, path_condition);
		}
		if (exp instanceof LoopExpression) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformLoopExpression((LoopExpression) exp, local_var, path_condition);
		}
		if (exp instanceof OutputExpression) {
			return null;
		}
		if (exp instanceof ReturnExpression) {
			return transformReturnExpression((ReturnExpression) exp, local_var, path_condition);
		}
		if (exp instanceof SCPortSCSocketExpression) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformSCPortScSocketExpression((SCPortSCSocketExpression) exp, local_var, path_condition);
		}
		if (exp instanceof SCVariableDeclarationExpression) {
			return transformVariableDeclarationExpression((SCVariableDeclarationExpression) exp, local_var, path_condition);
		}
		if (exp instanceof SCVariableExpression) {
			// if (pvl_func != null) pvl_func.setPure(false); TODO
			return transformVariableExpression((SCVariableExpression) exp, local_var, path_condition);
		}
		if (exp instanceof SCVariableNonDetSet) {
			if (pvl_func != null) pvl_func.setPure(false);
			return transformNonDetSetExpression((SCVariableNonDetSet) exp, local_var, path_condition);
		}
		if (exp instanceof SwitchExpression) {
			return transformSwitchExpression((SwitchExpression) exp, local_var, path_condition);
		}
		if (exp instanceof UnaryExpression) {	// TODO
			return new LinkedList<Expression>(List.of(exp)); 
		}
		// TODO: check if other expressions need to be covered
		LinkedList<Expression> ret = new LinkedList<Expression>();
		if (pvl_func != null) pvl_func.setPure(false);
		ret.add(exp);
		return ret;
	}

	private LinkedList<Expression> transformReturnExpression(ReturnExpression exp, List<PVLVariable> local_var,
			List<Expression> path_condition) {
		LinkedList<Expression> res = new LinkedList<Expression>();
		
		Expression ret_exp = exp.getReturnStatement();
		if (ret_exp == null) {
			res.add(exp);
		}
		else {
			Expression new_ret_exp = createExpression(ret_exp, local_var, path_condition).get(0);
			// TODO: handle return statement that is factored into multiple statements
			res.add(new ReturnExpression(null, new_ret_exp));
		}
		
		return res;
	}

	private LinkedList<Expression> transformNonDetSetExpression(SCVariableNonDetSet exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		LinkedList<Expression> res = new LinkedList<Expression>();
		
		// Add randomize function to class
		PVLVariableExpression var = (PVLVariableExpression) createExpression(exp.getVar(), local_var, path_condition).get(0);
		String random_name = var.getVar().getName() + "__randomize" + pvl_class.getNrAutogeneratedFunctions();
		PVLFunction random_fun = new PVLFunction(random_name);
		random_fun.setAbstract(true);
		random_fun.setPure(true);
		random_fun.setReturnType(var.getVar().getType());
		random_fun.setCorrClass(pvl_class);
		pvl_class.addAutogeneratedFunction(random_fun);
		
		// Transform nondeterministic assignment
		PVLFunctionCallExpression call = new PVLFunctionCallExpression(null, random_fun, List.of());
		res.add(new BinaryExpression(null, var, "=", call));
		
		return res;
	}

	/**
	 * Encodes a switch statement into PVL.
	 * 
	 * @param exp		The original switch statement
	 * @param local_var List where locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return			A list of PVL statements with the same semantic effect as the switch statement
	 */
	private LinkedList<Expression> transformSwitchExpression(SwitchExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {

		LinkedList<Expression> sysc_cond = createExpression(exp.getSwitchExpression(), local_var, path_condition);
		if (sysc_cond.size() != 1) throw new IllegalArgumentException("Switch condition gets resolved to multiple statements.");  // TODO
		Expression cond = sysc_cond.get(0);
		
		List<Expression> case_statements = exp.getCases();
		Collections.reverse(case_statements);
		
		List<Expression> else_expr = new LinkedList<Expression>();
		
		for (Expression expr : case_statements) {
			LinkedList<Expression> body = new LinkedList<Expression>();
			
			CaseExpression case_expr = (CaseExpression) expr;
			
			for (Expression e : case_expr.getBody()) {
				// TODO: Handle break expressions correctly. Currently this assumes that there is one and only one break at the end of every case.
				if (!(e instanceof BreakExpression)) {
					body.addAll(createExpression(e, local_var, path_condition));	// Also TODO: switch statements don't add any path conditions currently!
				}
			}
			
			LinkedList<Expression> sysc_case_cond = createExpression(case_expr.getCondition(), local_var, path_condition);
			// default case
			if (sysc_case_cond == null) {
				else_expr = body; 
			}
			else {
				if (sysc_case_cond.size() != 1) throw new IllegalArgumentException("Switch condition gets resolved to multiple statements.");
				Expression case_cond = sysc_case_cond.get(0);
				Expression if_cond = new BinaryExpression(null, cond, "==", case_cond);
				
				IfElseExpression new_else = new IfElseExpression(null, if_cond, body, else_expr);
				else_expr = new LinkedList<Expression>(List.of(new_else));
			}
		}

		return new LinkedList<Expression>(else_expr);
	}

	/**
	 * Transforms notification expressions to PVL.
	 * 
	 * @param exp       the original SystemC expression
	 * @param local_var List where the locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return			Transformation result of event notification
	 */
	private LinkedList<Expression> transformEventNotificationExpression(EventNotificationExpression exp,
			List<PVLVariable> local_var, List<Expression> path_condition) {
		SCVariable event = ((SCVariableExpression) exp.getEvent()).getVar();
		PVLEventVariable var = pvl_func.getCorrClass().getEventByVariable(event);
		if (var == null) {
			var = new PVLEventVariable(-1);
			pvl_class.addEvent(event, var);
			pvl_system.addEvent(var);
			pvl_system.addSharedEvent(event, var);
		}
		LinkedList<Expression> ret = new LinkedList<Expression>();
		//three options: no parameters  -> immediate, one parameter -> delta delayed, two parameters -> timed delay
		
		//create m.ev_timeout = m.ev_timeout[event -> delay]
		String delay;
		switch (exp.getParameters().size()) {
			case 0 -> delay = "0";
			case 1 -> delay = "-1";
			default -> {
				long total_delay = Constants.getTimeUnits(exp.getParameters().get(0).toStringNoSem(),
						exp.getParameters().get(1).toStringNoSem());
				if (total_delay == 0) {
					delay = "-1";
				} else {
					delay = String.valueOf(total_delay);
				}
			}
		}
		PVLEventExpression var_expression = new PVLEventExpression(null, var);
		BinaryExpression waitTime0 = new BinaryExpression(null, var_expression, "->", 
				new ConstantExpression(null, delay));
		PVLVariable main = pvl_class.getMainRef();
		PVLVariable timeout_seq = ((PVLMainClass) pvl_system.getClassByName("Main")).getEventState();
		PVLNestedVariable delays = new PVLNestedVariable(main, timeout_seq);
		PVLVariableExpression delays_expression = new PVLVariableExpression(null, delays, pvl_class);
		LinkedList<Expression> access = new LinkedList<Expression>();
		access.add(waitTime0);
		PVLSequenceAccessExpression delays_access = new PVLSequenceAccessExpression(null, delays, access, pvl_class);
		BinaryExpression update_delays = new BinaryExpression(null, delays_expression, "=", delays_access);
		ret.add(update_delays);
		return ret;
	}

	/**
	 * Transforms array access expressions to PVL.
	 * 
	 * @param exp       the original SystemC expression
	 * @param local_var List where the locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return			Transformation result for an array access
	 */
	private LinkedList<Expression> transformArrayAccessExpression(ArrayAccessExpression exp,
			List<PVLVariable> local_var, List<Expression> path_condition) {
		// get variable of expression
		SCVariable var = exp.getVar();
		// find corresponding variable
		Pair<SCVariable, PVLClass> key = new Pair<SCVariable, PVLClass>(var, pvl_class);
		PVLVariable pvl_var = pvl_system.getVariables().get(key);
		// if nothing found, search in state class
		if (pvl_var == null && pvl_class.getCorrStateClass() != null) {
			key = new Pair<SCVariable, PVLClass>(var, pvl_class.getCorrStateClass());
			pvl_var = pvl_system.getVariables().get(key);
		}
		if (pvl_var != null) {
			PVLArrayAccessExpression pvl_exp;
			if (!pvl_var.getCorrClass().equals(pvl_class)) {
				List<PVLVariable> class_instances = pvl_system.getClassInstances().get(pvl_var.getCorrClass());
				PVLVariable class_var = new PVLNestedVariable(pvl_class.getMainRef(), class_instances.get(0));
				PVLNestedVariable nested_var = new PVLNestedVariable(class_var, pvl_var);
				pvl_exp = new PVLArrayAccessExpression(null, nested_var, exp.getAccess(), pvl_class, pvl_system);
			}
			else {
				pvl_exp = new PVLArrayAccessExpression(null, pvl_var, exp.getAccess(), pvl_class, pvl_system);
			}
			return new LinkedList<Expression>(List.of(pvl_exp));
		}
		// no matching variable found
		VariableTransformer var_trans = new VariableTransformer(pvl_system, pvl_class);
		pvl_var = var_trans.createVariable(var);
		// create pvl declaration

		LinkedList<Expression> ret = new LinkedList<Expression>();
		ret.add(new PVLArrayAccessExpression(null, pvl_var, exp.getAccess(), pvl_class, pvl_system));
		return ret;
	}

	/**
	 * Transforms the SystemC Expression of the type Variable Expression to a PVL
	 * Expression.
	 * 
	 * @param exp the systemc expression to transform
	 * @param path_condition Path condition at this point in the program
	 * @return	  Corresponding variable expression in PVL
	 */
	public LinkedList<Expression> transformVariableExpression(SCVariableExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		// get variable of expression
		SCVariable var = exp.getVar();
		// find corresponding variable
		Pair<SCVariable, PVLClass> key = new Pair<SCVariable, PVLClass>(var, pvl_class);
		PVLVariable pvl_var = pvl_system.getVariables().get(key);
		
		// no matching variable found; search in state class
		if (pvl_var == null && pvl_class.getCorrStateClass() != null) {
			key = new Pair<SCVariable, PVLClass>(var, pvl_class.getCorrStateClass());
			pvl_var = pvl_system.getVariables().get(key);
		}
		
		// If the variable is external to the function, make the function non-pure
		if (!pvl_func.getParameters().contains(pvl_var)) {
			pvl_func.setPure(false);
		}
		
		// if a variable was found, use it
		if (pvl_var != null) {
			PVLVariableExpression pvl_exp;
			if (!pvl_var.getCorrClass().equals(pvl_class)) {
				List<PVLVariable> class_instances = pvl_system.getClassInstances().get(pvl_var.getCorrClass());
				PVLVariable class_var = new PVLNestedVariable(pvl_class.getMainRef(), class_instances.get(0));
				PVLNestedVariable nested_var = new PVLNestedVariable(class_var, pvl_var);
				pvl_exp = new PVLVariableExpression(null, nested_var, pvl_class);
			}
			else {
				pvl_exp = new PVLVariableExpression(null, pvl_var, pvl_class);
			}
			LinkedList<Expression> ret = new LinkedList<Expression>(List.of(pvl_exp));
			if (!local_var.contains(pvl_var))
				local_var.add(pvl_var);
			return ret;
		}
		
		// There is no match; create new variable.
		VariableTransformer var_trans = new VariableTransformer(pvl_system, pvl_class);
		pvl_var = var_trans.createVariable(var);
		// create pvl declaration
		PVLVariableExpression pvl_exp = new PVLVariableExpression(null, pvl_var, pvl_class);
		if (!local_var.contains(pvl_var))
			local_var.add(pvl_var);
		LinkedList<Expression> ret = new LinkedList<Expression>();
		ret.add(pvl_exp);
		return ret;
	}

	/**
	 * Transforms the SystemC Expression of the type Variable Declaration Expression
	 * to a PVL Expression
	 * 
	 * @param exp the systemc expression to transform
	 * @param path_condition Path condition at this point in the program
	 * @return		Corresponding variable declaration in PVL
	 */
	public LinkedList<Expression> transformVariableDeclarationExpression(SCVariableDeclarationExpression exp,
			List<PVLVariable> local_var, List<Expression> path_condition) {
		Expression var = exp.getVariable();
		PVLVariable pvlvar = null;
		Expression initExp = null;

		if (var instanceof SCVariableExpression) {
			SCVariable real_var = ((SCVariableExpression) var).getVar();
			Pair<SCVariable, PVLClass> key = new Pair<SCVariable, PVLClass>(real_var, pvl_class);
			pvlvar = pvl_system.getVariables().get(key);
			// If no variable was found, search in state class
			if (pvlvar == null && pvl_class.getCorrStateClass() != null) {
				key = new Pair<SCVariable, PVLClass>(real_var, pvl_class.getCorrStateClass());
				pvlvar = pvl_system.getVariables().get(key);
			}
			// If still nothing found, create a new variable
			if (pvlvar == null) {
				VariableTransformer var_trans = new VariableTransformer(pvl_system, pvl_class);
				pvlvar = var_trans.createVariable(real_var);
			}
			if (!local_var.contains(pvlvar))
				local_var.add(pvlvar);
			// get first initial value
			initExp = exp.getFirstInitialValue();
			if (initExp instanceof ArrayInitializerExpression) {
				PVLArrayExpression array = new PVLArrayExpression(null, pvlvar);
				LinkedList<Expression> values = new LinkedList<Expression>();
				for (int i = 0; i < ((ArrayInitializerExpression) initExp).getArrayElementCount(); i++) {
					values.add(((ArrayInitializerExpression) initExp).expAtPosition(i));
				}
				array.setInitialValues(values);
				array.setSize(new ConstantExpression(null,""+((ArrayInitializerExpression) initExp).getArrayElementCount()));

				LinkedList<Expression> ret = new LinkedList<Expression>();
				ret.add(array);
				return ret;
			}
			// transform initial value into PVL syntax
			LinkedList<Expression> create = createExpression(initExp, local_var, path_condition);
			if (create != null)
				initExp = create.get(0);

		} else if (var instanceof SCClassInstanceExpression) {
			SCClass sc_class = ((SCClassInstanceExpression) var).getInstance().getSCClass();
			List<PVLClass> transformed_classes = pvl_system.getClassMappings().get(sc_class.getName());
			if (transformed_classes == null)
				return null;
			if (transformed_classes.size() == 1) {
				String class_name = transformed_classes.get(0).getName();
				class_name = class_name.substring(0, 1).toUpperCase() + class_name.substring(1);
				String var_nam = ((SCClassInstanceExpression) var).getInstance().getName();
				pvlvar = new PVLVariable(var_nam, class_name, pvl_class);
				pvl_system.addClassInstance(transformed_classes.get(0), pvlvar);
				// create new expression for initialization
				// transform initial value into PVL syntax
				NewExpression newClass = new NewExpression(null);
				newClass.setObjType(class_name);
				newClass.setArguments(exp.getInitialValues());
				LinkedList<Expression> create = createExpression(initExp, local_var, path_condition);
				if (create != null)
					initExp = create.get(0);		// TODO: What should initExp be here?!
			} else { // this case only applies to state + thread classes
						// find state class and initialize it
				LinkedList<Expression> ret = new LinkedList<Expression>();
				PVLClass state_class = null;
				for (PVLClass state : transformed_classes) {
					if (state.getName().contains("State")) {	// TODO! What is this?
						state_class = state;
						transformed_classes.remove(state);
						break;
					}
				}
				// create PVL Variable for class instantiation
				String class_name = state_class.getName();
				String var_name = ((SCClassInstanceExpression) var).getInstance().getName();
				pvlvar = new PVLVariable(var_name, class_name, pvl_class);
				pvl_system.addClassInstance(state_class, pvlvar);
				// create new expression for initialization
				NewExpression newClass = new NewExpression(null);
				newClass.setObjType(class_name);
				newClass.setArguments(exp.getInitialValues());
				// transform initial value into PVL syntax
				initExp = createExpression(newClass, local_var, path_condition).get(0);
				PVLVariableDeclarationExpression pvlExp = new PVLVariableDeclarationExpression(null, pvlvar, initExp);
				pvlvar.setDeclaration(pvlExp);
				if (!local_var.contains(pvlvar))
					local_var.add(pvlvar);
				ret.add(pvlExp);

				// argument is reference to state class
				LinkedList<Expression> arguments = new LinkedList<Expression>();
				PVLVariableExpression state_expression = new PVLVariableExpression(null, pvlvar, pvl_class);
				arguments.add(state_expression);
				// initialize thread classes and pass state class as argument
				for (PVLClass thread : transformed_classes) {
					// create PVL Variable for class instantiation
					class_name = thread.getName();
					// TODO: update this to work for multiple uses of class
					var_name = thread.getName().toLowerCase();
					PVLVariable pvlvar_thread = new PVLVariable(var_name, class_name, pvl_class);
					pvl_system.addClassInstance(thread, pvlvar_thread);
					// create new expression for initialization
					NewExpression newClass_thread = new NewExpression(null);
					newClass_thread.setObjType(class_name);
					newClass_thread.setArguments(arguments);
					// transform initial value into PVL syntax
					Expression initExp_thread = createExpression(newClass_thread, local_var, path_condition).get(0);
					PVLVariableDeclarationExpression pvlExp_thread = new PVLVariableDeclarationExpression(null,
							pvlvar_thread, initExp_thread);
					pvlvar_thread.setDeclaration(pvlExp_thread);
					if (!local_var.contains(pvlvar_thread))
						local_var.add(pvlvar_thread);
					ret.add(pvlExp_thread);
				}
				return ret;
			}
		}
		Expression pvlExp;
		// create PVL declaration
		if(pvl_class.getFieldByName(pvlvar.getName())!= null && initExp != null) {
			pvlExp = new BinaryExpression(null,new PVLVariableExpression(null, pvlvar, pvl_class),"=", initExp);
		}
		else if (pvl_class.getFieldByName(pvlvar.getName())!= null){
			return null;
		}
		else {
			pvlExp = new PVLVariableDeclarationExpression(null, pvlvar, initExp);
		}
		pvlvar.setDeclaration(pvlExp);

		LinkedList<Expression> ret = new LinkedList<Expression>();
		ret.add(pvlExp);
		return ret;
	}

	/**
	 * Transforms the SystemC Expression of the type Loop Expression to a PVL
	 * Expression.
	 * All Expressions of the Loop Body and the condition are transformed by calling
	 * the createExpression method.
	 * 
	 * @param exp the systemc expression to transform
	 * @return PVL loop
	 */
	public LinkedList<Expression> transformLoopExpression(LoopExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		// grab condition
		LinkedList<PVLVariable> body_vars = new LinkedList<PVLVariable>();
		Expression cond = exp.getCondition();
		// transform condition to PVL and set it
		Expression newCond = createExpression(cond, body_vars, path_condition).get(0);
		// grab body and transform all expressions of the body
		List<Expression> body = exp.getLoopBody();
		LinkedList<Expression> new_body = new LinkedList<Expression>();
		for (Expression e : body) {
			if (e != null) {
				List<Expression> new_path_condition = new LinkedList<Expression>(path_condition);
				new_path_condition.add(newCond);
				LinkedList<Expression> new_exp = createExpression(e, body_vars, new_path_condition);
				if (new_exp != null)
					new_body.addAll(new_exp);
			}
		}

		// set loop invariant
		// pvl_system.addSpecifiable(exp);
		local_var.addAll(body_vars);
		LinkedList<Expression> ret = new LinkedList<Expression>();
		if (exp instanceof WhileLoopExpression) {
			PVLWhileLoopExpression newExp = new PVLWhileLoopExpression(null, null, newCond, new_body, pvl_class, path_condition);
			ret.add(newExp);
			pvl_system.addSpecifiable(newExp);
		} else if (exp instanceof ForLoopExpression) {
			Expression newIterator = createExpression(((ForLoopExpression) exp).getIterator(), body_vars, path_condition).get(0);
			Expression newInitializor = createExpression(((ForLoopExpression) exp).getInitializer(), body_vars, path_condition).get(0);
			PVLForLoopExpression newExp = new PVLForLoopExpression(null, null, newInitializor, newCond, newIterator,
					new_body, pvl_class, path_condition);
			ret.add(newExp);
			pvl_system.addSpecifiable(newExp);

		}
		return ret;
	}

	/**
	 * Transforms accesss expressions to PVL.
	 * 
	 * @param exp       the original SystemC expression
	 * @param local_var List where the locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return Access in PVL
	 */
	public LinkedList<Expression> transformAccessExpression(AccessExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		LinkedList<Expression> ret = new LinkedList<Expression>();
		
		// If the access is to an SC_FIFO method, transform it to reflect waiting for the queue to not be empty/full
		if (exp.getLeft() instanceof SCPortSCSocketExpression
				&& (SCPORTSCSOCKETTYPE.SC_FIFO_ALL.contains(((SCPortSCSocketExpression) exp.getLeft()).getSCPortSCSocket().getConType()))
				&& exp.getRight() instanceof FunctionCallExpression fun) {
			
			ret.addAll(transformFIFOAccessExpression(exp, local_var, path_condition));

			PVLVariableExpression fifo = (PVLVariableExpression) transformSCPortScSocketExpression((SCPortSCSocketExpression) exp.getLeft(),
																								   local_var,
																								   path_condition).get(0);
			// TODO fix this mess
			StringBuilder params = new StringBuilder();
			LinkedList<Expression> ps = new LinkedList<Expression>();
			for (Expression param : fun.getParameters()) {
				ps.addAll(createExpression(param, local_var, path_condition));
			}
			for (Expression param : ps) {
				params.append(param.toString()).append(", ");
			}
			if (ps.size() > 0) {
				params = new StringBuilder(params.substring(0, params.length() - 2));
			}
			
			// TODO Resolve function name some other way
			ret.add(new AccessExpression(null, fifo, ".", new ConstantExpression(null, "fifo_" + fun.getFunction().getName() + "(" + params + ")")));
		}
		// Otherwise simply transform the left and right sides of the expression to PVL
		else {
			Expression left = createExpression(exp.getLeft(), local_var, path_condition).get(0);
			Expression right = createExpression(exp.getRight(), local_var, path_condition).get(0);
			// transform the Operation to . since PVL does not support pointers
			AccessExpression new_exp = new AccessExpression(null, left, ".", right);
	
			ret.add(new_exp);
		}
		return ret;
	}
	
	private LinkedList<Expression> transformFIFOAccessExpression(AccessExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		LinkedList<Expression> ret = new LinkedList<Expression>();
		
		FunctionCallExpression fun = ((FunctionCallExpression) exp.getRight());
		String fun_name = fun.getFunction().getName();
		PVLMainClass main_cls = (PVLMainClass) pvl_system.getClassByName("Main");
		
		PVLVariableExpression fifo = (PVLVariableExpression) transformSCPortScSocketExpression((SCPortSCSocketExpression) exp.getLeft(),
																							   local_var,
																							   path_condition).get(0);
		PVLVariableExpression main = new PVLVariableExpression(null, pvl_class.getMainRef(), pvl_class);
		PVLProcessIDExpression pid = new PVLProcessIDExpression(null, pvl_class);
		PVLVariable event_state = new PVLNestedVariable(pvl_class.getMainRef(), main_cls.getEventState());
		PVLVariable process_state = new PVLNestedVariable(pvl_class.getMainRef(), main_cls.getProcessState());
		
		// TODO!!!! Extremely ugly! But at this point, there is no access to the fifo fields.
		// We cannot even use the FIFO variable, because it might not be set yet.
		Expression buffer = new AccessExpression(null, fifo, ".", new ConstantExpression(null, "buffer"));
		PVLSizeExpression buffersize = new PVLSizeExpression(null, buffer);
		PVLClass fifo_cls = pvl_system.getClassByName(((PVLNestedVariable) fifo.getVar()).getInnerVar().getType());
		Expression read_event = new PVLEventExpression(null, fifo_cls.getEvents().get(0));
		Expression write_event = new PVLEventExpression(null, fifo_cls.getEvents().get(1));
		
		LinkedList<Expression> inner_body = new LinkedList<Expression>();
		LinkedList<Expression> outer_body = new LinkedList<Expression>();
		inner_body.add(new PVLUnlockExpression(null, main));
		inner_body.add(new PVLLockExpression(null, main));
		
		PVLSequenceAccessExpression occurred_acc;
		Expression mod_wo;
		Expression outer_cond;
		if (fun_name.equals("read")) {
			occurred_acc = new PVLSequenceAccessExpression(null, event_state, List.of(write_event), pvl_class);
			mod_wo = new BinaryExpression(null, pid, "->", write_event);
			outer_cond = new BinaryExpression(null, buffersize, "==", new ConstantExpression(null, "0"));
		}
		else if (fun_name.equals("write")) {
			occurred_acc = new PVLSequenceAccessExpression(null, event_state, List.of(read_event), pvl_class);
			mod_wo = new BinaryExpression(null, pid, "->", read_event);
			outer_cond = new BinaryExpression(null, buffersize, ">=", new ConstantExpression(null, "16"));
		}
		else {
			throw new IllegalStateException("Function " + fun_name + " for SC_FIFO is not supported.");
		}
		PVLSequenceAccessExpression wait_on_mod = new PVLSequenceAccessExpression(null, process_state, List.of(mod_wo), pvl_class);
		
		outer_body.add(new BinaryExpression(null, new PVLVariableExpression(null, process_state, pvl_class), "=", wait_on_mod));
		
		PVLSequenceAccessExpression ready_acc = new PVLSequenceAccessExpression(null, process_state, List.of(pid), pvl_class);
		Expression ready_cond = new BinaryExpression(null, ready_acc, "!=", new ConstantExpression(null, "-1"));
		Expression occurred_cond = new BinaryExpression(null, occurred_acc, "!=", new ConstantExpression(null, "-2"));
		Expression inner_cond = new BinaryExpression(null, ready_cond, "||", occurred_cond);						// Hardcoded loops don't need path conditions
		PVLWhileLoopExpression inner_loop = new PVLWhileLoopExpression(null, "", inner_cond, inner_body, pvl_class, new LinkedList<Expression>());
		pvl_system.addSpecifiable(inner_loop);
		outer_body.add(inner_loop);
		
		PVLWhileLoopExpression outer_loop = new PVLWhileLoopExpression(null, "", outer_cond, outer_body, pvl_class, new LinkedList<Expression>());
		pvl_system.addSpecifiable(outer_loop);
		ret.add(outer_loop);
		
		return ret;
	}

	/**
	 * Transforms the SystemC Expression of the type Binary Expression to a PVL
	 * Expression.
	 * 
	 * @param exp       the systemc expression to transform
	 * @param local_var List where the locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return			The binary expression in PVL
	 */
	public LinkedList<Expression> transformBinaryExpression(BinaryExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		LinkedList<Expression> ret = new LinkedList<Expression>();
		
		// If the right side of the binary expression is a function call to a FIFO queue, handle it separately
		if (exp.getRight() instanceof AccessExpression
				&& ((AccessExpression) exp.getRight()).getLeft() instanceof SCPortSCSocketExpression port) {

			if (SCPORTSCSOCKETTYPE.SC_FIFO_ALL.contains(port.getSCPortSCSocket().getConType())
					&& ((AccessExpression) exp.getRight()).getRight() instanceof FunctionCallExpression) {
				
				AccessExpression acc_exp = (AccessExpression) exp.getRight();
				
				ret.addAll(transformFIFOAccessExpression(acc_exp, local_var, path_condition));
				
				FunctionCallExpression fun = ((FunctionCallExpression) acc_exp.getRight());
				PVLVariableExpression fifo = (PVLVariableExpression) transformSCPortScSocketExpression((SCPortSCSocketExpression) acc_exp.getLeft(),
																									   local_var,
																									   path_condition).get(0);
				// TODO fix this mess
				StringBuilder params = new StringBuilder();
				LinkedList<Expression> ps = new LinkedList<Expression>();
				for (Expression param : fun.getParameters()) {
					ps.addAll(createExpression(param, local_var, path_condition));
				}
				for (Expression param : ps) {
					params.append(param.toString()).append(", ");
				}
				if (ps.size() > 0) {
					params = new StringBuilder(params.substring(0, params.length() - 2));
				}
				
				// TODO Resolve function name some other way
				Expression fun_call = new AccessExpression(null, fifo, ".", new ConstantExpression(null, "fifo_" + fun.getFunction().getName() + "(" + params + ")"));
				
				Expression left = createExpression(exp.getLeft(), local_var, path_condition).get(0);
				ret.add(new BinaryExpression(null, left, exp.getOp(), fun_call));
				return ret;
			}
		}
		
		// Otherwise, simply return the transformed binary expression
		Expression left = createExpression(exp.getLeft(), local_var, path_condition).get(0);
		Expression right = createExpression(exp.getRight(), local_var, path_condition).get(0);
		
		BinaryExpression new_exp = new BinaryExpression(null, left, exp.getOp(), right);
		ret.add(new_exp);
		return ret;
	}

	/**
	 * Transforms the SystemC Expression of the type If else Expression to a PVL
	 * Expression.
	 * 
	 * @param exp       the systemc expression to transform
	 * @param local_var List where the locally used variables are stored.
	 * @return			The transformation of the if/else expression in PVL
	 */
	public LinkedList<Expression> transformIfElseExpression(IfElseExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		// transform the condition
		Expression cond = createExpression(exp.getCondition(), local_var, path_condition).get(0);
		// transform all expressions in the then body
		List<Expression> then = exp.getThenBlock();
		LinkedList<Expression> then_new = new LinkedList<Expression>();
		for (Expression e : then) {
			List<Expression> new_path_condition = new LinkedList<Expression>(path_condition);
			new_path_condition.add(cond);
			LinkedList<Expression> create = createExpression(e, local_var, new_path_condition);
			if (create != null)
				then_new.addAll(create);

		}
		// if expressions are now null (e.g. former output expression) remove them
		then_new.removeAll(Collections.singleton(null));
		// transform all expressions in the else blockexp
		List<Expression> else_block = exp.getElseBlock();
		LinkedList<Expression> else_new = new LinkedList<Expression>();
		for (Expression e : else_block) {
			List<Expression> new_path_condition = new LinkedList<Expression>(path_condition);
			new_path_condition.add(new UnaryExpression(null, UnaryExpression.PRE, "!", cond));
			LinkedList<Expression> create = createExpression(e, local_var, new_path_condition);
			if (create != null)
				else_new.addAll(create);
		}
		// if expressions are now null (e.g. former output expression) remove them
		else_new.removeAll(Collections.singleton(null));
		LinkedList<Expression> ret = new LinkedList<Expression>();
		ret.add(new IfElseExpression(null, cond, then_new, else_new));
		return ret;
	}

	/**
	 * Transforms the SystemC Expression of the type Bracket Expression to PVL
	 * Expressions in Brackets.
	 * 
	 * @param exp       the systemc expression to transform
	 * @param local_var List where the locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return			The bracket expression in PVL
	 */
	public LinkedList<Expression> transformBracketExpression(BracketExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		Expression new_exp = exp.getInBrackets();
		new_exp = createExpression(new_exp, local_var, path_condition).get(0);
		
		BracketExpression new_bracket_exp = new BracketExpression(null, new_exp);

		LinkedList<Expression> ret = new LinkedList<Expression>();
		ret.add(new_bracket_exp);
		return ret;
	}

	/**
	 * Transforms function calls to PVL.
	 * 
	 * @param exp       the systemc expression to transform
	 * @param local_var List where the locally used variables are stored.
	 * @param path_condition Path condition at this point in the program
	 * @return 			The function call expression in PVL
	 */
	public LinkedList<Expression> transformFunctionCallExpression(FunctionCallExpression exp,
			List<PVLVariable> local_var, List<Expression> path_condition) {
		LinkedList<Expression> expressions = new LinkedList<Expression>();
		
		SCFunction sc_fun = exp.getFunction();
		SCClass sc_class = sc_fun.getSCClass();
		
		String name = sc_fun.getName();
		PVLFunction pvlfunc = pvl_system.getFunctions().get(new Pair<SCFunction, PVLClass>(sc_fun, pvl_class));
		// If lookup is unsuccessful, look in state class instead
		if (pvlfunc == null && pvl_class.getCorrStateClass() != null) {
			pvlfunc = pvl_system.getFunctions().get(new Pair<SCFunction, PVLClass>(sc_fun, pvl_class.getCorrStateClass()));
		}
		if (name.equals("wait")) {
			return transformWaitExpression(exp, local_var);
		} 
		if (sc_class != null && sc_class.isVirtual()) {
			// TODO: Create more robust detection of inheriting class
			String classname = sc_class.getName().replace("_if", "");
			PVLClass inherits = pvl_system.getClassMappings().get(classname).get(0);

			pvlfunc = (PVLFunction) inherits.getFunctionByName(name);
		}
		if (pvlfunc != null) {
			LinkedList<Expression> parameters = new LinkedList<Expression>();
			for (Expression param : exp.getParameters()) {
				parameters.addAll(createExpression(param, local_var, path_condition));
			}
			PVLFunctionCallExpression funcexp;
			if (!pvlfunc.isWaiting() || pvlfunc.getCorrClass().isRunnable()) {
				funcexp = new PVLFunctionCallExpression(null, pvlfunc, parameters);
			}
			else {
				PVLFunction newFunction = new PVLFunction(pvlfunc);
				newFunction.setName(pvlfunc.getName()+"_"+ pvl_class.getName().toLowerCase());
				pvlfunc.getCorrClass().addFunction(newFunction);
				parameters.add(new PVLProcessIDExpression(null, pvl_class));
				List<Specifiable> specs = pvl_system.getSpecifiables();
				specs.remove(pvlfunc);
				specs.add(newFunction);
				pvl_system.setSpecifiables(specs);
				funcexp = new PVLFunctionCallExpression(null, newFunction, parameters);
				pvlfunc.getCorrClass().getFunctions().remove(pvlfunc);
			}
			
			// If the function is from another class, add the instance identifier to the function call
			if (!pvlfunc.getCorrClass().equals(pvl_class) && !(exp.getParent() instanceof AccessExpression)) {
				List<PVLVariable> class_instances = pvl_system.getClassInstances().get(pvlfunc.getCorrClass());
				PVLVariable class_var = new PVLNestedVariable(pvl_class.getMainRef(), class_instances.get(0));
				expressions.add(new AccessExpression(null, new PVLVariableExpression(null, class_var, pvl_class), ".", funcexp));
			}
			else {
				expressions.add(funcexp);
			}
		}
		// The function has not been found in the PVL system
		else {
			switch (name) {
			case "rand":
			case "random":
			case "rand_r":
				PVLFunction random_fun = new PVLFunction(name + "__randomize_" + pvl_class.getNrAutogeneratedFunctions());
				random_fun.setAbstract(true);
				random_fun.setPure(true);
				random_fun.setReturnType("int");
				random_fun.setCorrClass(pvl_class);
				pvl_class.addAutogeneratedFunction(random_fun);
				expressions.add(new PVLFunctionCallExpression(null, random_fun, List.of()));
			case "srand":
				break;
			default:
				expressions.add(exp);
			}
		}
		return expressions;
	}

	/**
	 * Transforms wait expressions to PVL.
	 * 
	 * @param exp       the systemc expression to transform
	 * @param local_var List where the locally used variables are stored.
	 * @return			Wait expression in PVL
	 */
	private LinkedList<Expression> transformWaitExpression(FunctionCallExpression exp, List<PVLVariable> local_var) {
		LinkedList<Expression> expressions = new LinkedList<Expression>();
		// grab sequences from main
		PVLVariable main = pvl_class.getMainRef();
		PVLMainClass main_class = (PVLMainClass) pvl_system.getClassByName("Main");
		PVLVariable process_state_var = main_class.getProcessState();
		PVLNestedVariable process_state = new PVLNestedVariable(main, process_state_var);
		PVLVariable event_state_var = main_class.getEventState();
		PVLNestedVariable event_state = new PVLNestedVariable(main, event_state_var);

		pvl_func.setWaiting(true);
		Expression process_expression ;
		if(pvl_func.getCorrClass().isRunnable()) {
			process_expression = new PVLProcessIDExpression(null, pvl_class);
		}
		else {
			PVLVariable process_id = new PVLVariable("process_id", "int", pvl_func.getCorrClass());
			pvl_func.addParameter(process_id);
			process_expression = new PVLVariableExpression(null, process_id, pvl_class);
		}
		PVLVariableExpression p_state_expr = new PVLVariableExpression(null, process_state, pvl_class);
		PVLEventVariable wait_event;
		if (exp.getParameters().size() == 2 || exp.getParameters().size() == 0) {
			// transform wait(wait_time, time_unit) to:
			/*
			 * int wait_time = wait_time; m.ready = m.ready[process_id -> false]; m.init =
			 * m.init[process_id -> true]; m.waiting_on = m.waiting_on[process_id ->
			 * wait_event]; m.delays = m.delays[wait_event -> wait_time];
			 */

			// add wait event to function
			wait_event = new PVLEventVariable(-1);
			pvl_func.getCorrClass().addEvent(wait_event);
			pvl_system.addEvent(wait_event);

		} else {
			wait_event = pvl_func.getCorrClass()
					.getEventByVariable(((SCVariableExpression) exp.getParameters().get(0)).getVar());
			if (wait_event == null) {
				SCVariable event_var = ((SCVariableExpression) exp.getParameters().get(0)).getVar();
				wait_event = new PVLEventVariable(-1);
				pvl_func.getCorrClass().addEvent(event_var, wait_event);
				pvl_system.addEvent(wait_event);
				pvl_system.addSharedEvent(event_var, wait_event);
			}

		}
		PVLEventExpression wait_event_expression = new PVLEventExpression(null, wait_event);
		// Create m.waiting_on = m.waiting_on[process_id -> wait_event];
		BinaryExpression pIdWaitEvent = new BinaryExpression(null, process_expression, "->", wait_event_expression);
		LinkedList<Expression> access = new LinkedList<Expression>();
		access.add(pIdWaitEvent);
		PVLSequenceAccessExpression wait_on_access = new PVLSequenceAccessExpression(null, process_state, access, pvl_class);
		BinaryExpression update_wait_on = new BinaryExpression(null, p_state_expr, "=", wait_on_access);
		expressions.add(update_wait_on);
		if (exp.getParameters().size() == 2 || exp.getParameters().size() == 0) {
			// Create m.delays = m.delays[wait_event -> wait_time];
			Expression wait_time;
			if (exp.getParameters().size() == 0)
				wait_time = new ConstantExpression(null, "0");
			// TODO: wait for sensitivity not zero time
			else {
				Expression amount = exp.getParameters().get(0);
				Expression time_unit = exp.getParameters().get(1);
				if (amount instanceof ConstantExpression) {
					String delay;
					long total_delay = Constants.getTimeUnits(amount.toStringNoSem(),
							  								  time_unit.toStringNoSem());
					if (total_delay == 0) {
						delay = "-1";
					}
					else {
						delay = String.valueOf(total_delay);
					}
					wait_time = new ConstantExpression(null, delay);
				}
				else {
					long conversion_factor = (long) Math.round(Constants.getTimeFactor(time_unit.toStringNoSem()));
					Expression delay = createExpression(amount, local_var, new LinkedList<Expression>()).get(0);
					if (conversion_factor == 1) {
						wait_time = delay;
					}
					else {
						wait_time = new BinaryExpression(null, delay, "*", new ConstantExpression(null, "" + conversion_factor));
					}
				}
			}
			BinaryExpression waitEventWaitTime = new BinaryExpression(null, wait_event_expression, "->", wait_time);
			PVLVariableExpression delays_expression = new PVLVariableExpression(null, event_state, pvl_class);
			access = new LinkedList<Expression>();
			access.add(waitEventWaitTime);
			PVLSequenceAccessExpression delays_access = new PVLSequenceAccessExpression(null, event_state, access,
					pvl_class);
			BinaryExpression update_delays = new BinaryExpression(null, delays_expression, "=", delays_access);
			expressions.add(update_delays);
		}

		PVLLockExpression lock = new PVLLockExpression(null, new PVLVariableExpression(null, main, pvl_class));
		PVLUnlockExpression unlock = new PVLUnlockExpression(null, new PVLVariableExpression(null, main, pvl_class));
		LinkedList<Expression> body = new LinkedList<Expression>(List.of(unlock, lock));
		access = new LinkedList<Expression>();
		access.add(process_expression);
		PVLSequenceAccessExpression ready_access_loop = new PVLSequenceAccessExpression(null, process_state, access, pvl_class);
		BinaryExpression not_ready = new BinaryExpression(null, ready_access_loop, "!=", new ConstantExpression(null, "-1"));
		access = new LinkedList<Expression>();
		access.add(wait_event_expression);
		PVLSequenceAccessExpression occured_access = new PVLSequenceAccessExpression(null, event_state, access, pvl_class);
		BinaryExpression not_occured = new BinaryExpression(null, occured_access, "!=", new ConstantExpression(null, "-2"));
		BinaryExpression or_exp = new BinaryExpression(null, not_ready, "||", not_occured);				  // Hardcoded loops don't need path conditions
		PVLWhileLoopExpression while_wait = new PVLWhileLoopExpression(null, "", or_exp, body, pvl_class, new LinkedList<Expression>());
		expressions.add(while_wait);
		// set loop invariant
		pvl_system.addSpecifiable(while_wait);
		return expressions;
	}
	
	private LinkedList<Expression> transformSCPortScSocketExpression(SCPortSCSocketExpression exp, List<PVLVariable> local_var, List<Expression> path_condition) {
		PVLVariable var = pvl_system.getPort_dict().get(new Pair<PVLClass, SCPort>(pvl_class, exp.getSCPortSCSocket()));
		PVLVariableExpression var_exp = new PVLVariableExpression(null, var, pvl_class);
		LinkedList<Expression> result = new LinkedList<Expression>();
		result.add(var_exp);
		return result;
	}

}
