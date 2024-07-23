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

import de.tub.pes.syscir.engine.util.MutableInteger;
import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCParameter;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.ArrayAccessExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCEvent;

/**
 * 
 * @author Björn Beckmann
 *
 */
public class AtomicBlock {
	
	
	private static Logger logger = LogManager
			.getLogger(AtomicBlock.class.getName());
	
	/**
	 * wait Expression of this atomic block
	 */
	private Expression expression;

	/**
	 * unique ID of this atomic block
	 */
	private MutableInteger atomicBlockNumber;
	private int offset = 0;
	
	/**
	*  top level module instance of the SysCIR-Model where this atomic block is part of
	 */
	private SCClassInstance topLevelClassInstance;

	/**
	 *  process of a top level module instance of the SysCIR-Model where this atomic block is part of
	 */
	private SCProcess process;
	
	/**
	 * module instance where the atomic block is directly part of
	 */
	private SCClassInstance waitLevelClassInstance;
	
	/**
	 *  list of all global variables that are written by this atomic block
	 */
	private List<DRASCVariable> globalVariableRead;
	
	/**
	 *  list of all global variables that are read by this atomic block
	 */
	private List<DRASCVariable> globalVariableWrite;

	/**
	 *  list of all global Events this atomic block is waiting for
	 */
	private List<DRASCEvent> waitSCEvent;

	/**
	 *  list of all global Events this atomic block notifies
	 */
	private List<DRASCEvent> notifySCEvent;

	/**
	 *  current SysCIR Model
	 */
	private SCSystem scs;
	
	/**
	 * 	true, if process uses dont_initialize
	 */
	private boolean process_no_init;
	
	/**
	 *  current Data Race Analyzer
	 */
	private DataRaceAnalyzer dra;
	
	/**
	 * parent Expression of wait Expression, 
	 * only if waitExpression is null
	 */
	private Expression waitParentExpression;
	
	/**
	 * 
	 * @param expression
	 * @param classInstance
	 * @param process
	 * @param currentClassInstance
	 * @param scs
	 * @param dra
	 */
	public AtomicBlock(Expression expression, SCClassInstance classInstance, SCProcess process, SCClassInstance currentClassInstance, SCSystem scs,DataRaceAnalyzer dra){
		this.setExpression(expression);
		this.topLevelClassInstance=classInstance;
		this.process=process;
		this.waitLevelClassInstance=currentClassInstance;
		this.setGlobalVariableRead(new LinkedList<DRASCVariable>());
		this.setGlobalVariableWrite(new LinkedList<DRASCVariable>());
		this.waitSCEvent = new LinkedList<DRASCEvent>();
		this.notifySCEvent = new LinkedList<DRASCEvent>();
		this.setScs(scs);
		this.setProcessNoInit(true);
		this.setDra(dra);
	}
	
	public AtomicBlock(Expression expression,SCClassInstance classInstance, SCProcess process, SCSystem scs,DataRaceAnalyzer dra) {
		this.setExpression(null);
		this.setpE(expression);
		this.topLevelClassInstance=classInstance;
		this.process=process;
		this.waitLevelClassInstance=classInstance;
		this.setGlobalVariableRead(new LinkedList<DRASCVariable>());
		this.setGlobalVariableWrite(new LinkedList<DRASCVariable>());
		this.waitSCEvent = new LinkedList<DRASCEvent>();
		this.notifySCEvent = new LinkedList<DRASCEvent>();
		this.setScs(scs);
		this.setProcessNoInit(true);
		this.setDra(dra);
	}
	


	/**
	 * copy constructor
	 * @param ab AtomicBlock to copy
	 */
	public AtomicBlock(AtomicBlock ab) {
		super();
		this.expression = ab.expression;
		this.atomicBlockNumber = ab.atomicBlockNumber;
		this.topLevelClassInstance = ab.topLevelClassInstance;
		this.process = ab.process;
		this.waitLevelClassInstance = ab.waitLevelClassInstance;
		this.globalVariableRead = ab.globalVariableRead;
		this.globalVariableWrite = ab.globalVariableWrite;
		this.waitSCEvent = ab.waitSCEvent;
		this.notifySCEvent = ab.notifySCEvent;
		this.scs = ab.scs;
		this.process_no_init = ab.process_no_init;
		this.dra = ab.dra;
		this.waitParentExpression = ab.waitParentExpression;
	}

