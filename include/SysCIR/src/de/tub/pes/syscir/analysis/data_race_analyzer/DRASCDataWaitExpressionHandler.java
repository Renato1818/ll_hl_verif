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
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
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
public class DRASCDataWaitExpressionHandler implements DRAExpressionHandler {

	private boolean waitOccurance;
	
	private DRASCData draSCData;
	
	public DRASCDataWaitExpressionHandler(DRASCData draSCData){
		this.draSCData=draSCData;
	}
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression expression,
			SCClassInstance currentClassInstance) {
		List<Expression> thenExpression = ((IfElseExpression) expression).getThenBlock() ;
		List<Expression> elseExpression = ((IfElseExpression) expression).getElseBlock() ;
		
		if(draSCData.checkDeeplyExpressionListForWaitStatement(thenExpression, currentClassInstance)
				&&
				draSCData.checkDeeplyExpressionListForWaitStatement(elseExpression, currentClassInstance)){
					setWaitOccurance(true);
			}
		
	}

	@Override
	public void loopExpressionHandler(LoopExpression expression,
			SCClassInstance currentClassInstance) {
		if(expression instanceof ForLoopExpression){
			if(draSCData.checkDeeplyExpressionListForWaitStatement(((LoopExpression) expression).getLoopBody(), currentClassInstance))
				setWaitOccurance(true);
		}
	}

	@Override
	public void portCallHandler(SCFunction scfunction,
			SCKnownType knownType, SCClassInstance currentClassInstance) {
		if(draSCData.checkDeeplyExpressionListForWaitStatement(scfunction.getBody(), knownType))
			setWaitOccurance(true);
		
	}

	@Override
	public void portCallHandler(SCFunction scfunction,
			SCClassInstance classInstancePort,
			SCClassInstance currentClassInstance) {
		if(draSCData.checkDeeplyExpressionListForWaitStatement(scfunction.getBody(), classInstancePort))
			setWaitOccurance(true);
		
	}

	@Override
	public void binaryExpressionHandler(BinaryExpression expression,
			SCClassInstance currentClassInstance) {
		LinkedList<Expression> tempList = new LinkedList<Expression>();
		tempList.add(((BinaryExpression) expression).getRight());
		if(draSCData.checkDeeplyExpressionListForWaitStatement(tempList, currentClassInstance))
			setWaitOccurance(true);
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression expression,
			SCClassInstance currentClassInstance) {
		if(draSCData.checkDeeplyExpressionListForWaitStatement(((FunctionCallExpression) expression).getFunction().getBody(), currentClassInstance))
			setWaitOccurance(true);
		
	}

	public boolean isWaitOccurance() {
		return waitOccurance;
	}

	public void setWaitOccurance(boolean waitOccurance) {
		this.waitOccurance = waitOccurance;
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
							
							portCallHandler(scfunction, knownType, currentClassInstance);
							
						}

						for(SCClassInstance classInstancePort :((SCPortInstance) scci).getModuleInstances()){

							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);

							portCallHandler(scfunction, classInstancePort, currentClassInstance);

						}

					}

				}
				
				if(scci instanceof SCSocketInstance){
					
					if(scci.getPortSocket()==port){
						
						for(SCSocketInstance socketInstance :((SCSocketInstance) scci).getPortSocketInstances()){
							
							SCClassInstance classInstancePort = socketInstance.getOwner();
							
							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);
							
							portCallHandler(scfunction, classInstancePort, currentClassInstance);
														
						}
						
					}
					
				}


			}

		}
		
	}

	@Override
	public void SwitchCaseExpressionHandler(SwitchExpression expression,
			SCClassInstance currentClassInstance) {
		for(Expression caseExpression: expression.getCases()){
			if(caseExpression instanceof CaseExpression){
				if(!draSCData.checkDeeplyExpressionListForWaitStatement(((CaseExpression) caseExpression).getBody(), currentClassInstance)){
					return;
				}
			}
		}
		setWaitOccurance(true);
		
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
