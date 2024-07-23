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

package de.tub.pes.syscir.analysis.wcmc_analyzer;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCConnectionInterface;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPROCESSTYPE;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.SCPort;
import de.tub.pes.syscir.sc_model.SCPortInstance;
import de.tub.pes.syscir.sc_model.SCREFERENCETYPE;
import de.tub.pes.syscir.sc_model.SCSocketInstance;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteExpression;
import de.tub.pes.syscir.sc_model.expressions.DoWhileLoopExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.ForLoopExpression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.NewArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.NewExpression;
import de.tub.pes.syscir.sc_model.expressions.RefDerefExpression;
import de.tub.pes.syscir.sc_model.expressions.SCClassInstanceExpression;
import de.tub.pes.syscir.sc_model.expressions.SCPortSCSocketExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.SwitchExpression;
import de.tub.pes.syscir.sc_model.expressions.UnaryExpression;
import de.tub.pes.syscir.sc_model.expressions.WhileLoopExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;

public class WCMCAnalysisExpressionHandler implements WCMCExpressionHandler {
	
	WorstCaseMemoryConsumptionAnalyzer worstCaseMemoryConsumptionAnalyzer;
	WCMCScopeData wcmcData;
	
	public WCMCAnalysisExpressionHandler(
			WorstCaseMemoryConsumptionAnalyzer worstCaseMemoryConsumptionAnalyzer,
			WCMCScopeData wcmcData) {
			this.worstCaseMemoryConsumptionAnalyzer = worstCaseMemoryConsumptionAnalyzer;
			this.wcmcData = wcmcData;
	}
	
