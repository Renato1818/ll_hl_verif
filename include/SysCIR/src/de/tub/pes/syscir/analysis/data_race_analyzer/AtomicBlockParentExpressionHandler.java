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
public class AtomicBlockParentExpressionHandler implements DRAExpressionHandler{

	private AtomicBlock atomicBlock;

	private Expression currentExpression;
	
	public AtomicBlockParentExpressionHandler(AtomicBlock atomicBlock){
		this.atomicBlock=atomicBlock;
	}
	
	private void analyzeSubListAndParentExpression(List<Expression> parentList, 
			Expression parentExpression, SCClassInstance currentClassInstance){
		
		int begin = parentList.indexOf(currentExpression)+1;
		
		int end = parentList.size();
		
		List<Expression> list = parentList.subList(begin, end);

		atomicBlock.analyzeListAndParent(list, currentClassInstance, parentExpression);
				
	}
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression parentExpression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> thenExpression = parentExpression.getThenBlock() ;
		List<Expression> elseExpression = parentExpression.getElseBlock() ;

		List<Expression> parentList = new LinkedList<Expression>();
		if(thenExpression.contains(getCurrentExpression())){
			parentList = thenExpression;
		}else{
			parentList = elseExpression;
		}
		analyzeSubListAndParentExpression(parentList,parentExpression,currentClassInstance);
	}

	@Override
	public void loopExpressionHandler(LoopExpression parentExpression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> parentList = new LinkedList<Expression>();

		parentList = parentExpression.getLoopBody();
		
		int begin = parentList.indexOf(currentExpression)+1;
		
		int end = parentList.size();
		
		List<Expression> list = parentList.subList(begin, end);
		
		//if not exists a wait Statement in the relevant sublist of the loop
		if(atomicBlock.checkDeeplyExpressionListForWaitStatement(list, currentClassInstance)){

			atomicBlock.analyze(list, currentClassInstance, parentExpression);			

		}else{
			
			atomicBlock.analyze(parentList, currentClassInstance, parentExpression);
			
			atomicBlock.analyzeListAndParent(list, currentClassInstance, parentExpression);			

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
		// TODO Auto-generated method stub
		
	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression parentExpression,
			SCClassInstance currentClassInstance) {
		//call a channel function
		
		if(parentExpression.getParent() != null && parentExpression.getParent() instanceof AccessExpression){
			
			AccessExpression accessExpression = (AccessExpression) parentExpression.getParent();
			
			Expression left = accessExpression.getLeft();
			Expression right = accessExpression.getRight();
			
			if(left instanceof SCPortSCSocketExpression &&
				right instanceof FunctionCallExpression	){
				
				for(Pair<SCClassInstance, SCClassInstance> p : atomicBlock.getDra().getAccesExpressionToClassInstance().get(accessExpression)){
					if(p.getFirst()==currentClassInstance){
						analyzeSubListAndParentExpression(((FunctionCallExpression) right).getFunction().getBody(), parentExpression.getParent(), p.getSecond());
						return;
					}
				}
				
				System.out.println("Error: Did not find class instance of AccessExpression (AtomicBlock)");
				return;
				
			}
		}
		//call of a function of the current module
		else{
			List<Expression> parentList = new LinkedList<Expression>();
			parentList = ((FunctionCallExpression) parentExpression).getFunction().getBody();
			analyzeSubListAndParentExpression(parentList,parentExpression,currentClassInstance);

		}
		
	}

	@Override
	public void accessExpressionHandler(AccessExpression expression,
			SCClassInstance currentClassInstance) {
				
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

		parentList.add(expression.getSwitchExpression());
		
		analyzeSubListAndParentExpression(parentList,expression,currentClassInstance);

	}

	@Override
	public void CaseExpressionHandler(CaseExpression expression,
			SCClassInstance currentClassInstance) {
		
		List<Expression> parentList = new LinkedList<Expression>();

		parentList = expression.getBody();
		
		analyzeSubListAndParentExpression(parentList,expression,currentClassInstance);
		
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
