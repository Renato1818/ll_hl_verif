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

import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCEvent;

/**
 * 
 * @author Björn Beckmann
 *
 */
public class AtomicBlockDependency {

	/**
	 * 	returns true if blockA and blockB have data races
	 * 
	 */
	public static boolean dependency(AtomicBlock blockA, AtomicBlock blockB){
		
		//same Block
		if(blockA==blockB){ 
			return false;
		}

		// Atomic Blocks which are part of the same process and the same class instance can not be dependent
		// those atomic blocks will never be both available at the same simulation time
		if( blockA.getTopLevelClassInstance()  == blockB.getTopLevelClassInstance() ){
			if(blockA.getProcess() == blockB.getProcess()){
				return false;
			}
		}
		
		if(variable_dependency(blockA,blockB)){
			return true;
		}

		if(variable_dependency(blockB,blockA)){
			return true;
		}

		return false;
		
	}
	
	private static boolean variable_dependency(AtomicBlock blockA, AtomicBlock blockB){
	
		for(DRASCVariable varA : blockA.getGlobalVariableWrite()){
			
			//Write/Write
			if(blockB.draSCVariableListContains(blockB.getGlobalVariableWrite(), varA.getVariable())){
				DRASCVariable varB = blockB.getDRASCVariable(blockB.getGlobalVariableWrite(), varA.getVariable());
				
				
				if(		
						// global variables of different class instances can not have data races
						varA.getClassInstance() == varB.getClassInstance() &&
						(
								!
								// symmetrical write
								(writeSameValue(varA,varB)
								||
								//conditions are mutually exclusive
								compareConditionList(varA, varB)
								)
						)
				){
					return true;
				}
			}
			
			//Write/Read
			if(blockB.draSCVariableListContains(blockB.getGlobalVariableRead(), varA.getVariable())){
				DRASCVariable varB = blockB.getDRASCVariable(blockB.getGlobalVariableRead(), varA.getVariable());
				if(		
						// global variables of different class instances can not have data races
						varA.getClassInstance() == varB.getClassInstance() &&
						(
								//conditions are mutually exclusive
								!compareConditionList(varA, varB)
						)
				){
					return true;
				}
			}

			if(varA.isHasParent()){
				for(int i=0; i<varA.getParents().size(); i++){
					//Write/Write
					if(blockB.draSCVariableListContains(blockB.getGlobalVariableWrite(), varA.getParents().get(i))){
						DRASCVariable varB = blockB.getDRASCVariable(blockB.getGlobalVariableWrite(), varA.getParents().get(i));
						
						
						if(		// global variables of different class instances can not have data races
								varA.getClassInstance() == varB.getClassInstance() &&
								(		
										!
										// symmetrical write
										(writeSameValue(varA,varB)
										||
										//conditions are mutually exclusive
										compareConditionList(varA, varB)
										)
								)
						){
							return true;
						}
					}

				}
			}
			
		}
		
		return false;
	}
	
	public static boolean immediateNotification_dependency(AtomicBlock blockA, AtomicBlock blockB, List<AtomicBlock> atomicBlocks){
		
		if(check_immediateNotification_dependency(blockA,blockB,atomicBlocks)){
			return true;
		}
		if(check_immediateNotification_dependency(blockB,blockA,atomicBlocks)){
			return true;
		}
		return false;
	}
	
	public static boolean check_immediateNotification_dependency(AtomicBlock blockA, AtomicBlock blockB, List<AtomicBlock> atomicBlocks){
		
		// A kann B auslösen
		for(DRASCEvent eventA : blockA.getNotifySCEvent()){
			
			if(blockB.draSCEventListContains(blockB.getWaitSCEvent(), eventA.getEvent())){
				DRASCEvent eventB = blockB.getDRASCEvent(blockB.getWaitSCEvent(), eventA.getEvent());
				
				if(		// global variables of different class instances can not have data races
						eventA.getClassInstance() == eventB.getClassInstance() 
						//|| !compareConditionList(eventA, eventB)
				){
					return true;
				}
				
				
			}
			
		}
		
		//A kann einen Atomic Block auslösen, der Data Races mit B hat
		// -> A und B sind unabhängig
		for(DRASCEvent eventA : blockA.getNotifySCEvent()){
			
			for(AtomicBlock aB : atomicBlocks){
				
				if(aB == blockA || aB == blockB){
					continue;
				}
				
				if(aB.getExpression()!=null){
					FunctionCallExpression expression = (FunctionCallExpression) aB.getExpression();
					SCFunction function =  expression.getFunction();

					for(SCParameter parameter : function.getParameters()){
						if(parameter.getVar() instanceof SCEvent){
							// AtomicBlock aB, der durch AtomicBlock A ausgelöst werden kann
							if(eventA.getEvent()==(SCEvent) parameter.getVar()
								&& 
								eventA.getClassInstance() == aB.getWaitLevelClassInstance()
								&&
								// AtomicBlock aB löst weitere Events aus
								// oder AtomicBlock ist mit blockB abhängig
								(aB.getNotifySCEvent().size()>0 || dependency(blockB, aB) )
									){
									return true;
							}
							
						}
					}
				
				}
			
			}
			
		}
		
		return false;
	}
	
	private static boolean writeSameValue(DRASCVariable varA, DRASCVariable varB) {
		
		if(varA.getClassInstance()==varB.getClassInstance()
				&& varA.hasValueVariable()
				&& varB.hasValueVariable()
				&& varA.getValueVariable().isConst()
				&& varB.getValueVariable().isConst()
				&& varA.getValueVariable() == varB.getValueVariable() ){
			return true;
		}else{
			return false;
		}
	}

	public static boolean compareConditionList(DRASCData varA, DRASCData varB){

		// mutual exclusion e.g. b <= 3 - b > 3
		if(varA.getConditionList().size()==1 && varB.getConditionList().size()==1){
			
			Expression expressionA = varA.getConditionList().get(0);
			Expression expressionB = varB.getConditionList().get(0);
				
				if(expressionA instanceof BinaryExpression && expressionB instanceof BinaryExpression){

					Expression leftA = ((BinaryExpression) expressionA).getLeft();
					Expression rightA = ((BinaryExpression) expressionA).getRight();
					String opA = ((BinaryExpression) expressionA).getOp();

					Expression leftB = ((BinaryExpression) expressionB).getLeft();
					Expression rightB = ((BinaryExpression) expressionB).getRight();
					String opB = ((BinaryExpression) expressionB).getOp();
					
					if(leftA instanceof SCVariableExpression && leftB instanceof SCVariableExpression){
						SCVariable scVariableA = ((SCVariableExpression) leftA).getVar();
						SCVariable scVariableB = ((SCVariableExpression) leftB).getVar();
						
						if(scVariableA == scVariableB){
							
							if(rightA instanceof ConstantExpression && rightB instanceof ConstantExpression){
								String valueA = ((ConstantExpression) rightA).getValue();
								String valueB = ((ConstantExpression) rightB).getValue();

									if(valueA.equals(valueB)){

										if( (opA.equals("<") && opB.equals(">="))
											||
											(opA.equals("<=") && opB.equals(">"))
											||
											(opA.equals(">") && opB.equals("<="))
											||
											(opA.equals(">=") && opB.equals("<"))
										){
											if(!varA.getEditList().contains(scVariableA) && 
													!varB.getEditList().contains(scVariableB) ){
												return true;
											}
										}

										
									}
								
							}

						}

					}
					
				}
				
			}
		
		
		return false;
	}

	
}
