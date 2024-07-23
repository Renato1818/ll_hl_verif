package de.wwu.embdsys.sc2pvl.engine;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPROCESSTYPE;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLEventExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSizeExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.AppendSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.BinarySpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ConstantSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.EnsuresSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.OldSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.PermissionSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.RequiresSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SequenceAccessSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SequenceModifySpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SizeSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SpecificationBlock;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.VariableSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLConstructor;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLEventVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLMainClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLNestedVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSequenceVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

/**
 * Transforms a SystemC Class into a PVL Class.
 */
public class ClassTransformer {

	/**
	 * The original SystemC class to transform.
	 */
	private final SCClass sc_class;

	/**
	 * List of PVL classes that get created during the transformation of the SystemC
	 * class.
	 */
	private final LinkedList<PVLClass> pvl_classes;

	/**
	 * Reference to the complete PVL System.
	 */
	private final PVLSystem pvl_system;

	/**
	 * Indicates whether the SystemC class contains declarations of SC_THREADS.
	 */
	private boolean runnable;

	/**
	 * Default constructor, initializes the attributes.
	 * 
	 * @param sc_class The original SystemC class
	 * @param pvl_system The PVL system the class is contained in
	 */
	public ClassTransformer(SCClass sc_class, PVLSystem pvl_system) {
		this.sc_class = sc_class;
		this.pvl_classes = new LinkedList<PVLClass>();
		this.pvl_system = pvl_system;
	}

	/**
	 * Creates all PVL classes from the given SCClass. For each SC_THREAD a new
	 * class is generated and named after the thread function, the thread function
	 * is renamed to run. A state class encapsulates all non-thread functions and
	 * all fields. If only one thread is declared no state class is needed and only
	 * the thread function is renamed to run.
	 */
	public void createClasses() {
		for (SCClassInstance sc_class_inst : sc_class.getInstances()) {
			// set name and change first letter to uppercase
			String name = sc_class.getName();
			if (sc_class.getInstances().size() > 1) {
				name = name + "_" + sc_class_inst.getName();
			}
			name = name.substring(0, 1).toUpperCase() + name.substring(1);
			if(name.equals("Main")) name = "SCMain";
			// separate member and thread functions
			List<SCFunction> members = sc_class.getMemberFunctions();
			List<SCFunction> threads = new LinkedList<SCFunction>();
	
			// remove constructor from list of functions
			members.remove(sc_class.getConstructor());
	
			// iterate over all processes and identify the thread functions
			List<SCProcess> scproc = sc_class.getProcesses();
			for (SCProcess proc : scproc) {
				if (proc.getType().equals(SCPROCESSTYPE.SCTHREAD)) {
					threads.add(proc.getFunction());
					members.remove(proc.getFunction());
				}
			}
	
			// create classes
			if (threads.size() < 1) {
				// no thread is declared -> no method to rename to run and no need for state
				// class
				PVLClass new_class = createClass(name, members, sc_class.getMembers(), null, sc_class_inst);
				pvl_classes.add(new_class);
			} else if (threads.size() == 1) {
				// exactly one thread is declared -> no need for state class but rename of
				// thread function to "run"
				runnable = true;
				// rename thread function to run
				SCFunction thread_function = threads.get(0);
				thread_function.setName("run");
				members.add(thread_function);
				// create class with all member functions and the renamed thread function
				PVLClass new_class = createClass(name, members, sc_class.getMembers(), null, sc_class_inst);
				pvl_classes.add(new_class);
			} else {
				// multiple threads declared so multiple thread classes and maybe state class
				// needed
				PVLClass stateClass = null;
				// check if state class is needed
				if (sc_class.getMembers().size() > 0 | members.size() > 0 | sc_class.getEvents().size() > 0) {
					// create state class if at least one member function, class field or event is
					// declared
					stateClass = createClass(name, members, sc_class.getMembers(), null, sc_class_inst);
					pvl_classes.add(stateClass);
				}
				// the rest of the classes are runnable since they are thread classes and
				// contain the "run" function
				runnable = true;
				// create new class for each SCThread
				for (SCFunction thread_function : threads) {
					// name of thread class will be set to name of thread function
					String function_name = thread_function.getName();
					if (sc_class.getInstances().size() > 1) {
						function_name = function_name + "_" + sc_class_inst.getName();
					}
					function_name = function_name.substring(0, 1).toUpperCase() + function_name.substring(1);
					if (function_name.equals("Main")) function_name = "SCMain";
					thread_function.setName("run");
					LinkedList<SCFunction> thread_functions = new LinkedList<SCFunction>();
					thread_functions.add(thread_function);
					PVLClass threadClass = createClass(function_name, thread_functions, new LinkedList<SCVariable>(),
							stateClass, sc_class_inst);
					pvl_classes.add(threadClass);
				}
			}
		}

		pvl_system.addClasses(pvl_classes);
		// save mapping from SC class to all created pvl_classes
		pvl_system.getClassMappings().put(sc_class.getName(), pvl_classes);
	}

