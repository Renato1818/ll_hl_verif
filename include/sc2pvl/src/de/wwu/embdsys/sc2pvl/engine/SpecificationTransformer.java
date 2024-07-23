package de.wwu.embdsys.sc2pvl.engine;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLArray;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClassInstance;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLConstructor;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLFunction;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLMainClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLNestedVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSequenceAccessVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSequenceVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLArrayExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLLoopExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSequenceDeclarationExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLSizeExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableDeclarationExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableExpression;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ArrayPermSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ArraySpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.BinarySpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ConstantSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ContextSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.EnsuresSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ForAllSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.HeldSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.IdleSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.InlineResourceSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.LoopInvariantSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.MultiConditionSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.MultiSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.PermissionSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.RequiresSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ResourceCallSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.ResourceSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SequenceAccessSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SizeSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specifiable;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.SpecificationBlock;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.TriggerSpecification;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.VariableSpecification;

public class SpecificationTransformer {

	private PVLSystem pvl_system;

	public SpecificationTransformer(PVLSystem pvl_system) {
		this.pvl_system = pvl_system;
	}

	public void createSpecifications(List<? extends Specifiable> specifiables) {
		for (Specifiable spec : specifiables) {
			if (spec instanceof PVLConstructor) {
				createConstructorSpecification((PVLConstructor) spec);
			} else if (spec instanceof PVLFunction) {
				if (((PVLFunction) spec).getCorrClass().getName().equals("Main")) {
					createMainFunctionSpecification((PVLFunction) spec);
				} else {
					createFunctionSpecification((PVLFunction) spec);
				}
			} else if (spec instanceof PVLLoopExpression) {
				createLoopSpecification((PVLLoopExpression) spec);
			} else if (spec instanceof PVLClass) {
				if (((PVLClass) spec).getName().equals("Main")) {
					createGlobalInvariant((PVLMainClass) spec);
				}
			}
		}
	}

	private void createMainFunctionSpecification(PVLFunction main_func) {
		PVLMainClass main = (PVLMainClass) pvl_system.getClassByName("Main");
		// for each instance sequence: read permission, length check, for each entry:
		// not null, 1/2 permission, main == this check
		LinkedList<PVLSequenceVariable> sequences = main.getAllClassSequenceFields();
		LinkedList<Specification> main_spec = new LinkedList<>();
		for (PVLSequenceVariable sequence : sequences) {
			LinkedList<Specification> specs_sequence = new LinkedList<>();
			if (sequence.isRunnable()) {
				VariableSpecification seq_spec = new VariableSpecification(pvl_system, main, sequence);
				PermissionSpecification read_seq = new PermissionSpecification(main, pvl_system, seq_spec, 0.5f);
				specs_sequence.add(read_seq);
				int size = ((PVLSequenceDeclarationExpression) sequence.getDeclaration()).getValues().size();
				ConstantSpecification size_seq = new ConstantSpecification(main, pvl_system,
						"|" + sequence.getName() + "| == " + size);
				specs_sequence.add(size_seq);
				for (int j = 0; j < size; j++) {
					LinkedList<Specification> access = new LinkedList<>();
					access.add(new ConstantSpecification(main, pvl_system, "" + j));
					SequenceAccessSpecification access_at_j = new SequenceAccessSpecification(pvl_system, main, sequence,
							access);
					// not null check
					BinarySpecification not_null = new BinarySpecification(main, pvl_system, access_at_j,
							new ConstantSpecification(main, pvl_system, "null"), "!=");
					specs_sequence.add(not_null);
					// main identity check
					PVLSequenceAccessVariable seq_j = new PVLSequenceAccessVariable(main, sequence, j);
					PVLNestedVariable main_ref = new PVLNestedVariable(seq_j,
							pvl_system.getClassByName(sequence.getType()).getMainRef());
					PVLVariable this_var = new PVLVariable("this", "Main", main);
					// read permission
					PermissionSpecification read_instance = new PermissionSpecification(main, pvl_system, new VariableSpecification(pvl_system, main, main_ref),
							0.5f);
					specs_sequence.add(read_instance);
					VariableSpecification main_ref_spec = new VariableSpecification(pvl_system, main, main_ref);
					VariableSpecification this_var_spec = new VariableSpecification(pvl_system, main, this_var);
					BinarySpecification main_identity = new BinarySpecification(main, pvl_system, main_ref_spec,
							this_var_spec, "==");
					specs_sequence.add(main_identity);
					// idle
					IdleSpecification idle_instance = new IdleSpecification(main, pvl_system, access_at_j);
					specs_sequence.add(idle_instance);
				}
				SpecificationBlock context_block = new SpecificationBlock(specs_sequence, main, pvl_system);
				ContextSpecification context = new ContextSpecification(main, pvl_system, context_block);
				main_spec.add(context);
			}
		}
		main_func.setSpecifications(main_spec);
	}

