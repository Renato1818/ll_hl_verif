package de.wwu.embdsys.sc2pvl.engine;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCConnectionInterface;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCPortInstance;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.NewExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClassInstance;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLConstructor;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLEventVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLMainClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLNestedVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSequenceVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLForkExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLJoinExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLLockExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLMultiConditionExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSequenceAccessExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSequenceDeclarationExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLUnlockExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableDeclarationExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLWhileLoopExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.BinarySpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ConstantSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ContextSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.EnsuresSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.HeldSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.LoopInvariantSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.MultiConditionSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.OldSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.RequiresSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ResourceCallSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SequenceAccessSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SpecificationBlock;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.UnarySpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.VariableSpecification;

public class MainTransformer {

	PVLMainClass main;
	PVLSystem pvl_system;
	SCClass sc_main;
	SCSystem sc_system;
	LinkedList<PVLClassInstance> class_instances;
	LinkedList<PVLClassInstance> clock_instances;
	PVLSequenceVariable process_state_seq;
	PVLSequenceVariable event_state_seq;
	HashMap<String, String> instance_names;
	int event_id_max = 0;

	public MainTransformer(PVLMainClass main, PVLSystem pvl_system, SCClass sc_main, SCSystem sc_system) {
		this.main = main;
		this.pvl_system = pvl_system;
		this.sc_main = sc_main;
		this.sc_system = sc_system;
		this.class_instances = new LinkedList<PVLClassInstance>();
		this.clock_instances = new LinkedList<PVLClassInstance>();
		this.instance_names = new HashMap<String, String>();
		this.process_state_seq = main.getProcessState();
		this.event_state_seq = main.getEventState();
	}

	public void createMainClass() {
		// create fields that don't depend on the instances
		// createNonInstanceFields();
		// create constructor
		createMainConstructor();
		// save mapping from SC class to all created pvl_classes
		pvl_system.getClasses().remove(0);
		pvl_system.addClass(main);
		LinkedList<PVLClass> pvl_classes = new LinkedList<PVLClass>();
		pvl_classes.add(main);
		pvl_system.getClassMappings().put(sc_main.getName(), pvl_classes);
		pvl_system.addSpecifiable(main);
	}

