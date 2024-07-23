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

import de.tub.pes.syscir.sc_model.SCPROCESSTYPE;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.Expression;

public class WCMCScopeData {
	
	/**
	 * remaining body of current scope
	 */
	private List<Expression> expressionList;
	
	/**
	 * currently used memory size of scope
	 */
	private int memSize;
	
	/**
	 * biggest observed memory size usage of scope
	 */
	private int biggestMemSize;
	
	/**
	 * currently, dynamically allocated memory size
	 */
	private int dynMemSize;
	
	/**
	 * parent scope 
	 */
	private WCMCScopeData wcmcParent;
	
	/**
	 * process type of process 
	 */
	private SCPROCESSTYPE processType;
	
	/**
	 * currently unclosed instances of process
	 */
	private List<WCMCVar> unclosedInstances;
	
	/**
	 * currently unclosed instances of scope
	 */
	private List<WCMCVar> unclosedInstancesInScope;

	/**
	 * possible memory leaks of scope
	 */
	private List<SCVariable> possibleMemoryLeakVars;
	

	/**
	 * true if scope is a loop
	 */
	private boolean loop;

	public WCMCScopeData(List<Expression> expressionList, int memSize){
		this.setExpressionList(expressionList);
		this.setWcmcParent(null);
		this.setMemSize(memSize);
		this.setBiggestMemSize(0);
		this.setDynMemSize(0);
		this.unclosedInstances=new LinkedList<WCMCVar>();
		this.unclosedInstancesInScope=new LinkedList<WCMCVar>();
		this.possibleMemoryLeakVars=new LinkedList<SCVariable>();
		this.setLoop(false);
	}
	
	public WCMCScopeData(List<Expression> expressionList, int memSize, SCPROCESSTYPE processType){
		this.setExpressionList(expressionList);
		this.setWcmcParent(null);
		this.setMemSize(memSize);
		this.setBiggestMemSize(0);
		this.setDynMemSize(0);
		this.unclosedInstances=new LinkedList<WCMCVar>();
		this.unclosedInstancesInScope=new LinkedList<WCMCVar>();
		this.possibleMemoryLeakVars=new LinkedList<SCVariable>();
		this.setLoop(false);
		this.processType=processType;
	}
	
	public WCMCScopeData(List<Expression> expressionList, int memSize, SCPROCESSTYPE processType, List<WCMCVar> unclosedInstances){
		this.setExpressionList(expressionList);
		this.setWcmcParent(null);
		this.setMemSize(memSize);
		this.setBiggestMemSize(0);
		this.setDynMemSize(0);
		this.unclosedInstances=unclosedInstances;
		this.unclosedInstancesInScope=new LinkedList<WCMCVar>();
		this.possibleMemoryLeakVars=new LinkedList<SCVariable>();
		this.setLoop(false);
		this.processType=processType;
	}

	public WCMCScopeData() {
		this.setExpressionList(new LinkedList<Expression>());
		this.setWcmcParent(null);
		this.setMemSize(0);
		this.setBiggestMemSize(0);
		this.setDynMemSize(0);
		this.unclosedInstances=new LinkedList<WCMCVar>();
		this.unclosedInstancesInScope=new LinkedList<WCMCVar>();
		this.possibleMemoryLeakVars=new LinkedList<SCVariable>();
		this.setLoop(false);
	}

	public WCMCScopeData copy(){
		
		WCMCScopeData copy = new WCMCScopeData();
		
		for(Expression e : this.getExpressionList()){
			copy.getExpressionList().add(e);
		}

		copy.setMemSize(this.getMemSize());
		copy.setBiggestMemSize(this.getBiggestMemSize());
		copy.setDynMemSize(this.getDynMemSize());
		
		if(this.getWcmcParent()!=null){
			copy.setWcmcParent(this.getWcmcParent().copy());
		}

		for(WCMCVar v : this.getUnclosedInstances()){
			copy.getUnclosedInstances().add(v);
		}

		for(WCMCVar v : getUnclosedInstancesInScope()){
			copy.getUnclosedInstancesInScope().add(v);
		}

		for(SCVariable v : this.getPossibleMemoryLeakVars()){
			copy.getPossibleMemoryLeakVars().add(v);
			
		}
		
		copy.setProcessType(getProcessType());

		copy.setLoop(this.isLoop());
		
		return copy;
		
	}
	
