package de.wwu.embdsys.sc2pvl.pvlmodel;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specifiable;

/**
 * Internal representation of the complete pvl System. Encapsulates information
 * on all classes, variables, functions, events, instances,etc.
 */
public class PVLSystem {

	/**
	 * All classes of the system.
	 */
	private List<PVLClass> classes;
	/**
	 * Maps SystemC Variables to PVLVariables
	 */
	private Map<Pair<SCVariable, PVLClass>, PVLVariable> variables;
	/**
	 * Maps SCFunctions to PVLFunctions.
	 */
	private Map<Pair<SCFunction, PVLClass>, PVLFunction> functions;
	/**
	 * All mappings from the scclasses to the pvlclasses of the system.
	 * String is used for scclasses as different scclass objects of the same class should map to the same PVL classes.
	 */
	private Map<String, List<PVLClass>> class_mappings;
	/**
	 * All class instances of the system.
	 */
	private Map<PVLClass, LinkedList<PVLVariable>> class_instances;
	/**
	 * All events of the system.
	 */
	private List<PVLEventVariable> events;
	
	private Map<SCVariable, List<PVLEventVariable>> shared_events;
	/**
	 * All parts of the system that need specifications of the system.
	 */
	private List<Specifiable> specifiables;
	
	private Map<Pair<PVLClass, SCPort>, PVLNestedVariable> port_dict;
	
	private Map<PVLClass, List<SCFunction>> functions_to_transform;

	/**
	 * Base constructor initializing the lists.
	 */
	public PVLSystem() {
		this.classes = new LinkedList<PVLClass>();
		this.variables = new HashMap<Pair<SCVariable, PVLClass>, PVLVariable>();
		this.functions = new HashMap<Pair<SCFunction, PVLClass>, PVLFunction>();
		this.class_mappings = new HashMap<String, List<PVLClass>>();
		this.class_instances = new HashMap<PVLClass, LinkedList<PVLVariable>>();
		this.events = new LinkedList<PVLEventVariable>();
		this.specifiables = new LinkedList<Specifiable>();
		this.shared_events = new HashMap<SCVariable, List<PVLEventVariable>>();
		this.port_dict = new HashMap<Pair<PVLClass, SCPort>, PVLNestedVariable>();
		this.functions_to_transform = new HashMap<PVLClass, List<SCFunction>>();
	}

	/**
	 * Adds a class instance variable to the list of instances.
	 * 
	 * @param class_toIns Class that is instantiated
	 * @param instance    Instance variable
	 */
	public void addClassInstance(PVLClass class_toIns, PVLVariable instance) {
		LinkedList<PVLVariable> instances = class_instances.get(class_toIns);
		if (instances == null) {
			instances = new LinkedList<PVLVariable>();
		}
		instances.add(instance);
		if (class_instances.containsKey(class_toIns)) {
			class_instances.replace(class_toIns, instances);
		} else {
			class_instances.put(class_toIns, instances);
		}
	}

	/**
	 * Returns all class instance mappings.
	 * 
	 * @return
	 */
	public Map<PVLClass, LinkedList<PVLVariable>> getClassInstances() {
		return class_instances;
	}

	/**
	 * Sets the class instance mapping.
	 * 
	 * @param class_instances
	 */
	public void setClassInstances(Map<PVLClass, LinkedList<PVLVariable>> class_instances) {
		this.class_instances = class_instances;
	}

	/**
	 * Adds a new class to the system.
	 * 
	 * @param new_class
	 */
	public void addClass(PVLClass new_class) {
		classes.add(new_class);
	}

	/**
	 * Add multiple new classes to the system.
	 * 
	 * @param new_classes
	 */
	public void addClasses(List<PVLClass> new_classes) {
		classes.addAll(new_classes);
	}

	/**
	 * Add a variable mapping from a SCVariable to a PVlVariable.
	 * 
	 * @param sc_var
	 * @param pvl_var
	 */
	public void addVariableMapping(SCVariable sc_var, PVLClass cls, PVLVariable pvl_var) {
		variables.put(new Pair<SCVariable, PVLClass>(sc_var, cls), pvl_var);
	}

	/**
	 * Returns all classes.
	 * 
	 * @return
	 */
	public List<PVLClass> getClasses() {
		return classes;
	}

	/**
	 * Sets all classes.
	 * 
	 * @param classes
	 */
	public void setClasses(List<PVLClass> classes) {
		this.classes = classes;
	}