	private void createFunctionSpecification(PVLFunction func) {
		/*
		 * creates: context Perm(m, 1\2) m != null Perm(instance_id, read)
		 ** Perm(m.consumer_instances, read) (0 <= instance_id && instance_id <
		 * |m.consumer_instances|) m.consumer_instances[instance_id] == this;
		 */
		
		// pure functions do not need specifications
		if (func.isPure()) {
			return;
		}

		// get variable references
		PVLVariable main = func.getCorrClass().getMainRef();
		VariableSpecification main_spec = new VariableSpecification(pvl_system, func.getCorrClass(), main);
		PVLVariable instances = ((PVLMainClass) pvl_system.getClassByName("Main"))
				.getFieldByType(func.getCorrClass().getName());
		PVLNestedVariable instance_in_main = new PVLNestedVariable(main, instances);
		VariableSpecification instances_spec = new VariableSpecification(pvl_system, func.getCorrClass(),
				instance_in_main);

		LinkedList<Specification> context_specs = new LinkedList<Specification>();
		PermissionSpecification m_access = new PermissionSpecification(func.getCorrClass(), pvl_system, main_spec,
				0.5f);
		context_specs.add(m_access);
		context_specs.add(notNullSpecification(func.getCorrClass(), main));
		if (!func.getName().equals("run")) {
			HeldSpecification heldM = new HeldSpecification(func.getCorrClass(), pvl_system, main_spec);
			context_specs.add(heldM);
			if (func.getCorrClass().getGenerating_instance() instanceof SCKnownType) {
				ResourceCallSpecification inst_call = new ResourceCallSpecification(func.getCorrClass(), pvl_system,
						main_spec, func.getCorrClass().getGenerating_instance().getName() + "_permission_invariant");
				ResourceCallSpecification scheduler = new ResourceCallSpecification(func.getCorrClass(), pvl_system,
						main_spec, "scheduler_permission_invariant");
				context_specs.add(scheduler);
				context_specs.add(inst_call);
			}
			else {
				ResourceCallSpecification globalCall = new ResourceCallSpecification(func.getCorrClass(), pvl_system,
						main_spec, "global_permission_invariant");
				context_specs.add(globalCall);
			}
		}
		else {
			PermissionSpecification instances_access = new PermissionSpecification(func.getCorrClass(), pvl_system,
					instances_spec, 0.5f);
			context_specs.add(instances_access);
		}
		BinarySpecification ident_check = new BinarySpecification(func.getCorrClass(), pvl_system, instances_spec,
				new ConstantSpecification(func.getCorrClass(), pvl_system, "this"), "==");
		context_specs.add(ident_check);

		if(!func.getCorrClass().isRunnable() && func.isWaiting()) {
			//if not runnable and waiting we need to add info about parameter process_id
			//requires 0 <= process_id && process_id < |m.ready|;
			PVLVariable process_id = func.getParameters().get(func.getParameters().size() - 1);
			VariableSpecification process_spec = new VariableSpecification(pvl_system, func.getCorrClass(), process_id);
			BinarySpecification processgeqzero = new BinarySpecification(func.getCorrClass(), pvl_system,
					new ConstantSpecification(func.getCorrClass(), pvl_system, "0"), process_spec, "<=");
			PVLNestedVariable process_in_main = new PVLNestedVariable(main, ((PVLMainClass) pvl_system.getClassByName("Main")).getProcessState());
			BinarySpecification sizecheck = new BinarySpecification(func.getCorrClass(), pvl_system, process_spec,
					new ConstantSpecification(func.getCorrClass(), pvl_system,
							"|" + process_in_main.toStringNoType() + "|"),
					"<");
			BinarySpecification bothcomp = new BinarySpecification(func.getCorrClass(), pvl_system, processgeqzero, sizecheck, "&&");	

			RequiresSpecification req = new RequiresSpecification(func.getCorrClass(), pvl_system, bothcomp);

			func.prependSpecification(req);
		}

		SpecificationBlock context_block = new SpecificationBlock(context_specs, func.getCorrClass(), pvl_system);
		ContextSpecification context = new ContextSpecification(func.getCorrClass(), pvl_system, context_block);
		func.prependSpecification(context);
	}

