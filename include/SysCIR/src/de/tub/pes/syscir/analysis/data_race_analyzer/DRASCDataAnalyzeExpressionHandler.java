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

import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCConnectionInterface;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCPortInstance;
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

/**
 * 
 * @author Björn Beckmann
 *
 */
public class DRASCDataAnalyzeExpressionHandler implements DRAExpressionHandler{
	
	DRASCData draSCData;
	
	public DRASCDataAnalyzeExpressionHandler(DRASCData draSCData){
		this.draSCData=draSCData;
	}

	@Override
	public void ifElseExpressionHandler(IfElseExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> thenExpression = expression.getThenBlock() ;
		List<Expression> elseExpression =  expression.getElseBlock() ;
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add(expression.getCondition());
		
		draSCData.analyze(conditionList, currentClassInstance);

		draSCData.analyze(thenExpression, currentClassInstance);
		draSCData.analyze(elseExpression, currentClassInstance);
		
	}

	@Override
	public void loopExpressionHandler(LoopExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add(expression.getCondition());
		draSCData.analyze(conditionList, currentClassInstance);

		draSCData.analyze(expression.getLoopBody(), currentClassInstance);
		
	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> conditionList = new LinkedList<Expression>();
		Expression uExpression = expression.getExpression();
		conditionList.add(expression.getExpression());
		
		if(expression.getOperator().equals("++")){
			
			if(uExpression instanceof AccessExpression){
				
				draSCData.checkAccessExpression((AccessExpression) uExpression, currentClassInstance, draSCData.getEditList());
				
			}

			if(uExpression instanceof SCVariableExpression){
				SCVariable uVariable = ((SCVariableExpression) uExpression).getVar();
				draSCData.getEditList().add(uVariable);
			}
		}
			
		draSCData.analyze(conditionList, currentClassInstance);
		
	}
	
	@Override
	public void binaryExpressionHandler(BinaryExpression expression,
			SCClassInstance currentClassInstance) {
		
		Expression left =  expression.getLeft();
		Expression right = expression.getRight();
		String op = expression.getOp();

		LinkedList<Expression> tempListLeft = new LinkedList<Expression>();
		tempListLeft.add(left);

		LinkedList<Expression> tempListRight = new LinkedList<Expression>();
		tempListRight.add(right);
		
		//Write
		if(op.equals("=")){

			if(left instanceof AccessExpression){
				draSCData.checkAccessExpression((AccessExpression) left, currentClassInstance, draSCData.getEditList());
			}

			if(left instanceof SCVariableExpression){
				SCVariable scVariable = ((SCVariableExpression) left).getVar();
				draSCData.getEditList().add(scVariable);
			}
			
			if(left instanceof RefDerefExpression){
				
				RefDerefExpression leftRefDeref = (RefDerefExpression) left;
				
				if(leftRefDeref.getExpression() instanceof SCVariableExpression && leftRefDeref.isDerefencing()){
					
					leftRefDeref.getExpression().setParent(leftRefDeref);
					
					SCVariable scVariable = ((SCVariableExpression) leftRefDeref.getExpression()).getVar();
					
					draSCData.getEditList().add(scVariable);

				}
			}

			draSCData.analyze(tempListRight, currentClassInstance);
		
		}else{
			//e.g.: ==, <, +, *

			draSCData.analyze(tempListLeft, currentClassInstance);
			draSCData.analyze(tempListRight, currentClassInstance);
		}

		
		
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression expression,
			SCClassInstance currentClassInstance) {
				
		draSCData.analyze( expression.getFunction().getBody(), currentClassInstance);
		
	}

	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression instanceof ArrayAccessExpression){
			ArrayAccessExpression aAE = (ArrayAccessExpression) expression;
			draSCData.analyze(aAE.getAccess(), currentClassInstance);
		}

		
	}

	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		
		expression.getVariable().setParent(expression);
		
		if(expression.getFirstInitialValue()!=null){
			
			if(expression.getVariable() instanceof AccessExpression){
				
				AccessExpression aE = (AccessExpression) expression.getVariable();
				
				draSCData.checkAccessExpression(aE, currentClassInstance, draSCData.getEditList());
				
			}
			
			if(expression.getVariable() instanceof SCVariableExpression){

				SCVariableExpression eVar = (SCVariableExpression) expression.getVariable();
				
				SCVariable scVariable =  eVar.getVar();
				
				draSCData.getEditList().add(scVariable);

			}

			if(expression.getVariable() instanceof RefDerefExpression){
				
				RefDerefExpression leftRefDeref = (RefDerefExpression) expression.getVariable();
				
				if(leftRefDeref.getExpression() instanceof SCVariableExpression && leftRefDeref.isDerefencing()){
					
					leftRefDeref.getExpression().setParent(leftRefDeref);
					
					SCVariable scVariable = ((SCVariableExpression) leftRefDeref.getExpression()).getVar();
					
					draSCData.getEditList().add(scVariable);

				}
				

			}
			
			List<Expression> tempList = new LinkedList<Expression>();
			tempList.add(expression.getFirstInitialValue());
		
			draSCData.analyze(tempList, currentClassInstance);

		}

	}

	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		
	}

	@Override
	public void accessExpressionHandler(AccessExpression expression,
			SCClassInstance currentClassInstance) {
		
		Expression left = expression.getLeft();
		Expression right = expression.getRight();
		
		if(left instanceof SCPortSCSocketExpression &&
			right instanceof FunctionCallExpression	){
			SCPort port = ((SCPortSCSocketExpression) left).getSCPortSCSocket();
			String functionName = ((FunctionCallExpression) right).getFunction().getName();

			for(SCConnectionInterface scci : currentClassInstance.getPortSocketInstances()){
				
				if(scci instanceof SCPortInstance){

					if(scci.getPortSocket()==port){
						
						for(SCKnownType knownType : ((SCPortInstance) scci).getChannels() ){

							SCClass scclass = knownType.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
														
							draSCData.analyze(scfunction.getBody(), knownType);

							
						}

						for(SCClassInstance classInstancePort :((SCPortInstance) scci).getModuleInstances()){

							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
							
							draSCData.analyze(scfunction.getBody(), classInstancePort);

						}

					}

				}
				
				if(scci instanceof SCSocketInstance){
					
					if(scci.getPortSocket()==port){
						
						for(SCSocketInstance socketInstance :((SCSocketInstance) scci).getPortSocketInstances()){
							
							SCClassInstance classInstancePort = socketInstance.getOwner();
							
							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
							
							draSCData.analyze(scfunction.getBody(), classInstancePort);
														
						}
						
					}
					
				}

			}

		}

	}

	@Override
	public void portCallHandler(SCFunction scfunction, SCKnownType knownType,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void portCallHandler(SCFunction scfunction,
			SCClassInstance classInstancePort,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void SwitchCaseExpressionHandler(SwitchExpression expression,
			SCClassInstance currentClassInstance) {
		for(Expression caseExpression: expression.getCases()){
			if(caseExpression instanceof CaseExpression){
				draSCData.analyze(((CaseExpression) caseExpression).getBody(), currentClassInstance);
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
		List<Expression> tempList = new LinkedList<Expression>();
		tempList.add(expression.getExpression());
		
		draSCData.analyze(tempList, currentClassInstance);
		
	}
	
}