	public void analyzeAtomicBlock(){
		
		analyzeParentExpression(this.getExpression(), this.waitLevelClassInstance);
		
		checkMethodSensitivEvents();
		
	}
	
	private void checkMethodSensitivEvents() {
		
		if(expression!=null){
			if(expression instanceof FunctionCallExpression){
				SCFunction function = ((FunctionCallExpression) expression).getFunction();
				
				for(SCParameter parameter : function.getParameters()){
					if(parameter.getVar() instanceof SCEvent){
						if(!this.draSCEventListContains(this.getWaitSCEvent(),((SCEvent) parameter.getVar()))){
							DRASCEvent event = new DRASCEvent(this,this.getWaitLevelClassInstance());
							event.setEvent((SCEvent) parameter.getVar());
							event.analyzeParentExpression(expression, this.getWaitLevelClassInstance());
							event.analyzeParentForwardExpression(expression, this.getWaitLevelClassInstance());
							this.getWaitSCEvent().add(event);
						}
					}
				}
				
			}
		}


		for(SCEvent event : process.getSensitivity()){
				
				if(!draSCEventListContains(getWaitSCEvent(),event)){
					DRASCEvent draSCEvent = new DRASCEvent(this,topLevelClassInstance);
					draSCEvent.setEvent(event);
					getWaitSCEvent().add(draSCEvent);
				}

			}

	}

	public String toString(boolean conditionList){
		String ret = 	"Atomic Block: "+topLevelClassInstance.getName()+
						" Prozess: "+process.getName()+
						" Expression: "+this.getExpression()+" Wait-ClassInstance: "+this.getWaitLevelClassInstance().getName()+" Top-ClassInstance: "+this.getTopLevelClassInstance().getName()+"\n";
		ret+="AtomicBlockNumber:"+atomicBlockNumber+"\n";
		ret+="Read Global Variable:\n";
		for(DRASCVariable var : this.getGlobalVariableRead()){
			ret+="	"+var.getVariable().toString()+" ClassInstance: "+var.getClassInstance().getName()+"\n";
			if(conditionList)
				ret+=var.toString();
		}
		ret+="Write Global Variable:\n";
		for(DRASCVariable var : this.getGlobalVariableWrite()){
			ret+="	"+var.getVariable().toString()+" ClassInstance: "+var.getClassInstance().getName()+"\n";
			if(conditionList)
				ret+=var.toString();
		}
		ret+="Wait Global Event:\n";
		for(DRASCEvent event : this.getWaitSCEvent()){
			ret+="	"+event.getEvent().toString()+" ClassInstance: "+event.getClassInstance().getName()+"\n";
			if(conditionList)
				ret+=event.toString();
		}
		ret+="Notify Global Event:\n";
		for(DRASCEvent event : this.getNotifySCEvent()){
			ret+="	"+event.getEvent().toString()+" ClassInstance: "+event.getClassInstance().getName()+"\n";
			if(conditionList)
				ret+=event.toString();
		}
		
		return ret;
	}
	
	public boolean draSCVariableListContains(List<DRASCVariable> list,SCVariable scVariable){
		for(DRASCVariable draSCVariable : list){
			if(draSCVariable.getVariable()==scVariable)
				return true;
		}
		return false;
	}

	public DRASCVariable getDRASCVariable(List<DRASCVariable> list,SCVariable scVariable){
		for(DRASCVariable draSCVariable : list){
			if(draSCVariable.getVariable()==scVariable)
				return draSCVariable;
		}
		return null;
	}