	private void createGlobalInvariant(PVLMainClass main) {
		LinkedList<Specification> global_specs = new LinkedList<Specification>();
		
		LinkedList<Specification> specs = new LinkedList<Specification>();

		// all variable specifications
		// for all sequences: add write permission and check size
		LinkedList<Specification> scheduler_specs = new LinkedList<Specification>();
		for (PVLSequenceVariable field : main.getAllNotClassSequenceFields()) {
			VariableSpecification field_var = new VariableSpecification(pvl_system, main, field);
			PermissionSpecification field_write = new PermissionSpecification(main, pvl_system, field_var, 1);
			scheduler_specs.add(field_write);
			int size_delay = ((PVLSequenceDeclarationExpression) field.getDeclaration())
					.getValues().size();
			ConstantSpecification size_vals = new ConstantSpecification(main, pvl_system,
					"|" + field.getName() + "| == " + size_delay);
			scheduler_specs.add(size_vals);
		}
		PVLSequenceVariable process_state_seq = main.getProcessState();
		PVLSequenceVariable event_state_seq = main.getEventState();

		// Add \forall construct to make sure process states are in range
		PVLSizeExpression procs = new PVLSizeExpression(null, new PVLVariableExpression(null, process_state_seq, main));
		PVLVariable i_var = new PVLVariable("i", "int", main);
		ConstantExpression i_init = new ConstantExpression(null, "0 .. " + procs.toStringNoSem() + ";");
		PVLVariableDeclarationExpression i_var_decl_expr = new PVLVariableDeclarationExpression(null, i_var, i_init);
		LinkedList<Specification> access = new LinkedList<Specification>();
		access.add(new VariableSpecification(pvl_system, main, i_var));
		SequenceAccessSpecification waiting_on_i = new SequenceAccessSpecification(pvl_system, main, process_state_seq,
				access);
		BinarySpecification smaller_zero = new BinarySpecification(main, pvl_system, new TriggerSpecification(main, pvl_system, waiting_on_i),
				new ConstantSpecification(main, pvl_system, "-1"), "==");
		BinarySpecification greater_equal_zero = new BinarySpecification(main, pvl_system, waiting_on_i,
				new ConstantSpecification(main, pvl_system, "0"), ">=");
		BinarySpecification smaller_delays = new BinarySpecification(main, pvl_system, waiting_on_i,
				new ConstantSpecification(main, pvl_system, "|" + event_state_seq.getName() + "|"), "<");
		// greater_equal_zero && smaller_delays
		BinarySpecification great_and_small = new BinarySpecification(main, pvl_system, greater_equal_zero,
				smaller_delays, "&&");
		LinkedList<Specification> all_specs = new LinkedList<>(List.of(smaller_zero, great_and_small));
		MultiConditionSpecification all_conds = new MultiConditionSpecification(main, pvl_system, all_specs, "||");
		scheduler_specs.add(new ForAllSpecification(main, pvl_system, i_var_decl_expr, null, all_conds));
		
		SpecificationBlock global_spec_block = new SpecificationBlock(scheduler_specs, main, pvl_system);
		InlineResourceSpecification scheduler_invariant = new InlineResourceSpecification("scheduler_permission_invariant",
				global_spec_block, main, pvl_system);
		specs.add(scheduler_invariant);
		
		global_specs.add(new ConstantSpecification(main, pvl_system, "scheduler_permission_invariant()"));

		// Add individual permissions for each known type
		LinkedList<Specification> prim_specs;
		SpecificationBlock prim_spec_block;
		InlineResourceSpecification prim_spec_invariant;
		for (PVLClassInstance inst : main.getAllClassInstanceFields()) {
			if (inst.getCorrClass().getGenerating_instance() instanceof SCKnownType) {
				SCClassInstance known_type_inst = inst.getCorrClass().getGenerating_instance();
				prim_specs = switch (known_type_inst.getSCClass().getName()) {
					case "sc_fifo_int", "sc_fifo_bool" -> generateFIFOInvariant(inst, main);
					default ->
							throw new IllegalArgumentException("Unsupported known type " + known_type_inst.getSCClass().getName() + "!");
				};
				
				prim_spec_block = new SpecificationBlock(prim_specs, main, pvl_system);
				prim_spec_invariant = new InlineResourceSpecification(known_type_inst.getName() + "_permission_invariant",
						prim_spec_block, main, pvl_system);
				specs.add(prim_spec_invariant);
				
				global_specs.add(new ConstantSpecification(main, pvl_system, known_type_inst.getName() + "_permission_invariant()"));
			}
		}
		
		global_specs.addAll(createAllFieldInvariants(main));
		// add parameter value check for each declared instance
		List<PVLClassInstance> all_instances = main.getConstructors().get(0).getInstantiated();
		for (PVLClassInstance ins : all_instances) {
			if (!(ins.getCorrClass().getGenerating_instance() instanceof SCKnownType)) {
				if (!ins.isRunnable()) {
					PVLVariable mainvar = ins.getInstanceType().getMainRef();
					PVLNestedVariable mainref = new PVLNestedVariable(ins, mainvar);
					VariableSpecification mainref_spec = new VariableSpecification(pvl_system, main, mainref);
					PermissionSpecification mainref_read = new PermissionSpecification(main, pvl_system, mainref_spec, 0.5f);
					global_specs.add(mainref_read);
					ConstantSpecification this_spec = new ConstantSpecification(main, pvl_system, "this");
					BinarySpecification ref_this_spec = new BinarySpecification(main, pvl_system, mainref_spec, this_spec, "==");
					global_specs.add(ref_this_spec);
				}
			}
		}
		global_spec_block = new SpecificationBlock(global_specs, main, pvl_system);
		InlineResourceSpecification global_perm_invariant = new InlineResourceSpecification("global_permission_invariant",
				global_spec_block, main, pvl_system);
		specs.add(global_perm_invariant);

		//create resource lock_invariant() = global_invariant();
		ResourceSpecification lock_invariant = new ResourceSpecification("lock_invariant", new ConstantSpecification(main, pvl_system, "global_permission_invariant()"), main, pvl_system);
		specs.add(lock_invariant);
		main.setSpecifications(specs);
	}