	/**
	 * Transforms the systemC class into a PVL class. Only the specified functions
	 * will be added to the pvl class. This is used for classes with methods and
	 * threads.
	 * 
	 * @param name      the name of the pvl class
	 * @param functions the functions of the class
	 * @return the PVL Class representation of the systemC class
	 */
	public PVLClass createClass(String name, List<SCFunction> functions, List<SCVariable> variables,
			PVLClass stateClass, SCClassInstance sc_class_instance) {
		PVLClass pvl_class = new PVLClass(name);
		pvl_class.setGenerating_instance(sc_class_instance);
		if (stateClass != null)
			pvl_class.setCorrStateClass(stateClass);

		// create class fields
		LinkedList<PVLVariable> fields = new LinkedList<PVLVariable>();
		// add main reference
		PVLVariable main = new PVLVariable("m", "Main", pvl_class);
		fields.add(main);
		pvl_class.setMainRef(main);
		// save class instance in global list
		pvl_system.addClassInstance(pvl_system.getClassByName(main.getType()), main);
		
		for (SCPort port : sc_class.getPortsSockets()) {
			pvl_system.addPort_dict(pvl_class, port, new PVLNestedVariable(main, new PVLVariable(null, null, pvl_class)));
		}
		
		pvl_class.setRunnable(runnable);

		// transform all fields of the SCClass
		VariableTransformer var_trans = new VariableTransformer(pvl_system, pvl_class);
		for (SCVariable var : variables) {
			PVLVariable pvl_var = var_trans.createVariable(var);
			fields.add(pvl_var);
		}
		// transform local variables of functions to field of the class to allow
		// verification over these variables
		for (SCFunction function : functions) {
			for (SCVariable sc : function.getLocalVariables()) {
				PVLVariable var = var_trans.createVariable(sc);
				if (!fields.contains(var)) {
					fields.add(var);
				}
			}
		}
		pvl_class.setFields(fields);

		// add functions to transform later
		pvl_system.addFunctionsToTransform(pvl_class, functions);

		// transform constructor
		LinkedList<PVLConstructor> constructors = new LinkedList<PVLConstructor>();
		ConstructorTransformer cons_trans;
		if (stateClass == null) {
			cons_trans = new ConstructorTransformer(sc_class.getConstructor(), pvl_class, pvl_system);
		}
		else {
			cons_trans = new ConstructorTransformer(null, pvl_class, pvl_system);
		}
		cons_trans.createConstructor();
		PVLConstructor cons = cons_trans.getConstructor();
		constructors.add(cons);
		pvl_class.setConstructors(constructors);

		return pvl_class;
	}
	
	/**
	 * Selects the appropriate method to generate a PVL class for a known SystemC type.
	 */
	public void transformKnownType() {
		for (SCClassInstance sc_class_inst : sc_class.getInstances()) {
			PVLClass cls;
			String name = sc_class.getName();
			if (sc_class.getInstances().size() > 1) {
				name = name + "_" + sc_class_inst.getName();
			}
			name = name.substring(0, 1).toUpperCase() + name.substring(1);

			cls = switch (sc_class.getName()) {
				case "sc_fifo_int" -> transformFifo(name, "int");
				case "sc_fifo_bool" -> transformFifo(name, "boolean");
				default ->
						throw new IllegalStateException("The known type " + sc_class.getName() + " is not supported.");
			};

			cls.setGenerating_instance(sc_class_inst);
			cls.setRunnable(false);
			pvl_classes.add(cls);
		}
		
		pvl_system.addClasses(pvl_classes);
		pvl_system.getClassMappings().put(sc_class.getName(), pvl_classes);
	}
	
