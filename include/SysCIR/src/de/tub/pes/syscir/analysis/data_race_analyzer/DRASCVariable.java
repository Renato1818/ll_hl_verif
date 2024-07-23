/*****************************************************************************
 *
 * Copyright (c) 2008-17, Joachim Fellmuth, Holger Gross, Florian Greiner, 
 * Bettina Hünnemeyer, Paula Herber, Verena Klös, Timm Liebrenz, 
 * Tobias Pfeffer, Marcel Pockrandt, Rolf Schröder, Björn Beckmann
 * Simon Schwan
 * Technische Universitaet Berlin, Software and Embedded Systems
 * Engineering Group, Ernst-Reuter-Platz 7, 10587 Berlin, Germany.
 * All rights reserved.
 * 
 * This file is part of STATE (SystemC to Timed Automata Transformation Engine).
 * 
 * STATE is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 * 
 * STATE is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with STATE.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 *  Please report any problems or bugs to: state@pes.tu-berlin.de
 *
 ****************************************************************************/

package de.tub.pes.syscir.analysis.data_race_analyzer;

import java.util.List;

import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;

/**
 * 
 * @author Björn Beckmann
 *
 */
public class DRASCVariable extends DRASCData{
	
	private SCVariable variable;
	
	private boolean symmWritePossible;
	
	private boolean hasValueVariable;
	
	private SCVariable valueVariable;
		
	public DRASCVariable(AtomicBlock atomicBlock, SCClassInstance classInstance) {
		super(atomicBlock, classInstance);
		setHasValueVariable(false);
		setSymmWritePossible(true);
	}

	public DRASCVariable(AtomicBlock atomicBlock, SCClassInstance classInstance, boolean hasParent, List<SCVariable> parents) {
		super(atomicBlock, classInstance, hasParent, parents);
		setHasValueVariable(false);
		setSymmWritePossible(true);
	}

	public SCVariable getVariable() {
		return variable;
	}

	public void setVariable(SCVariable variable) {
		this.variable = variable;
	}

	public void checkValueExpression(Expression valueExpression){
		
		if(isSymmWritePossible()){
		
			if(valueExpression instanceof SCVariableExpression){
			
				SCVariable scVariable = ((SCVariableExpression) valueExpression).getVar();
				
				if(hasValueVariable()){
					
					if(getVariable()==scVariable){
						return;
					}
					
				}else{
					setValueVariable(scVariable);
					setHasValueVariable(true);
					return;
					
				}
				
			}
			
			setSymmWritePossible(false);
			
		}
	}
	
	public SCVariable getValueVariable() {
		return valueVariable;
	}
	
	public void setValueVariable(SCVariable valueVariable) {
		this.valueVariable = valueVariable;
	}

	public boolean hasValueVariable() {
		return hasValueVariable;
	}

	public void setHasValueVariable(boolean hasValueVariable) {
		this.hasValueVariable = hasValueVariable;
	}

	public boolean isSymmWritePossible() {
		return symmWritePossible;
	}

	public void setSymmWritePossible(boolean symmWritePossible) {
		if(!symmWritePossible){
			setValueVariable(null);
			setHasValueVariable(false);
		}
		this.symmWritePossible = symmWritePossible;
	}
	
}