	private LinkedList<Specification> generateFIFOInvariant(PVLClassInstance inst, PVLMainClass corr_class) {
		LinkedList<Specification> res = new LinkedList<Specification>();
		
		// Permission to the FIFO itself
		VariableSpecification var_spec = new VariableSpecification(pvl_system, corr_class, inst);
		res.add(new PermissionSpecification(corr_class, pvl_system, var_spec, 0.5f));
		// FIFO != null
		res.add(notNullSpecification(corr_class, inst));
		
		PVLClass fifo_cls = inst.getCorrClass();
		for (PVLVariable field : fifo_cls.getFields()) {
			PVLNestedVariable nested_var = new PVLNestedVariable(inst, field);
			var_spec = new VariableSpecification(pvl_system, corr_class, nested_var);
			if (field instanceof PVLSequenceVariable) {
				// FIFO buffer
				res.add(new PermissionSpecification(corr_class, pvl_system, var_spec, 1.0f));
				res.add(new SizeSpecification(corr_class,
											  pvl_system,
											  new PVLSizeExpression(null, new PVLVariableExpression(null, nested_var, corr_class)),
											  "<",
											  new ConstantExpression(null, "16")));
			}
			else {
				// read permission to all other variables
				res.add(new PermissionSpecification(corr_class, pvl_system, var_spec, 0.5f));
			}
			
			// If the field is the main reference, add a check that it is equal to "this"
			if (field.equals(fifo_cls.getMainRef())) {
				ConstantSpecification this_spec = new ConstantSpecification(corr_class, pvl_system, "this");
				res.add(new BinarySpecification(corr_class, pvl_system, var_spec, this_spec, "=="));
			}
		}
		
		return res;
	}

