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

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCConnectionInterface;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCPortInstance;
import de.tub.pes.syscir.sc_model.SCREFERENCETYPE;
import de.tub.pes.syscir.sc_model.SCSocketInstance;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.ArrayAccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.RefDerefExpression;
import de.tub.pes.syscir.sc_model.expressions.SCPortSCSocketExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.SwitchExpression;
import de.tub.pes.syscir.sc_model.expressions.UnaryExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;
import de.tub.pes.syscir.sc_model.variables.SCPointer;

/**
 * 
 * @author Björn Beckmann
 *
 */
public class DRAPointerExpressionHandler implements DRAExpressionHandler{
	
	DataRaceAnalyzer dra;
	
	public DRAPointerExpressionHandler(DataRaceAnalyzer dra){
		this.dra = dra;
	}
	
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> thenExpression = ((IfElseExpression) expression).getThenBlock() ;
		List<Expression> elseExpression = ((IfElseExpression) expression).getElseBlock() ;
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add(expression.getCondition());
		
		dra.traverseCFGandAnalysePointer(conditionList, currentClassInstance);

		dra.traverseCFGandAnalysePointer(thenExpression, currentClassInstance);
		dra.traverseCFGandAnalysePointer(elseExpression, currentClassInstance);
		
	}

	@Override
	public void loopExpressionHandler(LoopExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add( ((LoopExpression) expression).getCondition());
		
		dra.traverseCFGandAnalysePointer(conditionList, currentClassInstance);
		
		dra.traverseCFGandAnalysePointer(((LoopExpression) expression).getLoopBody(), currentClassInstance);
		
	}

	@Override
	public void portCallHandler(SCFunction scfunction, SCKnownType knownType,
			SCClassInstance currentClassInstance) {
		
	}

	@Override
	public void portCallHandler(SCFunction scfunction,
			SCClassInstance classInstancePort,
			SCClassInstance currentClassInstance) {
		
	}

	public void checkPointerConnectionExpression(Expression leftExpression, SCClassInstance leftInstance, Expression rightExpression, SCClassInstance rightInstance){
		
		// e.g.: int *x, *y;
		// x = y;
		
		if(leftExpression instanceof SCVariableExpression && rightExpression instanceof SCVariableExpression){

			SCVariable varLeft = ((SCVariableExpression) leftExpression).getVar();
			SCVariable varRight = ((SCVariableExpression) rightExpression).getVar();

			if(varLeft instanceof SCPointer && varRight instanceof SCPointer){
				
				checkPointerConnection(varLeft,leftInstance,varRight,rightInstance);
				return;

			}
			
		}
		
		// e.g.: int *x;
		//			int y;
		// x = &y;
		
		if(leftExpression instanceof SCVariableExpression && rightExpression instanceof RefDerefExpression){

			SCVariable varLeft = ((SCVariableExpression) leftExpression).getVar();

			RefDerefExpression refDerefExpression = (RefDerefExpression) rightExpression;
			Expression refDerefInnerExpression = refDerefExpression.getExpression();
			if(refDerefExpression.isReferencing() && refDerefInnerExpression instanceof SCVariableExpression){
				SCVariable varRight = ((SCVariableExpression) refDerefInnerExpression).getVar();

				if(varLeft instanceof SCPointer){
					
					checkPointerConnection(varLeft,leftInstance,varRight,rightInstance);
					return;
				}
			}
			
		}

		// e.g.: int *x;
		//			int y;
		// &y = x;
		
		if(leftExpression instanceof RefDerefExpression && rightExpression instanceof SCVariableExpression){

			SCVariable varRight = ((SCVariableExpression) rightExpression).getVar();

			RefDerefExpression refDerefExpression = (RefDerefExpression) leftExpression;
			Expression refDerefInnerExpression = refDerefExpression.getExpression();
			if(refDerefExpression.isReferencing() && refDerefInnerExpression instanceof SCVariableExpression){
				SCVariable varLeft = ((SCVariableExpression) refDerefInnerExpression).getVar();

				if(varRight instanceof SCPointer){
					
					checkPointerConnection(varLeft,leftInstance,varRight,rightInstance);
					return;
					
				}
			}
			
		}

		// e.g.: int x,y; 
		// &y = &x;
		
		if(leftExpression instanceof RefDerefExpression && rightExpression instanceof RefDerefExpression){

			RefDerefExpression refDerefExpression = (RefDerefExpression) leftExpression;
			Expression refDerefInnerExpression = refDerefExpression.getExpression();

			if(refDerefExpression.isReferencing() && refDerefInnerExpression instanceof SCVariableExpression){
				SCVariable varLeft = ((SCVariableExpression) refDerefInnerExpression).getVar();

				RefDerefExpression refDerefExpressionRight = (RefDerefExpression) rightExpression;
				Expression refDerefInnerExpressionRight = refDerefExpressionRight.getExpression();

				if(refDerefExpressionRight.isReferencing() && refDerefInnerExpressionRight instanceof SCVariableExpression){
					SCVariable varRight = ((SCVariableExpression) refDerefInnerExpressionRight).getVar();
					
					checkPointerConnection(varLeft,leftInstance,varRight,rightInstance);
					return;
					
				}
			}
			
		}
		
	}
	
	@Override
	public void binaryExpressionHandler(BinaryExpression expression,
			SCClassInstance currentClassInstance) {
		
		//Check Pointer
		
		Expression left = expression.getLeft();
		String op = expression.getOp();
		Expression right = expression.getRight();
		
		// Pointer x = Pointer y

		if(op.equals("=")){
			checkPointerConnectionExpression(left,currentClassInstance,right,currentClassInstance);
		}
		LinkedList<Expression> tempList = new LinkedList<Expression>();
		tempList.add(((BinaryExpression) expression).getRight());
		dra.traverseCFGandAnalysePointer(tempList, currentClassInstance);
		
	}
	
	
	// lokal zugewiesen Pointer sind unrelevant
	public boolean checkPointerConnectionEachIsWorth(SCVariable varLeft, SCClassInstance classInstanceVarLeft, SCVariable varRight, SCClassInstance classInstanceVarRight){
		
		if(classInstanceVarLeft.getSCClass().getMembers().contains(varLeft)
				|| classInstanceVarRight.getSCClass().getMembers().contains(varRight)){
			return true;
		}
		
		for(DRAPointerConnection draPC : dra.getPossiblePointerConnection()){
			
			if(draPC.getVar() == varRight && draPC.getClassInstance()== classInstanceVarRight){
				return true;
			}

			if(draPC.getVar() == varLeft && draPC.getClassInstance()== classInstanceVarLeft){
				return true;
			}

		}
		
		return false;
	}
	
	public void checkPointerConnectionEach(SCVariable varLeft, SCClassInstance classInstanceVarLeft, SCVariable varRight, SCClassInstance classInstanceVarRight){
		
		boolean foundPossiblePointerConnection=false;

		for(DRAPointerConnection draPC : dra.getPossiblePointerConnection()){
			
			if(draPC.getVar() == varRight && draPC.getClassInstance()== classInstanceVarRight){
				
				boolean found=false;
				
				for(Pair<SCVariable, SCClassInstance> pair : draPC.getPointerConnections()){
					
					if(pair.getFirst() == varLeft &&  pair.getSecond() == classInstanceVarLeft){
						found = true;
						break;
					}
					
				}
				
				if(!found){
					draPC.getPointerConnections().add(new Pair<SCVariable, SCClassInstance>(varLeft,classInstanceVarLeft));
				}

				foundPossiblePointerConnection = true;
				break;
			}
			
		}
		
		if(!foundPossiblePointerConnection){

			DRAPointerConnection draPC = new DRAPointerConnection(varRight,classInstanceVarRight);
			draPC.getPointerConnections().add(new Pair<SCVariable, SCClassInstance>(varLeft,classInstanceVarLeft));
			dra.getPossiblePointerConnection().add(draPC);
		}

	}
	
	public void checkPointerConnection(SCVariable varLeft, SCClassInstance classInstanceVarLeft, SCVariable varRight, SCClassInstance classInstanceVarRight){
		if(checkPointerConnectionEachIsWorth(varLeft, classInstanceVarLeft, varRight, classInstanceVarRight)){
			checkPointerConnectionEach(varLeft,classInstanceVarLeft,varRight,classInstanceVarRight);
			checkPointerConnectionEach(varRight,classInstanceVarRight,varLeft,classInstanceVarLeft);
			
		}
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression expression,
			SCClassInstance currentClassInstance) {
		
		checkPointerConnectionDuringFunctionCall(expression,currentClassInstance, currentClassInstance);
		
		dra.traverseCFGandAnalysePointer(((FunctionCallExpression) expression).getFunction().getBody(), currentClassInstance);
		
	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression instanceof ArrayAccessExpression){
			ArrayAccessExpression aAE = (ArrayAccessExpression) expression;
			dra.traverseCFGandAnalysePointer(aAE.getAccess(), currentClassInstance);
		}
		
	}


	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression.getFirstInitialValue()!=null){
			checkPointerConnectionExpression(expression.getVariable(),currentClassInstance,expression.getFirstInitialValue(),currentClassInstance);
		}
		
		dra.traverseCFGandAnalysePointer(expression.getInitialValues(), currentClassInstance);
		
	}


	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	
	public void checkPointerConnectionDuringFunctionCall(FunctionCallExpression functionCallExpression, 
			SCClassInstance functionCallExpressionClassInstance, SCClassInstance functionClassInstance){
		
		SCFunction function = functionCallExpression.getFunction();
		
		for(int i=0; i<functionCallExpression.getParameters().size(); i++){
			
			Expression parameter = functionCallExpression.getParameters().get(i);
			
			/**
			 * Fälle:
			 *  parameter RefDerefExpression oder SCVariableExpression mit Variable SCPointerVariable
			 *  functionParameter RefDerefExpression oder SCVariableExpression mit Variable SCPointerVariable
			 * 
			 */
			
			// case Wait(0, SC_NS)
			if(i<function.getParameters().size()){
				
				SCParameter functionParameter = function.getParameters().get(i);
				SCVariable 	functionVariable = functionParameter.getVar();		
				
				// e.g.: int x;
				// f(&x) -> f(int *y)
				
				if(parameter instanceof RefDerefExpression){
					
					RefDerefExpression refDerefExpression = (RefDerefExpression) parameter;
					Expression refDerefInnerExpression =  refDerefExpression.getExpression();
					
					if(refDerefInnerExpression instanceof SCVariableExpression && refDerefExpression.isReferencing()){
						
						SCVariableExpression scVarExpression = (SCVariableExpression) refDerefInnerExpression;
						
						SCVariable varParam = scVarExpression.getVar();
						
						if(functionVariable instanceof SCPointer && functionParameter.getRefType() == SCREFERENCETYPE.BYVALUE){

							checkPointerConnection( varParam, functionCallExpressionClassInstance, functionVariable,functionClassInstance);
							return;
						}
							
					}
						
				}

				// e.g.: int x;
				// f(&x) -> f(int &y)

				if(parameter instanceof RefDerefExpression){
					
					RefDerefExpression refDerefExpression = (RefDerefExpression) parameter;
					Expression refDerefInnerExpression =  refDerefExpression.getExpression();
					
					if(refDerefInnerExpression instanceof SCVariableExpression && refDerefExpression.isReferencing()){
						
						SCVariableExpression scVarExpression = (SCVariableExpression) refDerefInnerExpression;
						
						SCVariable varParam = scVarExpression.getVar();
						
						if(functionParameter.getRefType() == SCREFERENCETYPE.BYREFERENCE){

							checkPointerConnection(functionVariable,functionClassInstance, varParam, functionCallExpressionClassInstance);
							return;
							
						}
							
					}
						
				}
				
				// e.g.: int * x;
				// f(x) -> f(int &y)
	
				if(parameter instanceof SCVariableExpression){
					
					SCVariable varParameter = ((SCVariableExpression) parameter).getVar();
	
					if(varParameter instanceof SCPointer && functionParameter.getRefType() == SCREFERENCETYPE.BYREFERENCE){

						checkPointerConnection(functionVariable,functionClassInstance, varParameter, functionCallExpressionClassInstance);
						return;
						
					}
							
				}
							
				// e.g.: int * x;
				// f(x) -> f(int *y)
	
				if(parameter instanceof SCVariableExpression){
					
					SCVariable varParameter = ((SCVariableExpression) parameter).getVar();
	
					if(varParameter instanceof SCPointer && functionVariable instanceof SCPointer && functionParameter.getRefType() == SCREFERENCETYPE.BYVALUE){

						checkPointerConnection(functionVariable,functionClassInstance, varParameter, functionCallExpressionClassInstance);
						return;
						
					}
							
				}
					
			}
			
		}
		
	}
	
	@Override
	public void accessExpressionHandler(AccessExpression expression,
			SCClassInstance currentClassInstance) {
		
		Expression left = expression.getLeft();
		Expression right = expression.getRight();
		
		if(left instanceof SCPortSCSocketExpression &&
			right instanceof FunctionCallExpression	){
			
			FunctionCallExpression functionCallExpression = (FunctionCallExpression) right;
			
			SCPort port = ((SCPortSCSocketExpression) left).getSCPortSCSocket();
			String functionName = ((FunctionCallExpression) right).getFunction().getName();

			for(SCConnectionInterface scci : currentClassInstance.getPortSocketInstances()){
				
				if(scci instanceof SCPortInstance){

					if(scci.getPortSocket()==port){
						
						for(SCKnownType knownType : ((SCPortInstance) scci).getChannels() ){

							SCClass scclass = knownType.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
							
							checkPointerConnectionDuringFunctionCall(functionCallExpression,currentClassInstance,knownType);
							
							dra.traverseCFGandAnalysePointer(scfunction.getBody(), knownType);

							return;
							
						}

						for(SCClassInstance classInstancePort :((SCPortInstance) scci).getModuleInstances()){

							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);

							checkPointerConnectionDuringFunctionCall(functionCallExpression,currentClassInstance,classInstancePort);

							dra.traverseCFGandAnalysePointer(scfunction.getBody(), classInstancePort);
							
							return;
							
						}

					}

				}
				if(scci instanceof SCSocketInstance){
					
					if(scci.getPortSocket()==port){
						
						for(SCSocketInstance socketInstance :((SCSocketInstance) scci).getPortSocketInstances()){
							
							SCClassInstance classInstancePort = socketInstance.getOwner();
							
							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
							
							checkPointerConnectionDuringFunctionCall(functionCallExpression,currentClassInstance,classInstancePort);

							dra.traverseCFGandAnalysePointer(scfunction.getBody(), classInstancePort);
							
							return;
							
						}
						
					}
					
				}

			}
			
		}

	}

	@Override
	public void SwitchCaseExpressionHandler(SwitchExpression expression, SCClassInstance currentClassInstance) {
		for(Expression caseExpression: expression.getCases()){
			if(caseExpression instanceof CaseExpression){
				dra.traverseCFGandAnalysePointer(((CaseExpression) caseExpression).getBody(), currentClassInstance);
			}
		}
		
	}


	@Override
	public void CaseExpressionHandler(CaseExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void sCPortSCSocketExpressionHandler(
			SCPortSCSocketExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void elseHandler(Expression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void refDerefExpressionHandler(RefDerefExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

}
