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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;

/**
 * 
 * @author Björn Beckmann
 *
 */
public abstract class DRASCData {

	private static Logger logger = LogManager
			.getLogger(AtomicBlock.class.getName());
	
	/**
	 *  classInstance this object belongs to directly
	 */
	private SCClassInstance classInstance;
	
	/**
	 * 	atomic block this object belongs to
	 */
	private AtomicBlock atomicBlock;
	
	/**
	 * list of all conditions on the path from the wait-statement of the current atomic block to this object
	 */
	private List<Expression> conditionList;

	/**
	 * list of all written variables on the path from this data-object back to the wait-statements of the current atomic block
	 */
	private List<SCVariable> editList;
	
	/**
	 * 
	 */
	private boolean hasParent;
	
	/**
	 * 
	 */
	private List<SCVariable> parents;
	
	public DRASCData(AtomicBlock atomicBlock, SCClassInstance classInstance) {
		setClassInstance(classInstance);
		this.setConditionList(new LinkedList<Expression>());
		this.setEditList(new LinkedList<SCVariable>());
		this.setAtomicBlock(atomicBlock);
		this.hasParent=false;
		this.parents=null;
	}

	public DRASCData(AtomicBlock atomicBlock, SCClassInstance classInstance, boolean hasParent, List<SCVariable> parents) {
		setClassInstance(classInstance);
		this.setConditionList(new LinkedList<Expression>());
		this.setEditList(new LinkedList<SCVariable>());
		this.setAtomicBlock(atomicBlock);
		this.hasParent=hasParent;
		this.parents=parents;
	}

	public SCClassInstance getClassInstance() {
		return classInstance;
	}

	public void setClassInstance(SCClassInstance classInstance) {
		this.classInstance = classInstance;
	}
	
	public String toString(){
		
		
		String ret = "	Condition List:\n";
		for(Expression expression: getConditionList()){
			ret+= "	"+expression.toString()+"\n";
		}
		ret += "	Edit List:\n";
		for(SCVariable scVariable: getEditList()){
			ret+= "	"+scVariable.toString()+"\n";
		}
		return ret;
	}
		
	/**
	 * analyze parent expression of @param expression
	 * @param expression
	 * @param currentClassInstance
	 */
	public void analyzeParentExpression(Expression expression, SCClassInstance currentClassInstance){
		
		Expression parentExpression = expression.getParent();
	
		if(parentExpression==null){
			
			if((expression instanceof FunctionCallExpression)){
				if(((FunctionCallExpression) expression).getFunction().getName().equals(atomicBlock.getProcess().getFunction().getName())){
				}else{
					System.out.println("Error: Parent is null and did not reached highest level of Module (1) - DRASCData backward - "+atomicBlock.getProcess().getName());
				}
			}else{
				System.out.println("Error: Parent is null and did not reached highest level of Module (2) - DRASCData backward - "+atomicBlock.getProcess().getName()+" "+
						atomicBlock.getProcess().getType());
			}

		}else{
					
				DRAExpressionAnalyzer draEA = new DRAExpressionAnalyzer(new DRASCDataParentExpressionHandler(this));
	
				DRASCDataParentExpressionHandler dDPEH = (DRASCDataParentExpressionHandler) draEA.expressionHandler;
				
				dDPEH.setCurrentExpression(expression);
	
				draEA.analyzeExpression(parentExpression, currentClassInstance);
				
				
		} // parentExpression!=null
			
	}
	
	/**
	 * analyze parent expression of @param expression
	 * @param expression
	 * @param currentClassInstance
	 */
	public void analyzeParentForwardExpression(Expression expression, SCClassInstance currentClassInstance){
		
		Expression parentExpression = expression.getParent();
		
		if(parentExpression==null){
			
			//reached highest Level
			
			if((expression instanceof FunctionCallExpression)){
				if(((FunctionCallExpression) expression).getFunction().getName().equals(atomicBlock.getProcess().getFunction().getName())){
				}else{
					System.out.println("Error: Parent is null and did not reached highest level of Module (1) - DRASCData forward - "+atomicBlock.getProcess().getName());
				}
			}else{
				System.out.println("Error: Parent is null and did not reached highest level of Module (2) - DRASCData forward - "+atomicBlock.getProcess().getName());
			}

		}else{

			DRAExpressionAnalyzer dEA = new DRAExpressionAnalyzer(new DRASCDataParentForwardExpressionHandler(this));
			
			DRASCDataParentForwardExpressionHandler dDPFEH = (DRASCDataParentForwardExpressionHandler) dEA.expressionHandler;
			
			dDPFEH.setCurrentExpression(expression);

			dEA.analyzeExpression(parentExpression, currentClassInstance);
			
			
		} // parentExpression!=null
			
	}

	
	/**
	 * 	 backward analyze expressions of list @param list
	 *
	 * @param list
	 * @param currentClassInstance
	 * @param parentExpression
	 */
	public void analyze(List<Expression> list, SCClassInstance currentClassInstance, Expression parentExpression) {
	
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRASCDataWaitExpressionHandler(this));
		DRASCDataWaitExpressionHandler aBWEH = ((DRASCDataWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(int i=list.size()-1; i>=0; i--){
			
			Expression expression = list.get(i);

			DRAExpressionAnalyzer dAFEH = new DRAExpressionAnalyzer(new DRASCDataAnalyzeExpressionHandler(this));

			wMEA.analyzeExpression(expression, currentClassInstance);

			dAFEH.analyzeExpression(expression, currentClassInstance);

			if(aBWEH.isWaitOccurance()){
				return;
			}

			if(expression instanceof FunctionCallExpression){
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return;
				}
			}

		}
		
		analyzeParentExpression(parentExpression, currentClassInstance);

	}