	public boolean draSCEventListContains(List<DRASCEvent> list, SCEvent scEvent){
		for(DRASCEvent draSCEvent : list){
			if(draSCEvent.getEvent()==scEvent)
				return true;
		}
		return false;
	}

	public DRASCEvent getDRASCEvent(List<DRASCEvent> list, SCEvent scEvent){
		for(DRASCEvent draSCEvent : list){
			if(draSCEvent.getEvent()==scEvent)
				return draSCEvent;
		}
		return null;
	}
	
	public void checkGlobalVar(Expression exp, List<DRASCVariable> list, SCVariable scVariable, SCClassInstance currentClassInstance, Expression valueExpression){

		if(currentClassInstance.getSCClass().getMembers().contains(scVariable)){
			if(!draSCVariableListContains(list,scVariable)){
				DRASCVariable var = new DRASCVariable(this,currentClassInstance);
				var.setVariable(scVariable);
				var.checkValueExpression(valueExpression);
				var.analyzeParentExpression(exp, currentClassInstance);
				var.analyzeParentForwardExpression(exp, currentClassInstance);
				list.add(var);
			}else{
				DRASCVariable var = getDRASCVariable(list, scVariable);
				var.checkValueExpression(valueExpression);
			}

		}
		checkPointerConnection(exp, list, scVariable, currentClassInstance);
	}
	
	public void checkGlobalVar(Expression exp, List<DRASCVariable> list, SCVariable scVariable, SCClassInstance currentClassInstance){

		if(currentClassInstance.getSCClass().getMembers().contains(scVariable)){
			if(!draSCVariableListContains(list,scVariable)){
				DRASCVariable var = new DRASCVariable(this,currentClassInstance);
				var.setVariable(scVariable);
				var.setSymmWritePossible(false);
				var.analyzeParentExpression(exp, currentClassInstance);
				var.analyzeParentForwardExpression(exp, currentClassInstance);
				list.add(var);
			}
		}
		checkPointerConnection(exp, list, scVariable, currentClassInstance);
	}

	private void checkPointerConnection(Expression exp, List<DRASCVariable> list, SCVariable scVariable, SCClassInstance currentClassInstance) {
		
		for(DRAPointerConnection draPC : dra.getPossiblePointerConnection()){
			
			if(scVariable==draPC.getVar() && currentClassInstance==draPC.getClassInstance()){
				
				if(!draSCVariableListContains(list,scVariable)){
					DRASCVariable var = new DRASCVariable(this,currentClassInstance);
					var.setVariable(scVariable);
					list.add(var);
					//TODO: 
					//-editList und conditionList aufbauen
				}
				
				for(Pair<SCVariable, SCClassInstance> pair : draPC.getPointerConnections()){
					
						if(!draSCVariableListContains(list,pair.getFirst())){
							DRASCVariable var = new DRASCVariable(this,pair.getSecond());
							var.setVariable(pair.getFirst());
							list.add(var);
							//TODO: 
							//-editList und conditionList aufbauen
							checkPointerConnection(exp, list, pair.getFirst(), pair.getSecond());
						}
					
				}
				
			}
			
		}
	}

