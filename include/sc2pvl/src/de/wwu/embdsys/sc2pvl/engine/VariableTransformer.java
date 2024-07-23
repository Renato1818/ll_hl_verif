package de.wwu.embdsys.sc2pvl.engine;

import java.util.LinkedList;
import java.util.Map;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.variables.SCArray;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLArray;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;
import de.wwu.embdsys.sc2pvl.pvlmodel.expressions.PVLVariableDeclarationExpression;

/**
 * VariableTransformer class provides methods to convert systemC parameters and variables into PVL variables.
 * @author Pauline Blohm 
 *
 */
public class VariableTransformer {

	private final PVLSystem pvl_system;
	private final PVLClass pvl_class;
	
	public VariableTransformer(PVLSystem pvl_system, PVLClass pvl_class) {
		this.pvl_system = pvl_system;
		this.pvl_class = pvl_class;
	}
	
	
	
	/**
	 * Transforms a SCParameter into a PVLVariable.
	 * Only the name and type of the SCVariable corresponding to the SCParameter will be preserved.
	 * 
	 * @param par the systemC parameter to transform
	 * @return PVLVariable with the name and type of the SCVariable of the SCParameter
	 */
	public PVLVariable createVariable(SCParameter par) {
		//TODO: is this enough? can we ignore reference type, etc.?
		SCVariable scvar = par.getVar();
		return createVariable(scvar);
	}
	
	/**
	 * Transforms a SCVariable into a PVLVariable.
	 * Only the name and type of the SCVariable will be preserved.
	 * 
	 * @param par the systemC variable to transform
	 * @return PVLVariable with the name and type of the SCVariable of the SCParameter
	 */
	public PVLVariable createVariable(SCVariable par) {
		Map<Pair<SCVariable, PVLClass>, PVLVariable> variables = pvl_system.getVariables();
		Pair<SCVariable, PVLClass> key = new Pair<SCVariable, PVLClass>(par, pvl_class);
		//Pair<SCVariable, PVLClass> state_key = new Pair<SCVariable, PVLClass>(par, pvl_class.getCorrStateClass());
		if(variables.containsKey(key)) {
			return variables.get(key);
		}
		/*else if (pvl_class.getCorrStateClass() != null && variables.containsKey(state_key)) {
			return variables.get(state_key);
		}*/
		else {
			String type = par.getType().equals("bool") ? "boolean" : par.getType();
			if(par instanceof SCArray) {
				PVLArray pvl_var = new PVLArray(par.getName(), type ,pvl_class);
				pvl_var.setSCVariable(par);
				ExpressionTransformer exptrans = new ExpressionTransformer(pvl_system, pvl_class);
				pvl_var.setSize(exptrans.createExpression(((SCArray) par).getSize(), new LinkedList<PVLVariable>(), new LinkedList<Expression>()).get(0));
				variables.put(key, pvl_var);
				return pvl_var;
			}
			else {
				PVLVariable pvl_var = new PVLVariable(par.getName(), type ,pvl_class);
				pvl_var.setSCVariable(par);
				variables.put(key, pvl_var);
				return pvl_var;
			}
		}
		
	}
	
	/**
	 * Transforms a SCVariable into a PVLVariable with a known declaration.
	 * Only the name and type of the SCVariable will be preserved.
	 * 
	 * @param par the systemC variable to transform
	 * @return PVLVariable with the name and type of the SCVariable of the SCParameter
	 */
	public PVLVariable createVariable(SCVariable par, PVLVariableDeclarationExpression exp) {
		PVLVariable var = createVariable(par);
		var.setDeclaration(exp);
		return var;
	}
}
