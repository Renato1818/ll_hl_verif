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
import de.tub.pes.syscir.sc_model.variables.SCEvent;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;
import de.tub.pes.syscir.sc_model.variables.SCPointer;

/**
 * 
 * @author Björn Beckmann
 *
 */
public class AtomicBlockAnalyzeExpressionHandler implements DRAExpressionHandler{
	
	AtomicBlock atomicBlock;
	
	public AtomicBlockAnalyzeExpressionHandler(AtomicBlock atomicBlock){
		this.atomicBlock=atomicBlock;
	}
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> thenExpression = expression.getThenBlock() ;
		List<Expression> elseExpression =  expression.getElseBlock() ;
		List<Expression> conditionList = new LinkedList<Expression>();
		
		conditionList.add(expression.getCondition());
		
		atomicBlock.analyze(conditionList, currentClassInstance, expression);

		atomicBlock.analyze(thenExpression, currentClassInstance, expression);
		atomicBlock.analyze(elseExpression, currentClassInstance, expression);
		
	}

	@Override
	public void loopExpressionHandler(LoopExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add(expression.getCondition());
		
		atomicBlock.analyze(conditionList, currentClassInstance, expression);

		atomicBlock.analyze(expression.getLoopBody(), currentClassInstance, expression);
		
	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> conditionList = new LinkedList<Expression>();
		Expression uExpression = expression.getExpression();
		conditionList.add(expression.getExpression());
		
		if(expression.getOperator().equals("++")){
			
			if(uExpression instanceof AccessExpression){
				AccessExpression aE = (AccessExpression) uExpression;
				
				atomicBlock.checkAccessExpression(aE,currentClassInstance,atomicBlock.getGlobalVariableWrite());
			
			}
			
			if(uExpression instanceof SCVariableExpression){
				SCVariable uVariable = ((SCVariableExpression) uExpression).getVar();

				atomicBlock.checkGlobalVar(expression,atomicBlock.getGlobalVariableWrite(),uVariable,currentClassInstance);
				
			}
			
		}
			
		atomicBlock.analyze(conditionList, currentClassInstance, expression);
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
				
				AccessExpression aE = (AccessExpression) left;
				
				atomicBlock.checkAccessExpression(aE,currentClassInstance,atomicBlock.getGlobalVariableWrite());
			
			}
			
			if(left instanceof SCVariableExpression){
				
				SCVariable scVariable = ((SCVariableExpression) left).getVar();
				
				atomicBlock.checkGlobalVar(expression,atomicBlock.getGlobalVariableWrite(),scVariable,currentClassInstance,right);

			}

			if(left instanceof RefDerefExpression){
				
				RefDerefExpression leftRefDeref = (RefDerefExpression) left;
				
				if(leftRefDeref.getExpression() instanceof SCVariableExpression && leftRefDeref.isDerefencing()){
					
					SCVariable scVariable = ((SCVariableExpression) leftRefDeref.getExpression()).getVar();
					
					atomicBlock.checkGlobalVar(expression,atomicBlock.getGlobalVariableWrite(),scVariable,currentClassInstance);

				}
				

			}

			left.setParent(expression);
			atomicBlock.analyze(tempListRight, currentClassInstance, expression);
		
		}else{
			//e.g.: ==, <, +, *

			atomicBlock.analyze(tempListLeft, currentClassInstance, expression);
			atomicBlock.analyze(tempListRight, currentClassInstance, expression);
		}
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression expression,
			SCClassInstance currentClassInstance) {
		
		SCFunction function = ((FunctionCallExpression) expression).getFunction();
		if(!function.getName().equals("wait")){
			
			for(SCParameter parameter : function.getParameters()){
				if(parameter.getVar() instanceof SCVariable){
						
						if(!(parameter.getVar() instanceof SCPointer)){
							atomicBlock.checkGlobalVar(expression,atomicBlock.getGlobalVariableRead(),parameter.getVar(),currentClassInstance);
						}
						
					}
			}
			
		}
		
		atomicBlock.analyze( expression.getFunction().getBody(), currentClassInstance, expression);
		
	}

	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {

		SCVariable scVariable =  expression.getVar();

		if(expression instanceof ArrayAccessExpression){
			
			ArrayAccessExpression aAE = (ArrayAccessExpression) expression;
			atomicBlock.analyze(aAE.getAccess(), currentClassInstance, expression);
			
		}
		
		atomicBlock.checkGlobalVar(expression,atomicBlock.getGlobalVariableRead(),scVariable,currentClassInstance);
		
	}

	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		
		expression.getVariable().setParent(expression);
		
		if(expression.getFirstInitialValue()!=null){
			
			if(expression.getVariable() instanceof AccessExpression){
				
				AccessExpression aE = (AccessExpression) expression.getVariable();
				
				atomicBlock.checkAccessExpression(aE,currentClassInstance,atomicBlock.getGlobalVariableWrite());
				
			}
			
			if(expression.getVariable() instanceof SCVariableExpression){

				SCVariableExpression eVar = (SCVariableExpression) expression.getVariable();
				
				SCVariable scVariable =  eVar.getVar();
				
				atomicBlock.checkGlobalVar(eVar,atomicBlock.getGlobalVariableWrite(),scVariable,currentClassInstance,expression.getFirstInitialValue());

			}

			if(expression.getVariable() instanceof RefDerefExpression){
				
				RefDerefExpression leftRefDeref = (RefDerefExpression) expression.getVariable();
				
				if(leftRefDeref.getExpression() instanceof SCVariableExpression && leftRefDeref.isDerefencing()){
					
					leftRefDeref.getExpression().setParent(leftRefDeref);
					
					SCVariable scVariable = ((SCVariableExpression) leftRefDeref.getExpression()).getVar();
					
					atomicBlock.checkGlobalVar(leftRefDeref.getExpression(),atomicBlock.getGlobalVariableWrite(),scVariable,currentClassInstance);

				}
				

			}
			
			List<Expression> tempList = new LinkedList<Expression>();
			tempList.add(expression.getFirstInitialValue());
		
			atomicBlock.analyze(tempList, currentClassInstance, expression);

		}
		

	}

	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression.getEvent() instanceof SCVariableExpression){
			if(((SCVariableExpression) expression.getEvent()).getVar() instanceof SCEvent){
				
				SCEvent scEvent = (SCEvent) ((SCVariableExpression) expression.getEvent()).getVar();
				
				List<Expression> parameters = expression.getParameters();
				
				//immediate notification
				if(parameters.size()==0){

					if(!atomicBlock.draSCEventListContains(atomicBlock.getNotifySCEvent(),scEvent)){
						DRASCEvent event = new DRASCEvent(atomicBlock, currentClassInstance);
						event.setEvent(scEvent);
						event.analyzeParentExpression(expression, currentClassInstance);
						event.analyzeParentForwardExpression(expression, currentClassInstance);
						atomicBlock.getNotifySCEvent().add(event);
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
		
		left.setParent(expression);
		right.setParent(expression);
		
		atomicBlock.checkAccessExpression(expression,currentClassInstance,atomicBlock.getGlobalVariableRead());
		
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
													
							if(!atomicBlock.getDra().getAccesExpressionToClassInstance().containsKey(expression)){
								List<Pair<SCClassInstance, SCClassInstance>> ll = new LinkedList<Pair<SCClassInstance, SCClassInstance>>();
								ll.add(new Pair<SCClassInstance, SCClassInstance>(knownType,currentClassInstance));
								atomicBlock.getDra().getAccesExpressionToClassInstance().put(expression,ll);
							}else{
								atomicBlock.getDra().getAccesExpressionToClassInstance().get(expression).add(new Pair<SCClassInstance, SCClassInstance>(knownType,currentClassInstance));
							}

							atomicBlock.analyze(scfunction.getBody(), knownType, right);
							
						}

						for(SCClassInstance classInstancePort :((SCPortInstance) scci).getModuleInstances()){

							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
							
							if(!atomicBlock.getDra().getAccesExpressionToClassInstance().containsKey(expression)){
								List<Pair<SCClassInstance, SCClassInstance>> ll = new LinkedList<Pair<SCClassInstance, SCClassInstance>>();
								ll.add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
								atomicBlock.getDra().getAccesExpressionToClassInstance().put(expression,ll);
							}else{
								atomicBlock.getDra().getAccesExpressionToClassInstance().get(expression).add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
							}

							atomicBlock.analyze(scfunction.getBody(), classInstancePort, right);

						}
						

					}

				}
				
				if(scci instanceof SCSocketInstance){
					
					if(scci.getPortSocket()==port){
						
						for(SCSocketInstance socketInstance :((SCSocketInstance) scci).getPortSocketInstances()){
							
							SCClassInstance classInstancePort = socketInstance.getOwner();
							
							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);

							if(!atomicBlock.getDra().getAccesExpressionToClassInstance().containsKey(expression)){
								List<Pair<SCClassInstance, SCClassInstance>> ll = new LinkedList<Pair<SCClassInstance, SCClassInstance>>();
								ll.add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
								atomicBlock.getDra().getAccesExpressionToClassInstance().put(expression,ll);
							}else{
								atomicBlock.getDra().getAccesExpressionToClassInstance().get(expression).add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
							}

							atomicBlock.analyze(scfunction.getBody(), classInstancePort, right);

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
		
		LinkedList<Expression> list = new LinkedList<Expression>();
		list.add(expression.getSwitchExpression());
		
		atomicBlock.analyze(list, currentClassInstance, expression);
		
		for(Expression caseExpression: expression.getCases()){
			caseExpression.setParent(expression);
			if(caseExpression instanceof CaseExpression){
				atomicBlock.analyze(((CaseExpression) caseExpression).getBody(), currentClassInstance, caseExpression);
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
		
		atomicBlock.analyze(tempList, currentClassInstance, expression);
		
		
	}
	
}