	private void createConstructorSpecification(PVLConstructor cons) {
		LinkedList<Specification> specs = new LinkedList<Specification>();
		for (PVLVariable var : pvl_system.getClassByName(cons.getName()).getFields()) {
			PermissionSpecification perm_spec = new PermissionSpecification(pvl_system.getClassByName(cons.getName()),
					pvl_system, new VariableSpecification(pvl_system, pvl_system.getClassByName(cons.getName()), var),
					1);
			specs.add(perm_spec);
		}
		/*for (Pair<PVLVariable, PVLVariable> p : cons.getInitaliziations()) {
			VariableSpecification field = new VariableSpecification(pvl_system,
					pvl_system.getClassByName(cons.getName()), p.getFirst());
			VariableSpecification param = new VariableSpecification(pvl_system,
					pvl_system.getClassByName(cons.getName()), p.getSecond());
			BinarySpecification init_check = new BinarySpecification(pvl_system.getClassByName(cons.getName()),
					pvl_system, field, param, "==");
			specs.add(init_check);
		}*/

		for(Expression exp : cons.getBody()) {
			if(exp instanceof BinaryExpression) {
				if(((BinaryExpression) exp).getLeft() instanceof PVLVariableExpression left) {
					if(((BinaryExpression) exp).getRight() instanceof PVLVariableExpression right) {
						VariableSpecification field = new VariableSpecification(pvl_system,
								pvl_system.getClassByName(cons.getName()), left.getVar());
						VariableSpecification param = new VariableSpecification(pvl_system,
								pvl_system.getClassByName(cons.getName()), right.getVar());
						BinarySpecification init_check = new BinarySpecification(pvl_system.getClassByName(cons.getName()),
								pvl_system, field, param, "==");
						specs.add(init_check);
					}
					if(((BinaryExpression) exp).getRight() instanceof ConstantExpression) {
						ConstantSpecification param = new ConstantSpecification(pvl_system.getClassByName(cons.getName()),
								pvl_system, ((ConstantExpression) ((BinaryExpression) exp).getRight()).getValue());
						VariableSpecification field = new VariableSpecification(pvl_system,
								pvl_system.getClassByName(cons.getName()), left.getVar());
						BinarySpecification init_check = new BinarySpecification(pvl_system.getClassByName(cons.getName()),
								pvl_system, field, param, "==");
						specs.add(init_check);
					}
				}
			}
			if(exp instanceof PVLArrayExpression) {
				//** \array(buffer, BUFFERSIZE)
				//** Perm(buffer[*], write);
				PVLArray array = (PVLArray) ((PVLArrayExpression) exp).getVariable();
				String size;
				if (array.getSize() instanceof ConstantExpression) {
					size = ((ConstantExpression) array.getSize()).getValue();
				}
				else {
					size = ((PVLVariableExpression) array.getSize()).getVar().getName();
				}
				//for now: assume size if of type ConstantExpression
				ConstantSpecification arrayspec = new ConstantSpecification(pvl_system.getClassByName(cons.getName()), pvl_system, "\\array("+array.getName()+","+ size+")");
				specs.add(arrayspec);
				ConstantSpecification sizewrite = new ConstantSpecification(pvl_system.getClassByName(cons.getName()), pvl_system, "Perm("+array.getName()+"[*], write)");
				specs.add(sizewrite);

			}
		}


		EnsuresSpecification ensure_spec = new EnsuresSpecification(pvl_system.getClassByName(cons.getName()),
				pvl_system, new SpecificationBlock(specs, pvl_system.getClassByName(cons.getName()), pvl_system));
		LinkedList<Specification> specification = new LinkedList<Specification>();
		specification.add(ensure_spec);
		cons.setSpecifications(specification);
	}

