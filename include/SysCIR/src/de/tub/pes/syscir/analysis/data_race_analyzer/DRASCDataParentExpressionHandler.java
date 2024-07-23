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
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.DoWhileLoopExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.ForLoopExpression;
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
public class DRASCDataParentExpressionHandler implements DRAExpressionHandler {
	
	private DRASCData draSCData;
	
	private Expression currentExpression;
	
	public DRASCDataParentExpressionHandler(DRASCData draSCData){
		this.draSCData = draSCData;
	}
	
	private void analyzeSubListAndParentExpression(List<Expression> parentList, SCClassInstance currentClassInstance, 
			Expression parentExpression){
		if (parentList.contains(currentExpression)) {
			int end = parentList.indexOf(currentExpression);
			List<Expression> list = parentList.subList(0, end);
			draSCData.analyze(list, currentClassInstance, parentExpression);
		}
	}
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression parentExpression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> thenExpression = parentExpression.getThenBlock() ;
		List<Expression> elseExpression = parentExpression.getElseBlock() ;
		Expression condition =  parentExpression.getCondition();

		List<Expression> parentList = new LinkedList<Expression>();
		
		if( thenExpression.contains(currentExpression)){

			parentList = thenExpression;
			int end = parentList.indexOf(currentExpression);
			List<Expression> list = parentList.subList(0, end);
	
			if(	!draSCData.checkDeeplyExpressionListForWaitStatement(list, currentClassInstance)){
				draSCData.getConditionList().add(condition);
			}
			
		}else if(elseExpression.contains(currentExpression)){
			parentList = elseExpression;
			int end = parentList.indexOf(currentExpression);
			List<Expression> list = parentList.subList(0, end);
	
			if(	!draSCData.checkDeeplyExpressionListForWaitStatement(list, currentClassInstance)){
				//this has side unwanted side effects as new UnaryExpression sets the parent of conditoon
				// -> reset parent after creation
				Expression oldParent = condition.getParent();
				UnaryExpression unaryExpr = new UnaryExpression(null,true,"!",condition);
				draSCData.getConditionList().add(unaryExpr);
				condition.setParent(oldParent);
			}

			
		}else if(condition == currentExpression){
			parentList.add(condition);			
		}