	/**
	 * Generates an abstract implementation of the SystemC-internal FIFO channel type.
	 * @param name Name of the class
	 * @param type Type of the FIFO entries (int or boolean)
	 */
	private PVLClass transformFifo(String name, String type) {
		PVLClass fifo = new PVLClass(name);
		
		// Add fields
		List<PVLVariable> params = new ArrayList<PVLVariable>();
		PVLVariable main = new PVLVariable("m", "Main", fifo);
		fifo.addField(main);
		fifo.setMainRef(main);
		params.add(main);
		PVLEventVariable read_event = new PVLEventVariable(-1);
		fifo.addEvent(read_event);
		pvl_system.addEvent(read_event);
		PVLEventVariable write_event = new PVLEventVariable(-1);
		fifo.addEvent(write_event);
		pvl_system.addEvent(write_event);
		PVLVariable buffer = new PVLSequenceVariable("buffer", type, false, fifo);
		fifo.addField(buffer);
		
		// Add constructor
		PVLConstructor constructor = new PVLConstructor(fifo);
		List<Specification> specs;
		for (PVLVariable var : params) {
			// Add field to constructor parameter list
			PVLVariable constructor_param = new PVLVariable(var.getName() + "_param", var.getType(), fifo);
			constructor.addParameter(constructor_param);
			// Add declaration to constructor body
			constructor.addExpression(new BinaryExpression(null,
														   new PVLVariableExpression(null, var, fifo),
														   "=",
														   new PVLVariableExpression(null, constructor_param, fifo)));
			// Add specification to constructor
			specs = new ArrayList<Specification>();
			specs.add(new PermissionSpecification(fifo, pvl_system, new VariableSpecification(pvl_system, fifo, var), 0.5f));
			specs.add(new BinarySpecification(fifo,
											  pvl_system,
											  new VariableSpecification(pvl_system, fifo, var),
											  new VariableSpecification(pvl_system, fifo, constructor_param),
											  "=="));
			constructor.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new SpecificationBlock(specs, fifo, pvl_system)));
		}
		// Add buffer to constructor
		constructor.addExpression(new BinaryExpression(null,
				   new PVLVariableExpression(null, buffer, fifo),
				   "=",
				   new ConstantExpression(null, buffer.getType() + " {}")));
		specs = new ArrayList<Specification>();
		specs.add(new PermissionSpecification(fifo, pvl_system, new VariableSpecification(pvl_system, fifo, buffer), 1.0f));
		specs.add(new BinarySpecification(fifo,
										  pvl_system,
										  new VariableSpecification(pvl_system, fifo, buffer),
										  new ConstantSpecification(fifo, pvl_system, "[t: " + type + "]"),
										  "=="));
		constructor.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new SpecificationBlock(specs, fifo, pvl_system)));
		// Add constructor to class
		fifo.setConstructors(new LinkedList<PVLConstructor>(List.of(constructor)));
		
		// Add methods
		LinkedList<PVLFunction> pvl_functions = new LinkedList<PVLFunction>();
		// Add write method
		PVLFunction write_method = new PVLFunction("fifo_write");
		write_method.setCorrClass(fifo);
		write_method.setAbstract(true);
		write_method.setReturnType("void");
		PVLVariable write_param = new PVLVariable("newVal", type, fifo);
		write_method.addParameter(write_param);
		// Add write method contract
		SizeSpecification buffersize = new SizeSpecification(fifo,
															 pvl_system,
															 new PVLSizeExpression(null, new PVLVariableExpression(null, buffer, fifo)),
															 "<",
															 new ConstantExpression(null, "16"));	// TODO!!!
		write_method.appendSpecification(new RequiresSpecification(fifo, pvl_system, buffersize));
		// Add untouched variable specifications
		specs = new ArrayList<Specification>();
		PVLVariable wait_seq = ((PVLMainClass) pvl_system.getClassByName("Main")).getProcessState();
		VariableSpecification wait = new VariableSpecification(pvl_system,
															   fifo,
															   new PVLNestedVariable(main, wait_seq));
		specs.add(new BinarySpecification(fifo, pvl_system, wait, new OldSpecification(fifo, pvl_system, wait), "=="));
		write_method.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new SpecificationBlock(specs, fifo, pvl_system)));
		// Add buffer specification
		VariableSpecification buf = new VariableSpecification(pvl_system, fifo, buffer);
		AppendSpecification nbuf = new AppendSpecification(fifo,
														   pvl_system,
														   buf,
														   new PVLVariableExpression(null, write_param, fifo));
		OldSpecification old_nbuf = new OldSpecification(fifo, pvl_system, nbuf);
		write_method.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new BinarySpecification(fifo, pvl_system, buf, old_nbuf, "==")));
		//Add event specification
		specs = new ArrayList<Specification>();
		PVLVariable evto = new PVLNestedVariable(main, ((PVLMainClass) pvl_system.getClassByName("Main")).getEventState());
		SequenceModifySpecification evto_mod = new SequenceModifySpecification(fifo,
																			   pvl_system,
																			   new PVLVariableExpression(null, evto, fifo),
																			   new PVLEventExpression(null, write_event),
																			   new ConstantExpression(null, "-1"));
		specs.add(new BinarySpecification(fifo,
										  pvl_system,
										  new VariableSpecification(pvl_system, fifo, evto),
										  new OldSpecification(fifo, pvl_system, evto_mod),
										  "=="));
		write_method.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new SpecificationBlock(specs, fifo, pvl_system)));
		// Add write method to system
		pvl_system.addSpecifiable(write_method);
		pvl_functions.add(write_method);
		// Add read method
		PVLFunction read_method = new PVLFunction("fifo_read");
		read_method.setCorrClass(fifo);
		read_method.setAbstract(true);
		read_method.setReturnType(type);
		// Add read method contract
		buffersize = new SizeSpecification(fifo,
				 pvl_system,
				 new PVLSizeExpression(null, new PVLVariableExpression(null, buffer, fifo)),
				 ">",
				 new ConstantExpression(null, "0"));
		read_method.appendSpecification(new RequiresSpecification(fifo, pvl_system, buffersize));
		// Add untouched variable specifications
		specs = new ArrayList<Specification>();
		specs.add(new BinarySpecification(fifo, pvl_system, wait, new OldSpecification(fifo, pvl_system, wait), "=="));
		read_method.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new SpecificationBlock(specs, fifo, pvl_system)));
		// Add buffer specification
		LinkedList<Specification> accesses = new LinkedList<Specification>();
		accesses.add(new ConstantSpecification(fifo, pvl_system, "1 .. |" + buffer.getName() + "|"));
		OldSpecification old_buf = new OldSpecification(fifo, pvl_system, new SequenceAccessSpecification(pvl_system, fifo, buffer, accesses));
		read_method.appendSpecification(new EnsuresSpecification(fifo,
																 pvl_system,
																 new BinarySpecification(fifo, pvl_system, buf, old_buf, "==")));
		// Add result specification
		accesses = new LinkedList<Specification>();
		accesses.add(new ConstantSpecification(fifo, pvl_system, "0"));
		old_buf = new OldSpecification(fifo, pvl_system, new SequenceAccessSpecification(pvl_system, fifo, buffer, accesses));
		BinarySpecification res_spec = new BinarySpecification(fifo,
															   pvl_system,
															   new ConstantSpecification(fifo, pvl_system, "\\result"),
															   old_buf,
															   "==");
		read_method.appendSpecification(new EnsuresSpecification(fifo, pvl_system, res_spec));
		// Add event specifications
		specs = new ArrayList<Specification>();
		evto_mod = new SequenceModifySpecification(fifo,
				   								   pvl_system,
				   								   new PVLVariableExpression(null, evto, fifo),
				   								   new PVLEventExpression(null, read_event),
				   								   new ConstantExpression(null, "-1"));
		specs.add(new BinarySpecification(fifo,
										  pvl_system,
										  new VariableSpecification(pvl_system, fifo, evto),
										  new OldSpecification(fifo, pvl_system, evto_mod),
										  "=="));
		read_method.appendSpecification(new EnsuresSpecification(fifo, pvl_system, new SpecificationBlock(specs, fifo, pvl_system)));
		
		pvl_system.addSpecifiable(read_method);
		pvl_functions.add(read_method);
		
		// Add methods to fifo queue and return
		fifo.setFunctions(pvl_functions);
		
		return fifo;
	}
}