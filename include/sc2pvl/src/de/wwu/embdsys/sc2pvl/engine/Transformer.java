package de.wwu.embdsys.sc2pvl.engine;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.TimeUnitExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;
import de.tub.pes.syscir.sc_model.variables.SCTIMEUNIT;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLEventVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLMainClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSequenceVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLLockExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSequenceDeclarationExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLUnlockExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;
import de.wwu.embdsys.sc2pvl.util.Constants;

/**
 * Main transformer class for the SCSystem. It handles the transformation of a
 * all SCSystem classes into a PVL Model. This transformer is the root of the
 * transformer hierarchy tree.
 *
 */
public class Transformer {

	/**
	 * The SystemC Model to transform.
	 */
	private final SCSystem sc_system;

	/**
	 * PVLSystem wrapping all classes of the PVL system and all variable mappings.
	 */
	private final PVLSystem pvl_system;

	/**
	 * Default constructor initializing the attributes.
	 * 
	 * @param scSystem The System to transform
	 */
	public Transformer(SCSystem scSystem) {
		this.sc_system = scSystem;
		this.pvl_system = new PVLSystem();
	}

	/**
	 * Creates the PVL model based on the given systemC model.
	 */
	public void createPVLModel() {
		// suitably configure time resolution for the SystemC system
		configure();
		// create main class object - dont transform yet just add sequence fields
		PVLMainClass main = new PVLMainClass();
		createMinimalMain(main);
		// transform known types
		transformKnownTypes();
		// transform all regular classes
		transformClasses();
		// transform sc_main to a PVL Class
		MainTransformer main_transformer = transformMain(main);
		// transform the functions of the regular classes
		transformFunctions();
		// sort out process and event ids
		createProcessAndEventIDs(main_transformer);
		// create Specifications for all classes, functions, loops
		createSpecifications();
	}
	
	private void configure() {
		// Find all functions in the SystemC system
		LinkedList<SCFunction> functions = new LinkedList<SCFunction>(sc_system.getGlobalFunctions());
		for (SCClass sc_class : sc_system.getClasses()) {
			functions.addAll(sc_class.getMemberFunctions());
		}
		
		// Find all expressions in the SystemC system
		LinkedList<Expression> exps = new LinkedList<Expression>();
		for (SCFunction function : functions) {
			exps.addAll(function.getBody());
		}
		
		// Find the minimum of all time expressions
		SCTIMEUNIT min = SCTIMEUNIT.SC_ZERO_TIME;
		while (!exps.isEmpty()) {
			Expression exp = exps.removeFirst();
			// If exp is a time expression already, use it to find the minimum
			if (exp instanceof TimeUnitExpression) {
				if (((TimeUnitExpression) exp).getTimeUnit().getExponent() < min.getExponent()) {
					min = ((TimeUnitExpression) exp).getTimeUnit();
				}
			}
			// Otherwise add the children of the expression to the expression list
			exps.addAll(exp.crawlDeeper());
		}
		
		// If physical time units were found, set the time resolution accordingly
		switch (min) {
			case SC_FS -> Constants.SC_TIME_RESOLUTION = 1L;
			case SC_PS -> Constants.SC_TIME_RESOLUTION = 1000L;
			case SC_NS -> Constants.SC_TIME_RESOLUTION = 1000000L;
			case SC_US -> Constants.SC_TIME_RESOLUTION = 1000000000L;
			case SC_MS -> Constants.SC_TIME_RESOLUTION = 1000000000000L;
			case SC_SEC -> Constants.SC_TIME_RESOLUTION = 1000000000000000L;
			default -> {
				// Don't change if the only time resolution used is SC_ZERO_TIME
			}
		}
	}

	private void createProcessAndEventIDs(MainTransformer maintransformer) {
		PVLMainClass main = ((PVLMainClass) pvl_system.getClassByName("Main"));
		PVLSequenceDeclarationExpression ev_state_dec = (PVLSequenceDeclarationExpression) main.getEventState().getDeclaration();
		PVLSequenceDeclarationExpression pr_state_dec = (PVLSequenceDeclarationExpression) main.getProcessState().getDeclaration();

		int event_count = 0;
		int process_count = 0;
		for (PVLClass pvl_cls : pvl_system.getClasses()) {
			// Add events
			for (PVLEventVariable ev : pvl_cls.getEvents()) {
				ev.setEventId(event_count);
				ev_state_dec.addValue(new ConstantExpression(null, "-3"));
				event_count++;
			}
			
			// Add process
			if (pvl_cls.isRunnable()) {
				pvl_cls.setRunnableId(process_count);
				pr_state_dec.addValue(new ConstantExpression(null, "-1"));
				process_count++;
			}
		}
		
		// create main method
		maintransformer.createMainMethod();
		
		// create abstract functions
		maintransformer.createAbstractFunctions();
	}

