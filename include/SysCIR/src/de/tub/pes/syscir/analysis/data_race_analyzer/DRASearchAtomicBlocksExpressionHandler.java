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
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCPortInstance;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCSocketInstance;
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
public class DRASearchAtomicBlocksExpressionHandler implements DRAExpressionHandler{
	
	DataRaceAnalyzer dra;
	
	private SCClassInstance classInstance;
	
	private SCProcess process;
	
	public DRASearchAtomicBlocksExpressionHandler(DataRaceAnalyzer dra){
		this.dra = dra;
	}
	
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> thenExpression = ((IfElseExpression) expression).getThenBlock() ;
		List<Expression> elseExpression = ((IfElseExpression) expression).getElseBlock() ;
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add(expression.getCondition());
		
		dra.traverseCFG(conditionList, currentClassInstance, expression);

		dra.traverseCFG(thenExpression, currentClassInstance, expression);
		dra.traverseCFG(elseExpression, currentClassInstance, expression);
		
	}

	@Override
	public void loopExpressionHandler(LoopExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> conditionList = new LinkedList<Expression>();
		conditionList.add( ((LoopExpression) expression).getCondition());
		dra.traverseCFG(conditionList, currentClassInstance, expression);
		
		dra.traverseCFG(((LoopExpression) expression).getLoopBody(), currentClassInstance, expression);
		
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

	@Override
	public void binaryExpressionHandler(BinaryExpression expression,
			SCClassInstance currentClassInstance) {
		
		LinkedList<Expression> tempList = new LinkedList<Expression>();
		tempList.add(((BinaryExpression) expression).getRight());
		dra.traverseCFG(tempList, currentClassInstance, expression);

		LinkedList<Expression> tempListLeft = new LinkedList<Expression>();
		tempListLeft.add(((BinaryExpression) expression).getLeft());
		dra.traverseCFG(tempListLeft, currentClassInstance, expression);
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression expression,
			SCClassInstance currentClassInstance) {
		if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
			AtomicBlock newBlock = new AtomicBlock(expression, getClassInstance(), getProcess(), currentClassInstance, dra.getScs(),dra);
			dra.getAtomicBlocks().add(newBlock);
			newBlock.analyzeAtomicBlock();
		}else{
			dra.traverseCFG(((FunctionCallExpression) expression).getFunction().getBody(), currentClassInstance, expression);
		}
		
	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> list = new LinkedList<Expression>();
		list.add(expression.getExpression());
		dra.traverseCFG(list, currentClassInstance, expression);

	}


	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression instanceof ArrayAccessExpression){
			ArrayAccessExpression aAE = (ArrayAccessExpression) expression;
			dra.traverseCFG(aAE.getAccess(), currentClassInstance, expression);
		}
		
	}


	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> tempList = new LinkedList<Expression>();
		tempList.add(expression.getVariable());
		
		dra.traverseCFG(tempList, currentClassInstance, expression);

		dra.traverseCFG(expression.getInitialValues(), currentClassInstance, expression);
		
	}


	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void accessExpressionHandler(AccessExpression expression,
			SCClassInstance currentClassInstance) {
		
		Expression left = expression.getLeft();
		Expression right = expression.getRight();
		
		left.setParent(expression);
		right.setParent(expression);
		
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
							
							if(!dra.getAccesExpressionToClassInstance().containsKey(expression)){
								List<Pair<SCClassInstance, SCClassInstance>> ll = new LinkedList<Pair<SCClassInstance, SCClassInstance>>();
								ll.add(new Pair<SCClassInstance, SCClassInstance>(knownType,currentClassInstance));
								dra.getAccesExpressionToClassInstance().put(expression,ll);
							}else{
								dra.getAccesExpressionToClassInstance().get(expression).add(new Pair<SCClassInstance, SCClassInstance>(knownType,currentClassInstance));
							}
							
							dra.traverseCFG(scfunction.getBody(), knownType, right);

							return;
							
						}

						for(SCClassInstance classInstancePort :((SCPortInstance) scci).getModuleInstances()){

							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);

							if(!dra.getAccesExpressionToClassInstance().containsKey(expression)){
								List<Pair<SCClassInstance, SCClassInstance>> ll = new LinkedList<Pair<SCClassInstance, SCClassInstance>>();
								ll.add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
								dra.getAccesExpressionToClassInstance().put(expression,ll);
							}else{
								dra.getAccesExpressionToClassInstance().get(expression).add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
							}
							
							dra.traverseCFG(scfunction.getBody(), classInstancePort, right);
							
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
							
							if(!dra.getAccesExpressionToClassInstance().containsKey(expression)){
								List<Pair<SCClassInstance, SCClassInstance>> ll = new LinkedList<Pair<SCClassInstance, SCClassInstance>>();
								ll.add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
								dra.getAccesExpressionToClassInstance().put(expression,ll);
							}else{
								dra.getAccesExpressionToClassInstance().get(expression).add(new Pair<SCClassInstance, SCClassInstance>(classInstancePort,currentClassInstance));
							}
							
							dra.traverseCFG(scfunction.getBody(), classInstancePort, right);
							
							return;
							
						}
						
					}
					
				}

			}
			
		}

	}


	public SCClassInstance getClassInstance() {
		return classInstance;
	}


	public void setClassInstance(SCClassInstance classInstance) {
		this.classInstance = classInstance;
	}


	public SCProcess getProcess() {
		return process;
	}


	public void setProcess(SCProcess process) {
		this.process = process;
	}


	@Override
	public void SwitchCaseExpressionHandler(SwitchExpression expression, SCClassInstance currentClassInstance) {
		
		LinkedList<Expression> list = new LinkedList<Expression>();
		list.add(expression.getSwitchExpression());
		
		dra.traverseCFG(list, currentClassInstance, expression);

		for(Expression caseExpression: expression.getCases()){
			caseExpression.setParent(expression);
			if(caseExpression instanceof CaseExpression){
				dra.traverseCFG(((CaseExpression) caseExpression).getBody(), currentClassInstance, caseExpression);
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
		
		dra.traverseCFG(tempList, currentClassInstance, expression);
		
	}

}