	/**
	 * Returns a class with the given name.
	 * 
	 * @param name
	 * @return
	 */
	public PVLClass getClassByName(String name) {
		for (PVLClass c : classes) {
			if (c.getName().equals(name))
				return c;
		}
		return null;
	}

	/**
	 * Returns the variable mapping.
	 * 
	 * @return
	 */
	public Map<Pair<SCVariable, PVLClass>, PVLVariable> getVariables() {
		return variables;
	}

	/**
	 * Sets the variable mapping.
	 * 
	 * @param variables
	 */
	public void setVariables(Map<Pair<SCVariable, PVLClass>, PVLVariable> variables) {
		this.variables = variables;
	}

	/**
	 * Returns the function mapping from SCFunctions to PVLFunctions.
	 * 
	 * @return
	 */
	public Map<Pair<SCFunction, PVLClass>, PVLFunction> getFunctions() {
		return functions;
	}

	/**
	 * Sets the function mapping from SCFunctions to PVLFunctions.
	 * 
	 * @return
	 */
	public void setFunctions(Map<Pair<SCFunction, PVLClass>, PVLFunction> functions) {
		this.functions = functions;
	}
	
	public void addFunction(Pair<SCFunction, PVLClass> key, PVLFunction val) {
		functions.put(key, val);
	}

	/**
	 * Returns the class mapping from SCCLasses to PVLClasses.main
	 * 
	 * @return
	 */
	public Map<String, List<PVLClass>> getClassMappings() {
		return class_mappings;
	}

	/**
	 * Sets the class mapping from SCCLasses to PVLClasses.
	 * 
	 * @return
	 */
	public void setClassMappings(Map<String, List<PVLClass>> class_mappings) {
		this.class_mappings = class_mappings;
	}

	/**
	 * Returns the list of events.
	 * 
	 * @return
	 */
	public List<PVLEventVariable> getEvents() {
		return events;
	}

	/**
	 * Sets the list of events.
	 * 
	 * @param events
	 */
	public void setEvents(List<PVLEventVariable> events) {
		this.events = events;
	}

	/**
	 * Adds an event to the list of all events.
	 * 
	 * @param event
	 */
	public void addEvent(PVLEventVariable event) {
		this.events.add(event);
	}

	/**
	 * Returns the objects that need specifications.
	 * 
	 * @return
	 */
	public List<Specifiable> getSpecifiables() {
		return specifiables;
	}

	/**
	 * Sets the objects that need specifications.
	 * 
	 * @param specifiables
	 */
	public void setSpecifiables(List<Specifiable> specifiables) {
		this.specifiables = specifiables;
	}

	/**
	 * Adds an object that needs a specification.
	 * 
	 * @param spec
	 */
	public void addSpecifiable(Specifiable spec) {
		this.specifiables.add(spec);
	}

	public Map<SCVariable, List<PVLEventVariable>> getSharedEvents() {
		return shared_events;
	}

	public void setSharedEvents(Map<SCVariable, List<PVLEventVariable>> shared_events) {
		this.shared_events = shared_events;
	}
	
	public void addSharedEvent(SCVariable scevent, PVLEventVariable pvlevent) {
		List<PVLEventVariable> events = shared_events.get(scevent);
		if (events == null) {
			events = new LinkedList<PVLEventVariable>();
		}
		events.add(pvlevent);
		if (shared_events.containsKey(scevent)) {
			shared_events.replace(scevent, events);
		} else {
			shared_events.put(scevent, events);
		}
	}

	public Map<Pair<PVLClass, SCPort>, PVLNestedVariable> getPort_dict() {
		return port_dict;
	}

	public void setPort_dict(Map<Pair<PVLClass, SCPort>, PVLNestedVariable> port_dict) {
		this.port_dict = port_dict;
	}
	
	public void addPort_dict(PVLClass pvl_class, SCPort port, PVLNestedVariable var) {
		Pair<PVLClass, SCPort> key = new Pair<PVLClass, SCPort>(pvl_class, port);
		port_dict.put(key, var);
	}

	public Map<PVLClass, List<SCFunction>> getFunctionsToTransform() {
		return functions_to_transform;
	}

	public void setFunctionsToTransform(Map<PVLClass, List<SCFunction>> functions_to_transform) {
		this.functions_to_transform = functions_to_transform;
	}
	
	public void addFunctionsToTransform(PVLClass cls, List<SCFunction> functions_to_transform) {
		this.functions_to_transform.put(cls, functions_to_transform);
	}

}