	public void checkAccessExpression(AccessExpression aE, SCClassInstance currentClassInstance, List<DRASCVariable> list){
		
		Expression right = aE.getRight();

		//case ab->cd->ef
		Expression tempLeft = aE.getLeft();
		
		tempLeft.setParent(aE);
		right.setParent(aE);

		List<SCVariable> parents = new LinkedList<SCVariable>();
		
		while(tempLeft instanceof AccessExpression){
			AccessExpression tempAE = (AccessExpression) tempLeft;
			tempLeft = tempAE.getLeft();
			tempLeft.setParent(tempAE);
			if(tempAE.getRight() instanceof SCVariableExpression){
				((SCVariableExpression) tempAE.getRight()).setParent(tempAE);
				checkPointerConnection(tempAE.getRight(),list,((SCVariableExpression) tempAE.getRight()).getVar(),currentClassInstance);
				parents.add(((SCVariableExpression) tempAE.getRight()).getVar());
			}
		}

		if(tempLeft instanceof SCVariableExpression && right instanceof SCVariableExpression){
			
			SCVariable leftVariable =  ((SCVariableExpression) tempLeft).getVar();
			
			parents.add(leftVariable);
			
			SCVariable rightVariable =  ((SCVariableExpression) right).getVar();

			if(currentClassInstance.getSCClass().getMembers().contains(leftVariable)){
			
				if(!draSCVariableListContains(list,rightVariable)){
					DRASCVariable var = new DRASCVariable(this, currentClassInstance, true, parents);
					var.setVariable(rightVariable);
					var.analyzeParentExpression(aE, currentClassInstance);
					var.analyzeParentForwardExpression(aE, currentClassInstance);
					list.add(var);
				}
					
			}
			
			if(right instanceof ArrayAccessExpression){
				
				ArrayAccessExpression aAE = (ArrayAccessExpression) right;
				analyze(aAE.getAccess(), currentClassInstance, right);
			}

		}
	
	}

	/**
	 * checks deeply whether there exists a Wait-Statement in @param list	
	 * @param list
	 * @param currentClassInstance
	 * @return
	*/	
	public boolean checkDeeplyExpressionListForWaitStatement(List<Expression> list, SCClassInstance currentClassInstance) {
		
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRAWaitExpressionHandler(this));
		DRAWaitExpressionHandler aBWEH = ((DRAWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);
		
		for(Expression expression : list){
			
			if(expression instanceof FunctionCallExpression){
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return true;
				}
			}
			wMEA.analyzeExpression(expression, currentClassInstance);

		}
		