	public void analyzeFunctionParams(SCFunction scfunction, WCMCScopeData fcWCMCData ){
		for (SCParameter param : scfunction.getParameters()) {
			if (param.getRefType() == SCREFERENCETYPE.BYVALUE) {
				fcWCMCData.setMemSize(fcWCMCData.getMemSize()+worstCaseMemoryConsumptionAnalyzer.analyzeSCVar(param.getVar()));
			}else{
				fcWCMCData.setMemSize(fcWCMCData.getMemSize()+worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get("pointer"));
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

			SCPort port = ((SCPortSCSocketExpression) left).getSCPortSCSocket();
			String functionName = ((FunctionCallExpression) right).getFunction().getName();

			for(SCConnectionInterface scci : currentClassInstance.getPortSocketInstances()){

				if(scci instanceof SCPortInstance){

					if(scci.getPortSocket()==port){
						
						for(SCKnownType knownType : ((SCPortInstance) scci).getChannels() ){

							SCClass scclass = knownType.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);

							WCMCScopeData parentfcWcmcData = wcmcData.copy();
							WCMCScopeData fcWCMCData = new WCMCScopeData(scfunction.getBody(),0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
							analyzeFunctionParams(scfunction,fcWCMCData);
							fcWCMCData.setWcmcParent(parentfcWcmcData);
							worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(fcWCMCData, knownType);
							return;

						}

						for(SCClassInstance classInstancePort :((SCPortInstance) scci).getModuleInstances()){

							SCClass scclass = classInstancePort.getSCClass();
							
							SCFunction scfunction = scclass.getMemberFunctionByName(functionName);

							WCMCScopeData parentfcWcmcData = wcmcData.copy();
							WCMCScopeData fcWCMCData = new WCMCScopeData(scfunction.getBody(),0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
							analyzeFunctionParams(scfunction,fcWCMCData);
							fcWCMCData.setWcmcParent(parentfcWcmcData);
							worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(fcWCMCData, classInstancePort);
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
							
							WCMCScopeData parentfcWcmcData = wcmcData.copy();
							WCMCScopeData fcWCMCData = new WCMCScopeData(scfunction.getBody(),0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
							analyzeFunctionParams(scfunction,fcWCMCData);
							fcWCMCData.setWcmcParent(parentfcWcmcData);
							worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(fcWCMCData, classInstancePort);
							return;
														
						}
						
					}
					
				}

			}
			
		}
		
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);

	}
	
	@Override
	public void ifElseExpressionHandler(IfElseExpression expression,
			SCClassInstance currentClassInstance) {
		
		WCMCScopeData thenExpressionParentWCMC = wcmcData.copy();
		WCMCScopeData elseExpressionParentWCMC = wcmcData.copy();
		
		List<Expression> thenExpression = ((IfElseExpression) expression).getThenBlock() ;
		List<Expression> elseExpression = ((IfElseExpression) expression).getElseBlock() ;
		
		//if
		WCMCScopeData thenWcmcData = new WCMCScopeData(thenExpression,0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
		thenWcmcData.getExpressionList().add(0,expression.getCondition());
		thenWcmcData.setWcmcParent(thenExpressionParentWCMC);
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(thenWcmcData, currentClassInstance);
		//else
		
		if(!elseExpression.isEmpty()){
		
			WCMCScopeData elseWcmcData = new WCMCScopeData(elseExpression,0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
			elseWcmcData.getExpressionList().add(0,expression.getCondition());
			elseWcmcData.setWcmcParent(elseExpressionParentWCMC);
			worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(elseWcmcData, currentClassInstance);

		}
		
	}

	@Override
	public void SwitchCaseExpressionHandler(SwitchExpression expression,
			SCClassInstance currentClassInstance) {
		
		
		for(Expression caseExpression: expression.getCases()){

			if(caseExpression instanceof CaseExpression){

				WCMCScopeData caseParentWcmcData = wcmcData.copy();
				List<Expression> body =  ((CaseExpression) caseExpression).getBody();
				WCMCScopeData caseWCMCData = new WCMCScopeData(body,0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
				caseWCMCData.setWcmcParent(caseParentWcmcData);
				worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(caseWCMCData, currentClassInstance);
				
			}

		}
		
	}

	@Override
	public void CaseExpressionHandler(CaseExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void loopExpressionHandler(LoopExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression instanceof WhileLoopExpression){
			
			WCMCScopeData loopParentWcmcData = wcmcData.copy();
			WCMCScopeData loopPassingWcmcData = wcmcData.copy();

			WhileLoopExpression loopExpression = (WhileLoopExpression) expression;
			List<Expression> body = loopExpression.getLoopBody() ;
			
			//loop entry
			WCMCScopeData loopWcmcData = new WCMCScopeData(body,0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
			loopWcmcData.getExpressionList().add(0,loopExpression.getCondition());
			loopWcmcData.setWcmcParent(loopParentWcmcData);
			loopWcmcData.setLoop(true);
			worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(loopWcmcData, currentClassInstance);
			
			//loop passing
			worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(loopPassingWcmcData, currentClassInstance);

		}
		
		if(expression instanceof DoWhileLoopExpression){
			
			WCMCScopeData loopParentWcmcData = wcmcData.copy();
			WCMCScopeData loopPassingWcmcData = wcmcData.copy();

			DoWhileLoopExpression loopExpression = (DoWhileLoopExpression) expression;
			List<Expression> body = loopExpression.getLoopBody() ;
			
			//loop entry
			WCMCScopeData loopWcmcData = new WCMCScopeData(body,0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
			loopWcmcData.getExpressionList().add(0,loopExpression.getCondition());
			loopWcmcData.setWcmcParent(loopParentWcmcData);
			loopWcmcData.setLoop(true);
			worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(loopWcmcData, currentClassInstance);
			
			//loop passing
			worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(loopPassingWcmcData, currentClassInstance);

		}
		
		if(expression instanceof ForLoopExpression){
			ForLoopExpression fLE = (ForLoopExpression) expression;
			if(fLE.getInitializer() instanceof SCVariableDeclarationExpression){
				SCVariableDeclarationExpression vDE = (SCVariableDeclarationExpression) fLE.getInitializer();

				WCMCScopeData loopParentWcmcData = wcmcData.copy();
				//loop entry
				WCMCScopeData loopWcmcData = new WCMCScopeData(fLE.getLoopBody(),0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
				loopWcmcData.getExpressionList().add(0,vDE);
				loopWcmcData.setWcmcParent(loopParentWcmcData);
				loopWcmcData.setLoop(true);
				worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(loopWcmcData, currentClassInstance);

			}

		}
	}

	@Override
	public void portCallHandler(SCFunction scfunction, SCKnownType knownType,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void portCallHandler(SCFunction scfunction,
			SCClassInstance classInstancePort,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}
	
	@Override
	public void binaryExpressionHandler(BinaryExpression expression,
			SCClassInstance currentClassInstance) {
		Expression left =  expression.getLeft();
		Expression right = expression.getRight();
		String op = expression.getOp();

		//Write
		if(op.equals("=")){

			if(left instanceof SCClassInstanceExpression){

				SCClassInstance classInstance = ((SCClassInstanceExpression) left).getInstance();
				if (right instanceof NewExpression) {
					
					NewExpression ne = (NewExpression) right;
					int memSize = worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(ne.getObjType());
					
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					if(wcmcData.unclosedInstancesContains(classInstance)){
						wcmcData.removeFromUnclosedInstances(classInstance);
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(classInstance);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
					}

					if(wcmcData.unclosedInstancesOfScopeContains(classInstance)){
						wcmcData.removeFromUnclosedInstancesOfScope(classInstance);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}
					
				} else if (right instanceof NewArrayExpression) {
					
					NewArrayExpression nae = (NewArrayExpression) right;
					int multiplicator = worstCaseMemoryConsumptionAnalyzer.exprToInt(nae.getSize());
					int memSize =  multiplicator*worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(nae.getObjType());
					
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					if(wcmcData.unclosedInstancesContains(classInstance)){
						wcmcData.removeFromUnclosedInstances(classInstance);
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(classInstance);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
					}
					
					if(wcmcData.unclosedInstancesOfScopeContains(classInstance)){
						wcmcData.removeFromUnclosedInstancesOfScope(classInstance);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}
					
				}
			}
			
			if(left instanceof SCVariableExpression ){

				if (right instanceof NewExpression) {

					SCVariable scVariable = ((SCVariableExpression) left).getVar();
					LinkedList<SCVariable> list = new LinkedList<SCVariable>();
					list.add(scVariable);
					
					NewExpression ne = (NewExpression) right;
					
					int memSize = worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(ne.getObjType());
					
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);

					if(wcmcData.unclosedInstancesContains(scVariable)){
						wcmcData.removeFromUnclosedInstances(scVariable);
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(scVariable);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
					}
					
					if(wcmcData.unclosedInstancesOfScopeContains(scVariable)){
						wcmcData.removeFromUnclosedInstancesOfScope(scVariable);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}

				} else if (right instanceof NewArrayExpression) {
					
					SCVariable scVariable = ((SCVariableExpression) left).getVar();
					LinkedList<SCVariable> list = new LinkedList<SCVariable>();
					list.add(scVariable);

					NewArrayExpression nae = (NewArrayExpression) right;
					int multiplicator = worstCaseMemoryConsumptionAnalyzer.exprToInt(nae.getSize());
					int memSize =  multiplicator*worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(nae.getObjType());
					
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					
					if(wcmcData.unclosedInstancesContains(scVariable)){
						wcmcData.removeFromUnclosedInstances(scVariable);
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(scVariable);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
					}
					
					if(wcmcData.unclosedInstancesOfScopeContains(scVariable)){
						wcmcData.removeFromUnclosedInstancesOfScope(scVariable);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}
				}

			}

		}
		
	
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void unaryExpressionHandler(UnaryExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void sCVariableExpressionHandler(SCVariableExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void sCVariableDeclarationExpressionHandler(
			SCVariableDeclarationExpression expression,
			SCClassInstance currentClassInstance) {
		
		if(expression.getVariable() instanceof SCClassInstanceExpression){
			
			SCClassInstance classInstance = ((SCClassInstanceExpression) expression.getVariable()).getInstance();
			wcmcData.setMemSize(wcmcData.getMemSize()+worstCaseMemoryConsumptionAnalyzer.analyzeSCVar(classInstance));
			
			if(expression.getFirstInitialValue()!=null){
				Expression right = expression.getFirstInitialValue();
		
				if (right instanceof NewExpression) {
					
					NewExpression ne = (NewExpression) right;
					
					int memSize = worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(ne.getObjType());
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					if(wcmcData.unclosedInstancesContains(classInstance)){
						wcmcData.removeFromUnclosedInstances(classInstance);
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(classInstance);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
					}
					
					if(wcmcData.unclosedInstancesOfScopeContains(classInstance)){
						wcmcData.removeFromUnclosedInstancesOfScope(classInstance);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}
				
				} else if (right instanceof NewArrayExpression) {
						
					NewArrayExpression nae = (NewArrayExpression) right;
					int multiplicator = worstCaseMemoryConsumptionAnalyzer.exprToInt(nae.getSize());
					int memSize =  multiplicator*worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(nae.getObjType());
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					if(wcmcData.unclosedInstancesContains(classInstance)){
						wcmcData.removeFromUnclosedInstances(classInstance);
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(classInstance);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(classInstance,memSize));
					}

					if(wcmcData.unclosedInstancesOfScopeContains(classInstance)){
						wcmcData.removeFromUnclosedInstancesOfScope(classInstance);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(classInstance,memSize));
					}
				
				}
			}

		}
		
		
		if(expression.getVariable() instanceof SCVariableExpression){

			SCVariableExpression left = (SCVariableExpression) expression.getVariable();
			
			SCVariable leftVar = left.getVar();
			wcmcData.setMemSize(wcmcData.getMemSize()+worstCaseMemoryConsumptionAnalyzer.analyzeSCVar(leftVar));
		
			if(expression.getFirstInitialValue()!=null){
				Expression right = expression.getFirstInitialValue();
			
				if (right instanceof NewExpression) {
					
					SCVariable scVariable = ((SCVariableExpression) left).getVar();
					LinkedList<SCVariable> list = new LinkedList<SCVariable>();
					list.add(scVariable);
	
					NewExpression ne = (NewExpression) right;
					
					int memSize = worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(ne.getObjType());
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					if(wcmcData.unclosedInstancesContains(scVariable)){
						wcmcData.removeFromUnclosedInstances(scVariable);
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(scVariable);
					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
					}
					
					if(wcmcData.unclosedInstancesOfScopeContains(scVariable)){
						wcmcData.removeFromUnclosedInstancesOfScope(scVariable);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}
					
				} else if (right instanceof NewArrayExpression) {
						
					SCVariable scVariable = ((SCVariableExpression) left).getVar();
					LinkedList<SCVariable> list = new LinkedList<SCVariable>();
					list.add(scVariable);

					NewArrayExpression nae = (NewArrayExpression) right;
					int multiplicator = worstCaseMemoryConsumptionAnalyzer.exprToInt(nae.getSize());
					int memSize =  multiplicator*worstCaseMemoryConsumptionAnalyzer.getDataTypesToMemorySize().get(nae.getObjType());
					wcmcData.setMemSize(wcmcData.getMemSize()+memSize);
					wcmcData.setDynMemSize(wcmcData.getDynMemSize()+memSize);
					if(wcmcData.unclosedInstancesContains(scVariable)){
						
						wcmcData.removeFromUnclosedInstances(scVariable);
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
						wcmcData.getPossibleMemoryLeakVars().add(scVariable);

					}else{
						wcmcData.getUnclosedInstances().add(new WCMCVar(scVariable,memSize));
					}
				
					if(wcmcData.unclosedInstancesOfScopeContains(scVariable)){
						wcmcData.removeFromUnclosedInstancesOfScope(scVariable);
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}else{
						wcmcData.getUnclosedInstancesInScope().add(new WCMCVar(scVariable,memSize));
					}

				}
			}
			
		}
				
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void eventNotificationExpressionHandler(
			EventNotificationExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void functionCallExpressionHandler(
			FunctionCallExpression expression,
			SCClassInstance currentClassInstance) {
		
		WCMCScopeData parentfcWcmcData = wcmcData.copy();
		WCMCScopeData fcWCMCData = new WCMCScopeData(((FunctionCallExpression) expression).getFunction().getBody(),0,wcmcData.getProcessType(),wcmcData.copyUnclosedInstances()).copy();
		analyzeFunctionParams(((FunctionCallExpression) expression).getFunction(),fcWCMCData);
		fcWCMCData.setWcmcParent(parentfcWcmcData);
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(fcWCMCData, currentClassInstance);
		
	}

	@Override
	public void sCPortSCSocketExpressionHandler(
			SCPortSCSocketExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void refDerefExpressionHandler(RefDerefExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void newExpressionExpressionHandler(NewExpression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void newArrayExpressionExpressionHandler(
			NewArrayExpression expression, SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void deleteExpressionExpressionHandler(DeleteExpression expression,
			SCClassInstance currentClassInstance) {

		//in case of a thread: pointer could be assigned newly. it is not safe to subtract from memSize.
		if(wcmcData.getProcessType()==SCPROCESSTYPE.SCMETHOD){

			if(expression.getVarToDeleteExpr() instanceof SCVariableExpression){
	
				SCVariableExpression eVar = (SCVariableExpression) expression.getVarToDeleteExpr();
				
				SCVariable scVariable =  eVar.getVar();
				
				for(WCMCVar wcmcVar : wcmcData.getUnclosedInstances()){
					if(wcmcVar.getVar()==scVariable){
						wcmcData.getUnclosedInstances().remove(wcmcVar);
						wcmcData.setMemSize(wcmcData.getMemSize()-wcmcVar.getMemSize());
						wcmcData.setDynMemSize(wcmcData.getDynMemSize()-wcmcVar.getMemSize());
						break;
					}
				}

			}

		}	
			
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void deleteArrayExpressionExpressionHandler(
			DeleteArrayExpression expression,
			SCClassInstance currentClassInstance) {
		
		//in case of a thread: pointer could be assigned newly. it is not safe to subtract from memSize.
		if(wcmcData.getProcessType()==SCPROCESSTYPE.SCMETHOD){
			
			if(expression.getVarToDeleteExpr() instanceof SCVariableExpression){
	
				SCVariableExpression eVar = (SCVariableExpression) expression.getVarToDeleteExpr();
				
				SCVariable scVariable =  eVar.getVar();
				
				for(WCMCVar wcmcVar : wcmcData.getUnclosedInstances()){
					if(wcmcVar.getVar()==scVariable){
						wcmcData.getUnclosedInstances().remove(wcmcVar);
						wcmcData.setMemSize(wcmcData.getMemSize()-wcmcVar.getMemSize());
						wcmcData.setDynMemSize(wcmcData.getDynMemSize()-wcmcVar.getMemSize());
						break;
					}
				}
				
	
			}
		
		}
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

	@Override
	public void elseHandler(Expression expression,
			SCClassInstance currentClassInstance) {
		worstCaseMemoryConsumptionAnalyzer.analyzeWCMCdata(wcmcData, currentClassInstance);
		
	}

}