	public void createAbstractFunctions() {
		// immediate wakeup
		PVLFunction im_wakeup = new PVLFunction("immediate_wakeup");
		im_wakeup.setReturnType("void");
		im_wakeup.setAbstract(true);
		List<Specification> im_wakeup_spec = new LinkedList<Specification>();
		// context
		List<Specification> context_spec = new LinkedList<Specification>();
		context_spec.add(new HeldSpecification(main, pvl_system,
				new VariableSpecification(pvl_system, main, new PVLVariable("this", "Main", main))));
		context_spec.add(new ResourceCallSpecification(main, pvl_system, null, "scheduler_permission_invariant"));
		SpecificationBlock context = new SpecificationBlock(context_spec, main, pvl_system);
		im_wakeup_spec.add(new ContextSpecification(main, pvl_system, context));
		// ensure for conditions are met
		LinkedList<Specification> met = new LinkedList<>();
		LinkedList<Specification> not_met = new LinkedList<>();
		for (int i = 0; i < ((PVLSequenceDeclarationExpression) process_state_seq.getDeclaration()).getValues().size(); i++) {
			LinkedList<Specification> cond_met = new LinkedList<>();
			LinkedList<Specification> imply = new LinkedList<>();
			LinkedList<Specification> imply_not_met = new LinkedList<>();
			LinkedList<Specification> access = new LinkedList<Specification>();
			access.add(new ConstantSpecification(main, pvl_system, "" + i));
			SequenceAccessSpecification waiting_on_i = new SequenceAccessSpecification(pvl_system, main, process_state_seq,
					access);
			OldSpecification old_wait_on_i = new OldSpecification(main, pvl_system, waiting_on_i);
			ConstantSpecification zero = new ConstantSpecification(main, pvl_system, "0");
			// create \old(process_state[i]) >= 0
			BinarySpecification comp_old_wait_on = new BinarySpecification(main, pvl_system, old_wait_on_i, zero, ">=");
			cond_met.add(comp_old_wait_on);
			// create \old(delays[\old(waiting_on[i])] == 0
			LinkedList<Specification> wait_on_access = new LinkedList<Specification>();
			wait_on_access.add(old_wait_on_i);
			SequenceAccessSpecification delays_wait_on_i = new SequenceAccessSpecification(pvl_system, main,
					event_state_seq, wait_on_access);
			OldSpecification old_delays_wait_on_i = new OldSpecification(main, pvl_system, delays_wait_on_i);
			BinarySpecification comp_old_delays = new BinarySpecification(main, pvl_system, old_delays_wait_on_i, zero,
					"==");
			cond_met.add(comp_old_delays);
			// create right side: process_state[i] == -1
			BinarySpecification wait_on_negative = new BinarySpecification(main, pvl_system, waiting_on_i,
					new ConstantSpecification(main, pvl_system, "-1"), "==");
			imply.add(wait_on_negative);
			// create left side --> right side
			MultiConditionSpecification left = new MultiConditionSpecification(main, pvl_system, cond_met, "&&");
			BinarySpecification left_imply_right = new BinarySpecification(main, pvl_system, left,
					new MultiConditionSpecification(main, pvl_system, imply, "&&"), "==>");
			met.add(left_imply_right);
			// create left side for not met
			BinarySpecification wait_is_old = new BinarySpecification(main, pvl_system, waiting_on_i, old_wait_on_i,
					"==");
			imply_not_met.add(wait_is_old);
			BinarySpecification left_imply_right_not_met = new BinarySpecification(main, pvl_system,
					new UnarySpecification(main, pvl_system, true, "!", left),
					new MultiConditionSpecification(main, pvl_system, imply_not_met, "&&"), "==>");
			not_met.add(left_imply_right_not_met);
		}
		// ensure everything else stays the same
		LinkedList<Specification> stay = new LinkedList<>();
		VariableSpecification delays_spec = new VariableSpecification(pvl_system, main, event_state_seq);
		OldSpecification old_delays = new OldSpecification(main, pvl_system, delays_spec);
		stay.add(new BinarySpecification(main, pvl_system, delays_spec, old_delays, "=="));
		EnsuresSpecification else_stays = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, stay, "&&"));
		im_wakeup_spec.add(else_stays);
		// ensure correct behavior
		EnsuresSpecification ensure_cond_met = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, met, "&&"));
		im_wakeup_spec.add(ensure_cond_met);
		EnsuresSpecification ensure_cond_not_met = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, not_met, "&&"));
		im_wakeup_spec.add(ensure_cond_not_met);
		im_wakeup.setSpecifications(im_wakeup_spec);
		main.addFunction(im_wakeup);

		// reset events no delta
		PVLFunction reset_events_no_delta = new PVLFunction("reset_events_no_delta");
		reset_events_no_delta.setReturnType("void");
		reset_events_no_delta.setAbstract(true);
		List<Specification> reset_events_no_delta_spec = new LinkedList<Specification>();
		// add context - reuse from other function
		reset_events_no_delta_spec.add(new ContextSpecification(main, pvl_system, context));
		// ensure for conditions are met
		LinkedList<Specification> met_reset = new LinkedList<>();
		LinkedList<Specification> not_met_reset = new LinkedList<>();
		for (int i = 0; i < ((PVLSequenceDeclarationExpression) event_state_seq.getDeclaration()).getValues()
				.size(); i++) {
			LinkedList<Specification> imply = new LinkedList<>();
			LinkedList<Specification> concl = new LinkedList<>();
			LinkedList<Specification> access = new LinkedList<Specification>();
			access.add(new ConstantSpecification(main, pvl_system, "" + i));
			// create \old(event_state[i]) == 0
			SequenceAccessSpecification delays_i = new SequenceAccessSpecification(pvl_system, main, event_state_seq,
					access);
			OldSpecification old_delays_i = new OldSpecification(main, pvl_system, delays_i);
			ConstantSpecification zero = new ConstantSpecification(main, pvl_system, "0");
			BinarySpecification comp_old_delays = new BinarySpecification(main, pvl_system, old_delays_i, zero, "==");
			imply.add(comp_old_delays);
			// create delays[0] == -1
			ConstantSpecification minus_2 = new ConstantSpecification(main, pvl_system, "-2");
			BinarySpecification comp_delay = new BinarySpecification(main, pvl_system, delays_i, minus_2, "==");
			// create delays[0] == -1 && occurred[0]
			concl.add(comp_delay);
			MultiConditionSpecification right = new MultiConditionSpecification(main, pvl_system, concl, "&&");
			// create \old(delays[i]) == 0 && !\old(delta_delay[i]) ==> delays[0] == -1
			MultiConditionSpecification left = new MultiConditionSpecification(main, pvl_system, imply, "&&");
			BinarySpecification left_imply_right = new BinarySpecification(main, pvl_system, left, right, "==>");
			met_reset.add(left_imply_right);
			// create delays[i] == \old(delays[i])
			BinarySpecification comp_delay_old = new BinarySpecification(main, pvl_system, delays_i, old_delays_i,
					"==");
			// create delays[i] == \old(delays[i] && occurred[0] = \old(occurred[0]
			imply = new LinkedList<>();
			imply.add(comp_delay_old);
			MultiConditionSpecification not_right = new MultiConditionSpecification(main, pvl_system, imply, "&&");
			// create !(\old(delays[i]) == 0 && !\old(delta_delay[i])) ==> delays[0] ==
			// \old(delays[i])
			UnarySpecification not_left = new UnarySpecification(main, pvl_system, true, "!", left);
			BinarySpecification left_imply_right_not_met = new BinarySpecification(main, pvl_system, not_left,
					not_right, "==>");
			not_met_reset.add(left_imply_right_not_met);
		}
		// ensure everything else stays the same
		LinkedList<Specification> stay_reset = new LinkedList<>();
		VariableSpecification wait_on_spec = new VariableSpecification(pvl_system, main, process_state_seq);
		OldSpecification old_wait_on_reset = new OldSpecification(main, pvl_system, wait_on_spec);
		stay_reset.add(new BinarySpecification(main, pvl_system, wait_on_spec, old_wait_on_reset, "=="));
		EnsuresSpecification else_stays_reset = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, stay_reset, "&&"));
		reset_events_no_delta_spec.add(else_stays_reset);
		// ensure correct behavior
		EnsuresSpecification ensure_cond_met_reset = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, met_reset, "&&"));
		reset_events_no_delta_spec.add(ensure_cond_met_reset);
		EnsuresSpecification ensure_cond_not_met_reset = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, not_met_reset, "&&"));
		reset_events_no_delta_spec.add(ensure_cond_not_met_reset);
		reset_events_no_delta.setSpecifications(reset_events_no_delta_spec);
		main.addFunction(reset_events_no_delta);

		// find minimum advance
		PVLFunction find_minimum_advance = new PVLFunction("find_minimum_advance");
		find_minimum_advance.setReturnType("int");
		find_minimum_advance.setAbstract(true);
		find_minimum_advance.setPure(true);
		PVLSequenceVariable vars = new PVLSequenceVariable("vals", "int", false, main);
		find_minimum_advance.addParameter(vars);
		List<Specification> find_minimum_advance_spec = new LinkedList<Specification>();
		// create requires |vals| == 6
		int size_of_delays = ((PVLSequenceDeclarationExpression) event_state_seq.getDeclaration()).getValues().size();
		ConstantSpecification size_vals = new ConstantSpecification(main, pvl_system, "|vals|");
		BinarySpecification comp_size = new BinarySpecification(null, pvl_system, size_vals,
				new ConstantSpecification(main, pvl_system, "" + size_of_delays), "==");
		RequiresSpecification req_var_size = new RequiresSpecification(main, pvl_system, comp_size);
		find_minimum_advance_spec.add(req_var_size);

		// create the ensures statements
		LinkedList<Specification> cond_first = new LinkedList<>();
		LinkedList<Specification> cond_second = new LinkedList<>();
		LinkedList<Specification> allValuesLess = new LinkedList<>();
		LinkedList<Specification> allValuesGreater= new LinkedList<>();
		for (int i = 0; i < size_of_delays; i++) {
			LinkedList<Specification> access = new LinkedList<Specification>();
			access.add(new ConstantSpecification(main, pvl_system, "" + i));
			// create vals[i]
			SequenceAccessSpecification vals_i = new SequenceAccessSpecification(pvl_system, main, vars, access);
			// create vals[i] < 0
			ConstantSpecification minus_1 = new ConstantSpecification(main, pvl_system, "-1");
			BinarySpecification vals_less_zero = new BinarySpecification(main, pvl_system, vals_i, minus_1, "<");
			// create \result <= vals[i]
			allValuesLess.add(vals_less_zero);
			BinarySpecification vals_great_zero = new BinarySpecification(main, pvl_system, vals_i, minus_1, ">=");
			allValuesGreater.add(vals_great_zero);
			ConstantSpecification result = new ConstantSpecification(main, pvl_system, "\\result");
			BinarySpecification result_less_vals = new BinarySpecification(main, pvl_system, result, vals_i, "<=");
			// create vals[i] < 0 || \result <= vals[i]
			BinarySpecification comp_vals = new BinarySpecification(main, pvl_system, vals_less_zero, result_less_vals,
					"||");
			cond_first.add(comp_vals);
			//create \result == vals[i]
			BinarySpecification result_equals_vals = new BinarySpecification(main, pvl_system, result, vals_i, "==");
			cond_second.add(new BinarySpecification(main, pvl_system, vals_great_zero, result_equals_vals, "&&"));
		}
		ConstantSpecification result = new ConstantSpecification(main, pvl_system, "\\result");
		BinarySpecification result_zero  = new BinarySpecification(main, pvl_system, result, new ConstantSpecification(main, pvl_system, "0"), "==");
		MultiConditionSpecification allLessZero = new MultiConditionSpecification(main, pvl_system, allValuesLess, "&&");
		BinarySpecification lessImpliesResult = new BinarySpecification(main, pvl_system, allLessZero, result_zero, "==>");
		BinarySpecification greaterImpliesResult = new BinarySpecification(main, pvl_system, new MultiConditionSpecification(main, pvl_system, allValuesGreater, "||"), new MultiConditionSpecification(main, pvl_system, cond_second, "||"), "==>");
		// first ensures statement
		EnsuresSpecification res_is_lower_bound = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, cond_first, "&&"));
		find_minimum_advance_spec.add(res_is_lower_bound);
		EnsuresSpecification res_is_minimum = new EnsuresSpecification(main, pvl_system,new BinarySpecification(main, pvl_system, lessImpliesResult, greaterImpliesResult,"&&"));
		find_minimum_advance_spec.add(res_is_minimum);
		find_minimum_advance.setSpecifications(find_minimum_advance_spec);
		main.addFunction(find_minimum_advance);

		// wakeup_after_wait
		PVLFunction wakeup_after_wait = new PVLFunction("wakeup_after_wait");
		wakeup_after_wait.setReturnType("void");
		wakeup_after_wait.setAbstract(true);
		List<Specification> wakeup_after_wait_spec = new LinkedList<Specification>();
		// context
		wakeup_after_wait_spec.add(new ContextSpecification(main, pvl_system, context));
		// ensure for conditions are met
		LinkedList<Specification> met_wakeup = new LinkedList<>();
		LinkedList<Specification> not_met_wakeup = new LinkedList<>();
		for (int i = 0; i < ((PVLSequenceDeclarationExpression) process_state_seq.getDeclaration()).getValues().size(); i++) {
			LinkedList<Specification> cond_met = new LinkedList<>();
			LinkedList<Specification> imply = new LinkedList<>();
			LinkedList<Specification> imply_not_met = new LinkedList<>();
			LinkedList<Specification> access = new LinkedList<Specification>();
			access.add(new ConstantSpecification(main, pvl_system, "" + i));
			SequenceAccessSpecification waiting_on_i = new SequenceAccessSpecification(pvl_system, main, process_state_seq,
					access);
			OldSpecification old_wait_on_i = new OldSpecification(main, pvl_system, waiting_on_i);
			ConstantSpecification zero = new ConstantSpecification(main, pvl_system, "0");
			ConstantSpecification minus_1 = new ConstantSpecification(main, pvl_system, "-1");
			// create \old(waiting_on[i]) >= 0
			BinarySpecification comp_old_wait_on = new BinarySpecification(main, pvl_system, old_wait_on_i, zero, ">=");
			cond_met.add(comp_old_wait_on);
			// create \old(delays[\old(waiting_on[i])]) == 0 || \old(delays[\old(waiting_on[i])]) == -1
			LinkedList<Specification> wait_on_access = new LinkedList<Specification>();
			wait_on_access.add(old_wait_on_i);
			SequenceAccessSpecification delays_wait_on_i = new SequenceAccessSpecification(pvl_system, main,
					event_state_seq, wait_on_access);
			OldSpecification old_delays_wait_on_i = new OldSpecification(main, pvl_system, delays_wait_on_i);
			BinarySpecification comp_old_delays_0 = new BinarySpecification(main, pvl_system, old_delays_wait_on_i, zero,
					"==");
			BinarySpecification comp_old_delays_1 = new BinarySpecification(main, pvl_system, old_delays_wait_on_i, minus_1, "==");
			BinarySpecification comp_old_delays = new BinarySpecification(main, pvl_system, comp_old_delays_0, comp_old_delays_1, "||");
			cond_met.add(comp_old_delays);
			// create left side: wait_on[i] == -1 && ready[i]
			BinarySpecification wait_on_negative = new BinarySpecification(main, pvl_system, waiting_on_i,
					new ConstantSpecification(main, pvl_system, "-1"), "==");
			imply.add(wait_on_negative);
			// create left side --> right side
			MultiConditionSpecification left = new MultiConditionSpecification(main, pvl_system, cond_met, "&&");
			BinarySpecification left_imply_right = new BinarySpecification(main, pvl_system, left,
					new MultiConditionSpecification(main, pvl_system, imply, "&&"), "==>");
			met_wakeup.add(left_imply_right);
			// create left side for not met
			BinarySpecification wait_is_old = new BinarySpecification(main, pvl_system, waiting_on_i, old_wait_on_i,
					"==");
			imply_not_met.add(wait_is_old);
			BinarySpecification left_imply_right_not_met = new BinarySpecification(main, pvl_system,
					new UnarySpecification(main, pvl_system, true, "!", left),
					new MultiConditionSpecification(main, pvl_system, imply_not_met, "&&"), "==>");
			not_met_wakeup.add(left_imply_right_not_met);
		}
		// ensure everything else stays the same
		wakeup_after_wait_spec.add(else_stays);
		// ensure correct behavior
		EnsuresSpecification ensure_cond_met_wakeup = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, met_wakeup, "&&"));
		wakeup_after_wait_spec.add(ensure_cond_met_wakeup);
		EnsuresSpecification ensure_cond_not_met_wakeup = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, not_met_wakeup, "&&"));
		wakeup_after_wait_spec.add(ensure_cond_not_met_wakeup);
		wakeup_after_wait.setSpecifications(wakeup_after_wait_spec);
		main.addFunction(wakeup_after_wait);

		// reset all events
		PVLFunction reset_all_events = new PVLFunction("reset_all_events");
		reset_all_events.setReturnType("void");
		reset_all_events.setAbstract(true);
		List<Specification> reset_all_events_spec = new LinkedList<Specification>();
		// add context - reuse from other function
		reset_all_events_spec.add(new ContextSpecification(main, pvl_system, context));
		// ensure for conditions are met
		LinkedList<Specification> met_reset_all = new LinkedList<>();
		LinkedList<Specification> not_met_reset_all = new LinkedList<>();
		for (int i = 0; i < ((PVLSequenceDeclarationExpression) event_state_seq.getDeclaration()).getValues()
				.size(); i++) {
			LinkedList<Specification> imply = new LinkedList<>();
			LinkedList<Specification> imply_not_met = new LinkedList<>();
			LinkedList<Specification> access = new LinkedList<Specification>();
			access.add(new ConstantSpecification(main, pvl_system, "" + i));
			// create \old(delays[i]) == 0 || \old(delays[i] == -1
			SequenceAccessSpecification delays_i = new SequenceAccessSpecification(pvl_system, main, event_state_seq,
					access);
			OldSpecification old_delays_i = new OldSpecification(main, pvl_system, delays_i);
			ConstantSpecification zero = new ConstantSpecification(main, pvl_system, "0");
			ConstantSpecification minus_1 = new ConstantSpecification(main, pvl_system, "-1");
			ConstantSpecification minus_2 = new ConstantSpecification(main, pvl_system, "-2");
			BinarySpecification comp_old_delays_0 = new BinarySpecification(main, pvl_system, old_delays_i, zero, "==");
			BinarySpecification comp_old_delays_1 = new BinarySpecification(main, pvl_system, old_delays_i, minus_1, "==");
			BinarySpecification comp_old_delays = new BinarySpecification(main, pvl_system, comp_old_delays_0, comp_old_delays_1, "||");
			// create delays[0] == -2
			BinarySpecification comp_delay = new BinarySpecification(main, pvl_system, delays_i, minus_2, "==");
			imply.add(comp_delay);
			// create \old(delays[i]) == 0 ==> !delta_delay[i] && delays[0] == -1
			MultiConditionSpecification right = new MultiConditionSpecification(main, pvl_system, imply, "&&");
			BinarySpecification left_imply_right = new BinarySpecification(main, pvl_system, comp_old_delays, right,
					"==>");
			met_reset_all.add(left_imply_right);
			// create delays[i] == \old(delays[i])
			BinarySpecification comp_delay_old = new BinarySpecification(main, pvl_system, delays_i, old_delays_i,
					"==");
			imply_not_met.add(comp_delay_old);
			// create !(\old(delays[i]) == 0) ==> delays[i] == \old(delays[i]) &&
			// delta_delay[i] == \old(delta_delay[i])
			UnarySpecification not_left = new UnarySpecification(main, pvl_system, true, "!", comp_old_delays);
			BinarySpecification left_imply_right_not_met = new BinarySpecification(main, pvl_system, not_left,
					new MultiConditionSpecification(main, pvl_system, imply_not_met, "&&"), "==>");
			not_met_reset_all.add(left_imply_right_not_met);
		}
		// ensure everything else stays the same
		LinkedList<Specification> stay_reset_all = new LinkedList<>();
		stay_reset_all.add(new BinarySpecification(main, pvl_system, wait_on_spec, old_wait_on_reset, "=="));
		EnsuresSpecification else_stays_reset_all = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, stay_reset_all, "&&"));
		reset_all_events_spec.add(else_stays_reset_all);
		// ensure correct behavior
		EnsuresSpecification ensure_cond_met_reset_all = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, met_reset_all, "&&"));
		reset_all_events_spec.add(ensure_cond_met_reset_all);
		EnsuresSpecification ensure_cond_not_met_reset_all = new EnsuresSpecification(main, pvl_system,
				new MultiConditionSpecification(main, pvl_system, not_met_reset_all, "&&"));
		reset_all_events_spec.add(ensure_cond_not_met_reset_all);
		reset_all_events.setSpecifications(reset_all_events_spec);
		main.addFunction(reset_all_events);
	}

	public void createMainMethod() {
		PVLFunction main_func = new PVLFunction("main");
		main_func.setReturnType("void");
		PVLVariable this_var = new PVLVariable("this", "Main", main);
		main_func.setCorrClass(main);
		// create body
		LinkedList<Expression> body = new LinkedList<Expression>();

		// lock object
		PVLLockExpression lock = new PVLLockExpression(null, new PVLVariableExpression(null, this_var, main));
		body.add(lock);

		// fork all runnables
		for (PVLVariable field : main.getFields()) {
			if (field instanceof PVLClassInstance proc && proc.isRunnable()) {
				PVLForkExpression fork_seq = new PVLForkExpression(null, new PVLVariableExpression(null, field, main));
				body.add(fork_seq);
			}
		}

		// unlock object
		PVLUnlockExpression unlock = new PVLUnlockExpression(null, new PVLVariableExpression(null, this_var, main));
		body.add(unlock);

		// set up while(true) loop
		LinkedList<Expression> while_body = new LinkedList<Expression>();
		// lock object
		while_body.add(new PVLLockExpression(null, new PVLVariableExpression(null, this_var, main)));
		// call abstract functions //TODO:fix this
		while_body.add(new ConstantExpression(null, "immediate_wakeup();"));
		while_body.add(new ConstantExpression(null, "reset_events_no_delta();"));
		// handle clock triggers
		// currently not used
		/*
		 * for(PVLVariable clock : clock_instances) { //create if condition int[]
		 * event_ids = ((PVLClassInstance) clock).getEventIds(); LinkedList<Expression>
		 * equals_minus_1 = new LinkedList<Expression>(); for(int i = 0; i<
		 * event_ids.length; i++) { LinkedList<Expression> access = new
		 * LinkedList<Expression>(); access.add(new ConstantExpression(null, "" +
		 * event_ids[i])); PVLSequenceAccessExpression seq_access = new
		 * PVLSequenceAccessExpression(null, ev_timeout_seq, access, main, pvl_system);
		 * BinaryExpression comp = new BinaryExpression(null, seq_access, "==", new
		 * ConstantExpression(null, "-1")); equals_minus_1.add(comp); } //create trigger
		 * expression LinkedList<Expression> if_body = new LinkedList<Expression>();
		 * ConstantExpression trigger = new ConstantExpression(null,
		 * "insert trigger here"); if_body.add(trigger); //create if IfElseExpression
		 * clock_if_else = new IfElseExpression(null, new
		 * PVLMultiConditionExpression(null, equals_minus_1, "&&"),if_body, new
		 * LinkedList<Expression> ()); while_body.add(clock_if_else); }
		 */

		ConstantExpression minus_3 = new ConstantExpression(null, "-3");
		ConstantExpression minus_1 = new ConstantExpression(null, "-1");
		ConstantExpression zero = new ConstantExpression(null, "0");
		// check if no process is ready
		LinkedList<Expression> all_not_ready = main.getAllNotReadyCond();
		for (int i = 0; i < ((PVLSequenceDeclarationExpression) process_state_seq.getDeclaration()).getValues().size(); i++) {
			LinkedList<Expression> number = new LinkedList<>();
			ConstantExpression i_exp = new ConstantExpression(null, "" + i);
			number.add(i_exp);
			PVLSequenceAccessExpression access = new PVLSequenceAccessExpression(null, process_state_seq, number, main);
			BinaryExpression not_ready = new BinaryExpression(null, access, "!=", minus_1);
			all_not_ready.add(not_ready);
		}
		// create if body
		LinkedList<Expression> if_body = new LinkedList<Expression>();
		// compute min advance
		PVLVariable min_var = new PVLVariable("min_advance", "int", main);
		PVLVariableExpression min_var_exp = new PVLVariableExpression(null, min_var, main);
		ConstantExpression function_min = new ConstantExpression(null,
				"find_minimum_advance(" + event_state_seq.getName() + ")");
		PVLVariableDeclarationExpression assign_min_var = new PVLVariableDeclarationExpression(null, min_var,
				function_min);
		if_body.add(assign_min_var);
		// check if min_advance == -1 and set to 0 if that is the case
		BinaryExpression check_min_var = new BinaryExpression(null, min_var_exp, "==", minus_1);
		BinaryExpression reset_min_var = new BinaryExpression(null, min_var_exp, "=", zero);
		if_body.add(new IfElseExpression(null, check_min_var, List.of(reset_min_var), new LinkedList<Expression>()));
		// advance all delays
		LinkedList<Expression> advance_delays = new LinkedList<>();
		for (int i = 0; i < ((PVLSequenceDeclarationExpression) event_state_seq.getDeclaration()).getValues()
				.size(); i++) {
			LinkedList<Expression> number = new LinkedList<>();
			ConstantExpression i_exp = new ConstantExpression(null, "" + i);
			number.add(i_exp);
			PVLSequenceAccessExpression access = new PVLSequenceAccessExpression(null, event_state_seq, number, main);
			BinaryExpression compareTimeout = new BinaryExpression(null, access, "<", minus_1);
			BinaryExpression advance_delay = new BinaryExpression(null, access, "-", min_var_exp);
			BinaryExpression regOrMin = new BinaryExpression(null, minus_3, ":", advance_delay);
			BinaryExpression questionExp = new BinaryExpression(null, compareTimeout, "?", regOrMin);
			advance_delays.add(questionExp);
		}
		PVLSequenceDeclarationExpression assign_new_delay = new PVLSequenceDeclarationExpression(null,
				new PVLVariableExpression(null, event_state_seq, main), advance_delays);
		if_body.add(assign_new_delay);
		if_body.add(new ConstantExpression(null, "wakeup_after_wait();"));
		if_body.add(new ConstantExpression(null, "reset_all_events();"));
		// handle clock triggers
		/*
		 * for(PVLVariable clock : clock_instances) { //create if condition int[]
		 * event_ids = ((PVLClassInstance) clock).getEventIds(); LinkedList<Expression>
		 * equals_minus_1 = new LinkedList<Expression>(); for(int i = 0; i<
		 * event_ids.length; i++) { LinkedList<Expression> access = new
		 * LinkedList<Expression>(); access.add(new ConstantExpression(null, "" +
		 * event_ids[i])); PVLSequenceAccessExpression seq_access = new
		 * PVLSequenceAccessExpression(null, ev_timeout_seq, access, main, pvl_system);
		 * BinaryExpression comp = new BinaryExpression(null, seq_access, "==", new
		 * ConstantExpression(null, "-1")); equals_minus_1.add(comp); } //create trigger
		 * expression LinkedList<Expression> inner_if_body = new
		 * LinkedList<Expression>(); ConstantExpression trigger = new
		 * ConstantExpression(null, "insert trigger here"); inner_if_body.add(trigger);
		 * //create if IfElseExpression clock_if_else = new IfElseExpression(null, new
		 * PVLMultiConditionExpression(null, equals_minus_1, "&&"),inner_if_body, new
		 * LinkedList<Expression> ()); if_body.add(clock_if_else); }
		 */
		IfElseExpression second_if = new IfElseExpression(null,
				new PVLMultiConditionExpression(null, all_not_ready, "&&"), if_body, new LinkedList<Expression>());

		while_body.add(second_if);
		// unlock object
		while_body.add(unlock);
		PVLWhileLoopExpression while_loop = new PVLWhileLoopExpression(null, null, new ConstantExpression(null, "true"),
				while_body, main, new LinkedList<Expression>());		// Hardcoded loops don't need path conditions
		ConstantSpecification true_spec = new ConstantSpecification(main, pvl_system, "true");
		LinkedList<Specification> loop_specs = new LinkedList<Specification>();
		loop_specs.add(true_spec);
		while_loop.appendSpecification(new LoopInvariantSpecification(main, pvl_system, loop_specs));
		body.add(while_loop);

		// join all runnables
		for (PVLVariable field : main.getFields()) {
			if (field instanceof PVLClassInstance proc && proc.isRunnable()) {
				PVLJoinExpression join_seq = new PVLJoinExpression(null, new PVLVariableExpression(null, field, main));
				body.add(join_seq);
			}
		}

		main_func.setBody(body);
		main.addFunction(main_func);
		pvl_system.addSpecifiable(main_func);
	}

	/*
	 * private void createNonInstanceFields() { // create ready sequence ready_seq =
	 * new PVLSequenceVariable("ready", "boolean", false, main);
	 * main.addField(ready_seq); // create wait_on sequence wait_on_seq = new
	 * PVLSequenceVariable("wait_on", "int", false, main);
	 * main.addField(wait_on_seq); // create delays sequence ev_timeout_seq = new
	 * PVLSequenceVariable("ev_timeout", "int", false, main);
	 * main.addField(ev_timeout_seq); // create delta_delay sequence delta_delay_seq
	 * = new PVLSequenceVariable("delta_delay", "boolean", false, main);
	 * main.addField(delta_delay_seq);// create init sequence occurred_seq = new
	 * PVLSequenceVariable("occurred", "boolean", false, main);
	 * main.addField(occurred_seq); }
	 */

	private void createMainConstructor() {
		PVLConstructor cons = new PVLConstructor("Main", main);
		List<PVLVariable> fields = main.getFields();
		// add parameter
		/*
		 * PVLVariable md0_par = new PVLVariable("md0", "int", main); //TODO:think about
		 * global parameters? cons.addParameter(md0_par);
		 */

		// create body
		LinkedList<Expression> body = new LinkedList<Expression>();
		// for each sequence field add declaration
		PVLSequenceDeclarationExpression process_state_dec = new PVLSequenceDeclarationExpression(null,
				new PVLVariableExpression(null, main.getProcessState(), main), new LinkedList<Expression>());
		main.getProcessState().setDeclaration(process_state_dec);
		body.add(process_state_dec);
		ConstantExpression event_order = new ConstantExpression(null, "//");
		body.add(event_order);
		PVLSequenceDeclarationExpression event_state_dec = new PVLSequenceDeclarationExpression(null,
				new PVLVariableExpression(null, main.getEventState(), main), new LinkedList<Expression>());
		main.getEventState().setDeclaration(event_state_dec);
		body.add(event_state_dec);

		// set event_ids for all shared events
		for(List<PVLEventVariable> vars : pvl_system.getSharedEvents().values()) {
			for (PVLEventVariable var : vars) {
				var.setEventId(event_id_max);
			}
			event_id_max++;
		}

		for (SCClassInstance instance : sc_system.getInstances()) {
			SCClass corr_class = instance.getSCClass();
			String instance_name = instance.getName();
			List<PVLClass> pvl_classes = pvl_system.getClassMappings()
												.get(corr_class.getName())
												.stream()
												.filter(c -> c.getGenerating_instance().equals(instance))
												.toList();

			for (int i = 0; i < pvl_classes.size(); i++) {
				if (pvl_classes.size() == 1 && pvl_classes.get(i).isRunnable()
						&& !pvl_classes.get(i).getName().equals("Sc_clock")) {
					createInstanceDeclaration(cons, instance, pvl_classes.get(i), instance_name, fields,
							body, process_state_dec, event_state_dec, event_order, true, true);
				} else if (!pvl_classes.get(i).isRunnable()) {
					createInstanceDeclaration(cons, instance, pvl_classes.get(i), instance_name, fields,
							body, process_state_dec, event_state_dec, event_order, false, true);
				} else {
					createInstanceDeclaration(cons, instance, pvl_classes.get(i), instance_name, fields,
							body, process_state_dec, event_state_dec, event_order, true, false);
				}
			}
		}
		cons.setBody(body);
		main.addConstructors(cons);
	}

	private void createInstanceDeclaration(PVLConstructor cons, SCClassInstance instance, PVLClass pvl_class,
			String instance_name, List<PVLVariable> fields,
			LinkedList<Expression> body, PVLSequenceDeclarationExpression process_state_dec,
			PVLSequenceDeclarationExpression event_state_dec, ConstantExpression event_order, boolean runnable, boolean state) {
		// get name of variable
		String name = state ? instance_name : instance_name + "_" + pvl_class.getName().toLowerCase();
		instance_names.put(instance_name, name);

		// get type of variable
		PVLClassInstance var = new PVLClassInstance(name, pvl_class, main);
		pvl_system.addClassInstance(pvl_class, var);
		//String comment_for_instance = "//";
		cons.addInstantiated(var);
		// get arguments for initialization
		LinkedList<Expression> arg = new LinkedList<Expression>();
		// first argument: reference to main
		PVLVariable this_var = new PVLVariable("this", "Main", main);
		arg.add(new PVLVariableExpression(null, this_var, pvl_class));
		// for runnables: third argument is reference to ready sequence entry
		var.setRunnable(runnable);
		/*if (runnable) {
			// check how many runnables are already in the sequence
			int ready_count = process_state_dec.getValues().size();
			// set instance id of current instance
			pvl_class.setRunnableId(ready_count);
			// also add instance to sequence initialization list
			process_state_dec.addValue(new ConstantExpression(null, "-1"));
			// add info to comment
			comment_for_instance += ", id in ready sequence:" + ready_count;
			// set info in instance variable
			var.setRunnable(true);
		}
		// next arguments: ids for all events that are used in this class
		// add events
		String current_event_order = "";
		int[] event_ids = new int[pvl_class.getEvents().size()];
		for (int i = 0; i < pvl_class.getEvents().size(); i++) {
			pvl_system.addEvent(pvl_class.getEvents().get(i));
			int event_id;
			if(pvl_class.getEvents().get(i).getEventId() != -1) {
				event_id = pvl_class.getEvents().get(i).getEventId();
			}
			else {
				event_id = event_id_max;
				event_id_max++;
			}

			if(event_state_dec.getValues().size() < event_id_max) {
				// add entry in the sequence delays
				event_state_dec.addValue(new ConstantExpression(null, "-3"));
			}

			// update event order comment
			event_ids[i] = event_id;
		}
		// set info in instance variable
		var.setEventIds(event_ids);

		// add instance declaration to list of class instances
		if (var.getType().equals("Sc_clock"))
			clock_instances.add(var);
		else
			class_instances.add(var);
		// set event_order expression
		event_order.setValue(event_order.getValue() + current_event_order);
		// add comment expression
		body.add(new ConstantExpression(null, comment_for_instance));
		// initialize variable*/
		NewExpression exp = new NewExpression(null);
		exp.setObjType(var.getType());
		exp.setArguments(arg);
		PVLVariableExpression var_expr = new PVLVariableExpression(null, var, pvl_class);
		BinaryExpression init_var = new BinaryExpression(null, var_expr, "=", exp);

		body.add(init_var);
		fields.add(var);
		
		for (SCConnectionInterface socket_instance : instance.getPortSocketInstances()) {
			if (socket_instance instanceof SCPortInstance) {
				SCPort port = ((SCPortInstance) socket_instance).getPortSocket();
				PVLNestedVariable port_var = pvl_system.getPort_dict().get(new Pair<PVLClass, SCPort>(pvl_class, port));
				PVLVariable port_var_inner = port_var.getInnerVar();
				
				List<SCKnownType> channels = ((SCPortInstance) socket_instance).getChannels();
				List<SCClassInstance> modules = ((SCPortInstance) socket_instance).getModuleInstances();
				// TODO: Discuss SystemC semantics
				if (channels.size() != 0) {
					SCKnownType channel = channels.get(0);
					
					port_var_inner.setName(channel.getName());
					port_var_inner.setType(main.getFieldByName(channel.getName()).getType());
				}
				else if (modules.size() != 0) {
					SCClassInstance module = modules.get(0);
					
					port_var_inner.setName(module.getName());
					port_var_inner.setType(main.getFieldByName(module.getName()).getType());
				}
				else {
					throw new IllegalStateException("Port has no channels or modules attached!");
				}
			}
		}
	}

}