	/**
	 * 	 backward analyze expressions of list @param list
	 *
	 * @param list
	 * @param currentClassInstance
	 */
	public void analyze(List<Expression> list, SCClassInstance currentClassInstance) {
	
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRASCDataWaitExpressionHandler(this));
		DRASCDataWaitExpressionHandler aBWEH = ((DRASCDataWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(int i=list.size()-1; i>=0; i--){
			
			Expression expression = list.get(i);
			
			DRAExpressionAnalyzer dAFEH = new DRAExpressionAnalyzer(new DRASCDataAnalyzeExpressionHandler(this));

			wMEA.analyzeExpression(expression, currentClassInstance);

			dAFEH.analyzeExpression(expression, currentClassInstance);

			if(aBWEH.isWaitOccurance()){
				return;
			}
			
			if(expression instanceof FunctionCallExpression){
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return;
				}
			}

		}
		
	}
	
	/**
	 * analyze expressions of list @param list
	 * @param list
	 * @param currentClassInstance
	 * @param parentExpression
	 */
	public void analyzeForward(List<Expression> list, SCClassInstance currentClassInstance, Expression parentExpression) {
	
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRAWaitExpressionHandler(this.getAtomicBlock()));
		DRAWaitExpressionHandler aBWEH = ((DRAWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(Expression expression : list){
		
			DRAExpressionAnalyzer dAFEH = new DRAExpressionAnalyzer(new DRASCDataAnalyzeForwardExpressionHandler(this));
			
			dAFEH.analyzeExpression(expression, currentClassInstance);
			
			wMEA.analyzeExpression(expression, currentClassInstance);

			if(aBWEH.isWaitOccurance()){
				return;
			}

			if(expression instanceof FunctionCallExpression){
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return;
				}
			}
			
		}

		analyzeParentForwardExpression(parentExpression,currentClassInstance);
		
	}

	/**
	 * analyze expressions of list @param list
	 * @param list
	 * @param currentClassInstance
	 */
	public void analyzeForward(List<Expression> list, SCClassInstance currentClassInstance) {
	
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRAWaitExpressionHandler(this.getAtomicBlock()));
		DRAWaitExpressionHandler aBWEH = ((DRAWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(Expression expression : list){
		
			DRAExpressionAnalyzer dAFEH = new DRAExpressionAnalyzer(new DRASCDataAnalyzeForwardExpressionHandler(this));
			
			dAFEH.analyzeExpression(expression, currentClassInstance);

			wMEA.analyzeExpression(expression, currentClassInstance);

			if(aBWEH.isWaitOccurance()){
				return;
			}

			if(expression instanceof FunctionCallExpression){
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return;
				}
			}
			
		}
		
	}

	
	/**
	 * traverses deeply list @param list and checks whether there exists a Wait-Statement in @param list	
	 * @param list
	 * @param currentClassInstance
	 * @return
	*/	
	public boolean checkDeeplyExpressionListForWaitStatement(List<Expression> list, SCClassInstance currentClassInstance) {
		
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRASCDataWaitExpressionHandler(this));
		DRASCDataWaitExpressionHandler aBWEH = ((DRASCDataWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(int i=list.size()-1; i>=0; i--){
			
			Expression expression = list.get(i);

			if(expression instanceof FunctionCallExpression){
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return true;
				}
			}
			
			wMEA.analyzeExpression(expression, currentClassInstance);
			
		}
		
		return aBWEH.isWaitOccurance();
		
	}	
	
	public void checkAccessExpression(AccessExpression aE, SCClassInstance currentClassInstance, List<SCVariable> list){
		
		Expression left = aE.getLeft();
		Expression right = aE.getRight();
		
		//case ab->cd->ef
		Expression tempLeft = aE.getLeft();

		while(tempLeft instanceof AccessExpression){
			AccessExpression tempAE = (AccessExpression) tempLeft;
			left = tempAE.getLeft();
			tempLeft = tempAE.getRight();
		}
		
		if(left instanceof SCVariableExpression && right instanceof SCVariableExpression){

			SCVariable rightVariable =  ((SCVariableExpression) right).getVar();
			
			list.add(rightVariable);

		}
	
	}

	
	public List<Expression> getConditionList() {
		return conditionList;
	}

	public void setConditionList(List<Expression> conditionList) {
		this.conditionList = conditionList;
	}

	public AtomicBlock getAtomicBlock() {
		return atomicBlock;
	}

	public void setAtomicBlock(AtomicBlock atomicBlock) {
		this.atomicBlock = atomicBlock;
	}

	public List<SCVariable> getEditList() {
		return editList;
	}

	public void setEditList(List<SCVariable> editList) {
		this.editList = editList;
	}

	public boolean isHasParent() {
		return hasParent;
	}

	public void setHasParent(boolean hasParent) {
		this.hasParent = hasParent;
	}

	public List<SCVariable> getParents() {
		return parents;
	}

	public void setParents(List<SCVariable> parents) {
		this.parents = parents;
	}	
	
}