	private void createLoopSpecification(PVLLoopExpression loop) {
		/*
		 * creates: loop_invariant true Perm(m, 1\2) m != null held(m)
		 ** m.global_invariant() Perm(instance_id, read) (0 <= instance_id && instance_id
		 * < |m.consumer_instances|) m.consumer_instances[instance_id] == this;
		 */
		// get variable references
		PVLClass corrClass = loop.getCorrClass();
		PVLVariable main = corrClass.getMainRef();
		VariableSpecification main_spec = new VariableSpecification(pvl_system, corrClass, main);
		PVLVariable instance = ((PVLMainClass) pvl_system.getClassByName("Main"))
				.getFieldByType(corrClass.getName());
		PVLNestedVariable instance_in_main = new PVLNestedVariable(main, instance);
		VariableSpecification instances_spec = new VariableSpecification(pvl_system, corrClass, instance_in_main);

		LinkedList<Specification> context_specs = new LinkedList<Specification>();
		ConstantSpecification trueSpec = new ConstantSpecification(null, pvl_system, "true");
		context_specs.add(trueSpec);
		PermissionSpecification m_access = new PermissionSpecification(corrClass, pvl_system, main_spec, 0.5f);
		context_specs.add(m_access);
		context_specs.add(notNullSpecification(corrClass, main));
		HeldSpecification heldM = new HeldSpecification(corrClass, pvl_system, main_spec);
		context_specs.add(heldM);
		ResourceCallSpecification globalCall = new ResourceCallSpecification(corrClass, pvl_system, main_spec,
				"global_permission_invariant");
		context_specs.add(globalCall);
		BinarySpecification ident_check = new BinarySpecification(corrClass, pvl_system, instances_spec,
				new ConstantSpecification(corrClass, pvl_system, "this"), "==");
		context_specs.add(ident_check);
		if (loop.getPathCondition().size() > 0) {
			context_specs.add(new MultiSpecification(corrClass, pvl_system, loop.getPathCondition(), "&&"));
		}

		LoopInvariantSpecification loopInvariant = new LoopInvariantSpecification(corrClass, pvl_system, context_specs);
		LinkedList<Specification> specification = new LinkedList<Specification>();
		specification.add(loopInvariant);
		loop.setSpecifications(specification);
	}