		return aBWEH.isWaitOccurance();
		
	}

	/**
	 * analyses expressions of list @param list
	 * @param list
	 * @param currentClassInstance
	 * @param parentExpression
	 */
	public void analyzeListAndParent(List<Expression> list, SCClassInstance currentClassInstance, Expression parentExpression) {
	
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRAWaitExpressionHandler(this));
		DRAWaitExpressionHandler aBWEH = ((DRAWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(Expression expression : list){
			
			//if(parentExpression!=null)
				expression.setParent(parentExpression);
			
			DRAExpressionAnalyzer pEA = new DRAExpressionAnalyzer(new AtomicBlockAnalyzeExpressionHandler(this));
			
			wMEA.analyzeExpression(expression, currentClassInstance);
			
			pEA.analyzeExpression(expression, currentClassInstance);

			if(aBWEH.isWaitOccurance()){
				return;
			}

			if(expression instanceof FunctionCallExpression){
				
				if(((FunctionCallExpression) expression).getFunction().getName().equals("wait")){
					return;
				}
			}
			
		}

		analyzeParentExpression(parentExpression,currentClassInstance);
		
	}

	/**
	 * analyze expressions of list @param list
	 * @param list
	 * @param currentClassInstance
	 */
	public void analyze(List<Expression> list, SCClassInstance currentClassInstance, Expression parentExpression) {
	
		DRAExpressionAnalyzer wMEA = new DRAExpressionAnalyzer(new DRAWaitExpressionHandler(this));
		DRAWaitExpressionHandler aBWEH = ((DRAWaitExpressionHandler) wMEA.expressionHandler) ;
		aBWEH.setWaitOccurance(false);

		for(Expression expression : list){
			
			//if(parentExpression!=null)
				expression.setParent(parentExpression);

			DRAExpressionAnalyzer pEA = new DRAExpressionAnalyzer(new AtomicBlockAnalyzeExpressionHandler(this));

			wMEA.analyzeExpression(expression, currentClassInstance);
			
			pEA.analyzeExpression(expression, currentClassInstance);

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
	 * analyses parent expression of @param expression
	 * @param expression
	 * @param currentClassInstance
	 */
	public void analyzeParentExpression(Expression expression, SCClassInstance currentClassInstance){
		
		
		// First Atomic Block of a Module
		// reached highest Level
		if(expression==null){
			
			List<Expression> parentList = new LinkedList<Expression>();

			parentList = this.getProcess().getFunction().getBody();
						
			this.analyze(parentList, currentClassInstance, getpE());
						
		}else{

			Expression parentExpression = expression.getParent();
			
			if(parentExpression==null){
				
				//reached highest Level
				
				if((expression instanceof FunctionCallExpression)){
					if(((FunctionCallExpression) expression).getFunction().getName().equals(this.getProcess().getFunction().getName())){
					}else{
						System.out.println("Error: Parent is null and did not reached highest level of Module (1) - AtomicBlock - "+this.getProcess().getName()+" - "+((FunctionCallExpression) expression).getFunction().getName());
					}
				}else{
					System.out.println("Error: Parent is null and did not reached highest level of Module (2) - AtomicBlock - "+this.getProcess().getName());
				}
				

			}else{
				
				//check all Container Expressions
				DRAExpressionAnalyzer pEA = new DRAExpressionAnalyzer(new AtomicBlockParentExpressionHandler(this));
				
				AtomicBlockParentExpressionHandler aBPEH = (AtomicBlockParentExpressionHandler) pEA.expressionHandler;
				
				aBPEH.setCurrentExpression(expression);
				
				pEA.analyzeExpression(parentExpression, currentClassInstance);
								
			} // parentExpression!=null
			
		} //expression!=null	

	}

	
	public void setProcess(SCProcess process){
		this.process = process;
	}

	public SCProcess getProcess(){
		return this.process;
	}

	public List<DRASCVariable> getGlobalVariableWrite() {
		return globalVariableWrite;
	}

	public void setGlobalVariableWrite(List<DRASCVariable> globalVariableWrite) {
		this.globalVariableWrite = globalVariableWrite;
	}

	public List<DRASCVariable> getGlobalVariableRead() {
		return globalVariableRead;
	}

	public void setGlobalVariableRead(List<DRASCVariable> globalVariableRead) {
		this.globalVariableRead = globalVariableRead;
	}

	public List<DRASCEvent> getNotifySCEvent() {
		return notifySCEvent;
	}

	public void setNotifySCEvent(List<DRASCEvent> notifySCEvent) {
		this.notifySCEvent = notifySCEvent;
	}

	public List<DRASCEvent> getWaitSCEvent() {
		return waitSCEvent;
	}

	public void setWaitSCEvent(List<DRASCEvent> waitSCEvent) {
		this.waitSCEvent = waitSCEvent;
	}


	public Expression getExpression() {
		return expression;
	}

	public void setExpression(Expression expression) {
		this.expression = expression;
	}

	public SCClassInstance getWaitLevelClassInstance() {
		return waitLevelClassInstance;
	}

	public void setWaitLevelClassInstance(SCClassInstance waitLevelClassInstance) {
		this.waitLevelClassInstance = waitLevelClassInstance;
	}

	public SCClassInstance getTopLevelClassInstance() {
		return topLevelClassInstance;
	}

	public void setTopLevelClassInstance(SCClassInstance topLevelClassInstance) {
		this.topLevelClassInstance = topLevelClassInstance;
	}

	public SCSystem getScs() {
		return scs;
	}

	public void setScs(SCSystem scs) {
		this.scs = scs;
	}

	public MutableInteger getAtomicBlockNumber() {
		return atomicBlockNumber;
	}

	public void setAtomicBlockNumber(MutableInteger atomicBlockNumber) {
		this.atomicBlockNumber = atomicBlockNumber;
	}
	
	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public boolean isProcessNoInit() {
		return process_no_init;
	}

	public void setProcessNoInit(boolean b) {
		this.process_no_init = b;
	}

	public DataRaceAnalyzer getDra() {
		return dra;
	}

	public void setDra(DataRaceAnalyzer dra) {
		this.dra = dra;
	}

	public Expression getpE() {
		return waitParentExpression;
	}

	public void setpE(Expression pE) {
		this.waitParentExpression = pE;
	}

}