	private void transformFunctions() {
		for (PVLClass pvl_cls : pvl_system.getClasses()) {
			List<SCFunction> functions = pvl_system.getFunctionsToTransform().get(pvl_cls);
			LinkedList<PVLFunction> pvl_functions = new LinkedList<PVLFunction>();
			if (functions != null) {
				for (SCFunction func : functions) {
					FunctionTransformer func_trans = new FunctionTransformer(func, pvl_cls, pvl_system);
					func_trans.createFunction();
					PVLFunction func_pvl = func_trans.getFunction();
					if (func_pvl.getName().equals("run")) {
						// run methods needs to lock and unlock statement at beginning resp. end of
						// function
						PVLLockExpression lock = new PVLLockExpression(null, new PVLVariableExpression(null, pvl_cls.getMainRef(), pvl_cls));
						PVLUnlockExpression unlock = new PVLUnlockExpression(null,
								new PVLVariableExpression(null, pvl_cls.getMainRef(), pvl_cls));
						func_pvl.getBody().add(0, lock);
						func_pvl.getBody().add(unlock);
					}
					pvl_functions.add(func_pvl);
				}
				pvl_cls.addAllFunctions(pvl_functions);
			}
		}
	}

	/**
	 * Creates Specifications for all classes, functions and loops.
	 */
	private void createSpecifications() {
		SpecificationTransformer spec = new SpecificationTransformer(pvl_system);
		spec.createSpecifications(pvl_system.getSpecifiables());
	}

	/**
	 * Creates the main class and add the non-instance sequence fields that are
	 * accessed during the transformation of the wait and notify statements.
	 * 
	 * @param main Main Class object
	 */
	private void createMinimalMain(PVLMainClass main) {
		// create process status sequence
		PVLSequenceVariable process_state = new PVLSequenceVariable("process_state", "int", false, main);
		main.addField(process_state);
		main.setProcessState(process_state);
		// create wait_on sequence
		PVLSequenceVariable event_state = new PVLSequenceVariable("event_state", "int", false, main);
		main.addField(event_state);
		main.setEventState(event_state);
		pvl_system.addClass(main);
	}

	/**
	 * Transform the known Types to PVL Classes.
	 */
	private void transformKnownTypes() {
		LinkedList<SCClass> used_known_types = new LinkedList<SCClass>();
		for (SCClassInstance type : sc_system.getInstances()) {
			if (type instanceof SCKnownType && !used_known_types.contains(type.getSCClass())) {
				used_known_types.add(type.getSCClass());
			}
		}

		for (SCClass cls : used_known_types) { 
			ClassTransformer transformer = new ClassTransformer(cls, pvl_system);
			transformer.transformKnownType();
		}
	}

	/**
	 * Create the main class.
	 * 
	 * @param main Main class object to be transformed
	 */
	private MainTransformer transformMain(PVLMainClass main) {
		SCFunction sc_main = new SCFunction("");
		for (SCFunction func : sc_system.getGlobalFunctions()) {
			if (func.getName().equals("sc_main")) {
				sc_main = func;
			}
		}

		SCClass main_class = new SCClass("Main");
		main_class.addMemberFunction(sc_main);
		MainTransformer transformer = new MainTransformer(main, pvl_system, main_class, sc_system);
		transformer.createMainClass();
		return transformer;
	}

	/**
	 * Returns the PVL system.
	 * 
	 * @return The current PVL intermediate representation
	 */
	public PVLSystem getPVLSystem() {
		return pvl_system;
	}

	/**
	 * Transforms all classes of the SystemC model into PVL classes.
	 */
	private void transformClasses() {
		for (SCClass classes : sc_system.getClasses()) {
			if (!isInterface(classes)) {
				ClassTransformer transformer = new ClassTransformer(classes, pvl_system);
				transformer.createClasses();
			}
		}
	}

	/**
	 * Checks whether a class is an interface.
	 * 
	 * @param classes Class to check
	 * @return true if the class is an interface, false otherwise
	 */
	private boolean isInterface(SCClass classes) {
		return classes.isVirtual();
	}
}