	public LinkedList<Specification> createAllFieldInvariants(PVLClass corr_class) {
		LinkedList<Specification> spec = new LinkedList<Specification>();
		for (PVLVariable var : corr_class.getFields()) {
			if (!(   var instanceof PVLClassInstance
				  && ((PVLClassInstance) var).getCorrClass().getGenerating_instance() instanceof SCKnownType)) {
				if (!(var instanceof PVLSequenceVariable)) {
					VariableSpecification var_spec = new VariableSpecification(pvl_system, corr_class, var);
					spec.add(new PermissionSpecification(corr_class, pvl_system, var_spec, 0.5f));
					if (!(var.getType().equals("int") | var.getType().equals("boolean")))
						spec.addAll(recursiveCreateSequenceFieldInvariant(corr_class, var));
				}
			}
		}
		return spec;
	}

	private Specification notNullSpecification(PVLClass corr_class, PVLVariable var) {
		VariableSpecification var_spec = new VariableSpecification(pvl_system, corr_class, var);
		return new BinarySpecification(corr_class, pvl_system, var_spec,
				new ConstantSpecification(corr_class, pvl_system, "null"), "!=");
	}

	private LinkedList<Specification> recursiveCreateFieldInvariant(PVLClass corr_class, PVLVariable var) {
		if (var.getType().equals("Main"))
			return new LinkedList<Specification>();
		LinkedList<Specification> spec = new LinkedList<Specification>();
		VariableSpecification var_spec = new VariableSpecification(pvl_system, corr_class, var);
		PermissionSpecification perm_spec = new PermissionSpecification(corr_class, pvl_system, var_spec, 1.0f);
		spec.add(perm_spec);
		if (var instanceof PVLArray) {
			Expression array_size = ((PVLArray) var).getSize();
			spec.add(new ArraySpecification(corr_class, pvl_system, (PVLArray) var, array_size));
			spec.add(new ArrayPermSpecification(corr_class, pvl_system, (PVLArray) var, "write"));
		}
		else if (var instanceof PVLNestedVariable && ((PVLNestedVariable) var).getInnerVar() instanceof PVLArray array_var) {
			Expression array_size = array_var.getSize();
			spec.add(new ArraySpecification(corr_class, pvl_system, var, array_size));
			spec.add(new ArrayPermSpecification(corr_class, pvl_system, var, "write"));
		}
		
		/*if (!(var.getType().equals("int") | var.getType().equals("boolean"))) {
			// get all fields
				LinkedList<PVLVariable> class_fields = (LinkedList<PVLVariable>) pvl_system.getClassByName(var.getType())
					.getFields();
			if (class_fields.size() > 0) {
				//currently no recursive field access used -> might need it later when hierarchy is allowed
			spec.add(notNullSpecification(corr_class, var));

					for (PVLVariable class_field : class_fields) {
						PVLNestedVariable nested_field = new PVLNestedVariable(var, class_field);
						spec.addAll(recursiveCreateFieldInvariant(corr_class, nested_field));
				}
			}
		}*/
		return spec;
	}

	private LinkedList<Specification> recursiveCreateSequenceFieldInvariant(PVLClass corr_class, PVLVariable var) {
		if (var.getType().equals("Main"))
			return new LinkedList<Specification>();
		LinkedList<Specification> spec = new LinkedList<Specification>();
		// read permission
		//PermissionSpecification perm_spec = new PermissionSpecification(corr_class, pvl_system, var_i_spec, 1);
		//spec.add(perm_spec);
		if (!(var.getType().equals("int") | var.getType().equals("boolean"))) {
			// get all fields
			LinkedList<PVLVariable> class_fields = (LinkedList<PVLVariable>) pvl_system
					.getClassByName(var.getType()).getFields();
			if (class_fields.size() > 0) {
				spec.add(notNullSpecification(corr_class, var));
				for (PVLVariable class_field : class_fields) {
					PVLNestedVariable nested_field = new PVLNestedVariable(var, class_field);
					spec.addAll(recursiveCreateFieldInvariant(corr_class, nested_field));
				}
			}
		}
		return spec;
	}

	public PVLSystem getPVLSystem() {
		return pvl_system;
	}

	public void setPVLSystem(PVLSystem pvl_system) {
		this.pvl_system = pvl_system;
	}

}