	public boolean hasParent(){
		if(this.getWcmcParent()!=null){
			return true;
		}else{
			return false;
		}
	}

	public int getMemSize() {
		return memSize;
	}

	public void setMemSize(int memSize) {
		if(memSize>getBiggestMemSize()){
			setBiggestMemSize(memSize);
		}

		this.memSize = memSize;
	}
	
	public List<WCMCVar> copyUnclosedInstances(){
		
		LinkedList<WCMCVar> copyList= new LinkedList<WCMCVar>();
		
		for(WCMCVar wcmcVar : this.getUnclosedInstances()){
			WCMCVar copy = new WCMCVar(wcmcVar.getVar(),wcmcVar.getMemSize());
			copyList.add(copy);
		}
		return copyList;
	}
	
	public List<Expression> getExpressionList() {
		return expressionList;
	}

	public void setExpressionList(List<Expression> expressionList) {
		this.expressionList = expressionList;
	}

	public WCMCScopeData getWcmcParent() {
		return wcmcParent;
	}

	public void setWcmcParent(WCMCScopeData wcmcParent) {
		this.wcmcParent = wcmcParent;
	}

	public int getBiggestMemSize() {
		return biggestMemSize;
	}

	public void setBiggestMemSize(int biggestMemSize) {
		this.biggestMemSize = biggestMemSize;
	}

	public int getDynMemSize() {
		return dynMemSize;
	}

	public void setDynMemSize(int dynMemSize) {
		this.dynMemSize = dynMemSize;
	}

	public List<WCMCVar> getUnclosedInstances() {
		return unclosedInstances;
	}

	public void setUnclosedInstances(List<WCMCVar> unclosedInstances) {
		this.unclosedInstances = unclosedInstances;
	}

	public List<SCVariable> getPossibleMemoryLeakVars() {
		return possibleMemoryLeakVars;
	}

	public void setPossibleMemoryLeakVars(List<SCVariable> possibleMemoryLeakVars) {
		this.possibleMemoryLeakVars = possibleMemoryLeakVars;
	}
	
	public boolean unclosedInstancesContains(SCVariable scVar){
		
		for(WCMCVar wcmcVar : this.getUnclosedInstances()){
			if(wcmcVar.getVar()==scVar){
				return true;
			}
		}
		return false;
		
	}

	public boolean unclosedInstancesOfScopeContains(SCVariable scVar){
		
		for(WCMCVar wcmcVar : this.getUnclosedInstancesInScope()){
			if(wcmcVar.getVar()==scVar){
				return true;
			}
		}
		return false;
		
	}

	public void removeFromUnclosedInstances(SCVariable scVariable) {
		for(WCMCVar wcmcVar : this.getUnclosedInstances()){
			if(wcmcVar.getVar()==scVariable){
				this.getUnclosedInstances().remove(wcmcVar);
				return;
			}
		}
		
	}

	public void removeFromUnclosedInstancesOfScope(SCVariable scVariable) {
		for(WCMCVar wcmcVar : this.getUnclosedInstancesInScope()){
			if(wcmcVar.getVar()==scVariable){
				this.getUnclosedInstancesInScope().remove(wcmcVar);
				return;
			}
		}
		
	}

	public boolean isLoop() {
		return loop;
	}

	public void setLoop(boolean loop) {
		this.loop = loop;
	}

	public SCPROCESSTYPE getProcessType() {
		return processType;
	}

	public void setProcessType(SCPROCESSTYPE processType) {
		this.processType = processType;
	}

	public List<WCMCVar> getUnclosedInstancesInScope() {
		return unclosedInstancesInScope;
	}

	public void setUnclosedInstancesInScope(List<WCMCVar> unclosedInstancesInScope) {
		this.unclosedInstancesInScope = unclosedInstancesInScope;
	}
	
}