		analyzeSubListAndParentExpression(parentList, currentClassInstance, parentExpression);

	}

	@Override
	public void loopExpressionHandler(LoopExpression parentExpression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> parentList = new LinkedList<Expression>();
		parentList = parentExpression.getLoopBody();
		Expression condition = parentExpression.getCondition();

		if(parentList.contains(currentExpression)){
			
			int end = parentList.indexOf(currentExpression);
			List<Expression> list = parentList.subList(0, end);

			if(parentExpression instanceof DoWhileLoopExpression){
			
				if(draSCData.checkDeeplyExpressionListForWaitStatement(list, currentClassInstance)){
					
					draSCData.analyze(list, currentClassInstance);
		
				}else{
					
					draSCData.getConditionList().add(condition);
					
					analyzeSubListAndParentExpression(parentList, currentClassInstance, parentExpression);
				
				}
			
			}
			
			if(parentExpression instanceof ForLoopExpression){
				
				if(draSCData.checkDeeplyExpressionListForWaitStatement(list, currentClassInstance)){
					
					draSCData.analyze(list, currentClassInstance);
		
				}else{
					
					analyzeSubListAndParentExpression(parentList, currentClassInstance, parentExpression);
				
				}
				
			}
		
		}
		
		if(condition == currentExpression){
			
			parentList = new LinkedList<Expression>();
			parentList.add(condition);
			
			analyzeSubListAndParentExpression(parentList, currentClassInstance, parentExpression);

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
	public void binaryExpressionHandler(BinaryExpression expression,
			SCClassInstance currentClassInstance) {

		if(expression.getRight()==currentExpression){
			List<Expression> list = new LinkedList<Expression>();
			list.add(expression.getRight());
			analyzeSubListAndParentExpression(list, currentClassInstance, expression);
		}else if(expression.getLeft()==currentExpression){
			List<Expression> list = new LinkedList<Expression>();
			list.add(expression.getLeft());
			analyzeSubListAndParentExpression(list, currentClassInstance, expression);
		}

	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression.getExpression()==currentExpression){
			List<Expression> list = new LinkedList<Expression>();
			list.add(expression.getExpression());
			analyzeSubListAndParentExpression(list, currentClassInstance, expression);
		}
		
	}

	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {
		
	}

	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(currentExpression==expression.getVariable()){
			List<Expression> parentList = new LinkedList<Expression>();
			parentList.add(expression.getVariable());
			analyzeSubListAndParentExpression(parentList, currentClassInstance, expression);
		}else{
			analyzeSubListAndParentExpression(expression.getInitialValues(), currentClassInstance, expression);
		}
		
	}

	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression parentExpression,
			SCClassInstance currentClassInstance) {
		
		//call a module function

		if(parentExpression.getParent() != null && parentExpression.getParent() instanceof AccessExpression){
			
			AccessExpression accessExpression = (AccessExpression) parentExpression.getParent();
			
			Expression left = accessExpression.getLeft();
			Expression right = accessExpression.getRight();
			
			if(left instanceof SCPortSCSocketExpression &&
				right instanceof FunctionCallExpression	){
				
				
					for(Pair<SCClassInstance, SCClassInstance> p : draSCData.getAtomicBlock().getDra().getAccesExpressionToClassInstance().get(accessExpression)){
							
							if(p.getFirst()==currentClassInstance){
								analyzeSubListAndParentExpression(((FunctionCallExpression) right).getFunction().getBody(), p.getSecond(), parentExpression.getParent());
								return;
							}
							
					}
					
					System.out.println("Error: Did not find class instance of AccessExpression with current Class Instance "+currentClassInstance+" (DRASCData Parent Expression Handler)");
					return;
			
			}

		}
		//call of a function of the current module
		else{

			List<Expression> parentList = new LinkedList<Expression>();
			parentList = ((FunctionCallExpression) parentExpression).getFunction().getBody();
			analyzeSubListAndParentExpression(parentList, currentClassInstance, parentExpression);

		}
					
	}

	@Override
	public void accessExpressionHandler(AccessExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression.getLeft()==currentExpression){
			List<Expression> parentList = new LinkedList<Expression>();
			parentList.add(expression.getLeft());
			analyzeSubListAndParentExpression(parentList, currentClassInstance, expression);
		}else if(expression.getRight()==currentExpression){
			List<Expression> parentList = new LinkedList<Expression>();
			parentList.add(expression.getRight());
			analyzeSubListAndParentExpression(parentList, currentClassInstance, expression);
		}

	}

	public Expression getCurrentExpression() {
		return currentExpression;
	}

	public void setCurrentExpression(Expression currentExpression) {
		this.currentExpression = currentExpression;
	}

	@Override
	public void SwitchCaseExpressionHandler(SwitchExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> parentList = new LinkedList<Expression>();
		
		if(currentExpression == expression.getSwitchExpression()){
			parentList.add(expression.getSwitchExpression());
			analyzeSubListAndParentExpression(parentList,currentClassInstance,expression);
		}else{
			analyzeSubListAndParentExpression(expression.getCases(),currentClassInstance,expression);
			
		}
	}

	@Override
	public void CaseExpressionHandler(CaseExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> parentList = new LinkedList<Expression>();

		parentList = expression.getBody();
		
		draSCData.getConditionList().add(expression.getCondition());

		analyzeSubListAndParentExpression(parentList,currentClassInstance,expression);
		
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
		
		List<Expression> parentList = new LinkedList<Expression>();

		parentList.add(expression.getExpression());

		analyzeSubListAndParentExpression(parentList,currentClassInstance,expression);
	
		
	}

}
