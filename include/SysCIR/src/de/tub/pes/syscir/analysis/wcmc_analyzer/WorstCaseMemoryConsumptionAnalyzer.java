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

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.analysis.Analyzer;
import de.tub.pes.syscir.analysis.data_race_analyzer.DataRaceAnalyzer;
import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPROCESSTYPE;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.variables.SCArray;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCPointer;

/**
 * 
 * @author Björn Beckmann
 *
 */

public class WorstCaseMemoryConsumptionAnalyzer implements Analyzer {

	private static Logger logger = LogManager
			.getLogger(DataRaceAnalyzer.class.getName());

	/**
	 * wcmc.properties stores the memory size of data types
	 */
	public static String propertiesPath = "../SysCIR/config/properties/wcmc.properties";

	/**
	 * current SysCIR Model
	 */
	private SCSystem scs;
	
	/**
	 * worst case memory consumption (wcmc) of the current SysCIR Model in Bits
	 */
	private Integer worstCaseMemoryConsumption;
	
	/**
	 * wcmc of each Process
	 */
	private List<Integer> processWorstCaseMemoryConsumption;

	/**
	 * wcmc of current path 
	 */
	private int currentPathWorstCaseMemoryConsumption;
	
	/**
	 * stores the size in memory of each data type defined by from wcmc.properties
	 */
	private HashMap<String, Integer> dataTypesToMemorySize;
	
	/**
	 * stores the size in memory of each struct type
	 */
	private HashMap<String, Integer> structs;
	
	/**
	 * unclosed instances of current path
	 */
	private List<WCMCVar> currentPathUnclosedInstances;
	
	/**
	 * possible memory leaks of current path
	 */
	private List<SCVariable> currentPathPossibleMemoryLeakVars;

	/**
	 * possible memory leaks of current path causing by loops
	 */
	private List<SCVariable> currentPathPossibleMemoryLeakVarsByLoop;
	
	/**
	 * data types which are not defined in wcmc.properties
	 */
	private List<String> unknownDatatypes;
	
	@Override
	public void analyze(SCSystem scs) {
		setScs(scs);
		setDataTypesToMemorySize(new HashMap<String,Integer>());
		setStructs(new HashMap<String,Integer>());
		setCurrentPathUnclosedInstances(new LinkedList<WCMCVar>());
		setCurrentPathPossibleMemoryLeakVars(new LinkedList<SCVariable>());
		setCurrentPathPossibleMemoryLeakVarsByLoop(new LinkedList<SCVariable>());
		setProcessWorstCaseMemoryConsumption(new LinkedList<Integer>());
		setUnknownDatatypes(new LinkedList<String>());
		this.worstCaseMemoryConsumption = 0;
		
		//read out the size in memory of each simple type
		readWCMCProperties();
		
		// compute size in memory of each struct of the current systemc model
		computeSizeOfEachStruct();
		
		// adding structs to dataTypesToMemorySize
		for(String key : getStructs().keySet()){
			getDataTypesToMemorySize().put(key,getStructs().get(key));
		}
		
		System.out.println("Datatypes: "+dataTypesToMemorySize+"\n");

		for (SCVariable scvar : scs.getGlobalVariables()) {
			worstCaseMemoryConsumption += analyzeSCVar(scvar);
		}
		
		boolean memLeak=false;
		
		for(SCClassInstance classInstance : scs.getInstances()){
			
			if (classInstance.isSCModule() || classInstance.isSCKnownType() || classInstance.isChannel()) {

				SCClass scClass = classInstance.getSCClass();

				for (SCVariable scvar : scClass.getMembers()) {
					
					worstCaseMemoryConsumption += analyzeSCVar(scvar);
					
				}

				for(SCProcess scProcess : scClass.getProcesses()){
					
					SCFunction scFunction = scProcess.getFunction();
					
					WCMCScopeData wcmcData = new WCMCScopeData(scFunction.getBody(),0,scProcess.getType()).copy();
					
					currentPathWorstCaseMemoryConsumption = 0;
					setCurrentPathUnclosedInstances(new LinkedList<WCMCVar>());
					setCurrentPathPossibleMemoryLeakVars(new LinkedList<SCVariable>());
					setCurrentPathPossibleMemoryLeakVarsByLoop(new LinkedList<SCVariable>());
					
					//depth search of control flow graph from current process
					analyzeWCMCdata(wcmcData, classInstance);
					
					System.out.print("-SCClassInstance: " + classInstance.getName() + ", SCProcess: " + scProcess.getName());
					
					if(((!this.getCurrentPathUnclosedInstances().isEmpty()) && scProcess.getType()==SCPROCESSTYPE.SCMETHOD)
						||
						((!this.getCurrentPathPossibleMemoryLeakVars().isEmpty()) && scProcess.getType()==SCPROCESSTYPE.SCMETHOD)
						||
						(!this.getCurrentPathPossibleMemoryLeakVarsByLoop().isEmpty())
						){
						String s = " -> Possible memory leak: ";
						for(WCMCVar wcmcVar : this.getCurrentPathUnclosedInstances()){
							s+=wcmcVar.getVar().getType()+"* "+wcmcVar.getVar().getName()+", ";
						}
						for(SCVariable var : this.getCurrentPathPossibleMemoryLeakVars()){
							if(!this.unclosedInstancesContains(var)){
								s+=var.getType()+"* "+var.getName()+", ";
							}
						}
						for(SCVariable var : this.getCurrentPathPossibleMemoryLeakVarsByLoop()){
							if(!this.unclosedInstancesContains(var) && !this.getCurrentPathPossibleMemoryLeakVars().contains(var)){
								s+=var.getType()+"* "+var.getName()+", ";
							}
						}
						System.out.println(s.subSequence(0, s.length()-2));
						getProcessWorstCaseMemoryConsumption().add(null);
						memLeak=true;
					}else{
						System.out.println(" -> WCMC: "+currentPathWorstCaseMemoryConsumption);
						getProcessWorstCaseMemoryConsumption().add(currentPathWorstCaseMemoryConsumption);
						worstCaseMemoryConsumption += currentPathWorstCaseMemoryConsumption;
					}
					
				}
			
			}
			
		}
		
		if(memLeak){
			worstCaseMemoryConsumption=null;
			System.out.println("\nWorst Case Memory Consumption of the current SystemC Model: possible Memory Leak \n");
		}else{
			System.out.println("\nWorst Case Memory Consumption of the current SystemC Model: "+worstCaseMemoryConsumption+"\n");
		}
		
		if(this.getUnknownDatatypes().size()>0){
			logger.warn("The result for the WCMC of this model is not sound.");
			for(String type : getUnknownDatatypes()){
				logger.warn("Memory size of data type "+type+" is not defined in wcmc.properties");
			}

		}
		
	}
	
	/**
	 * 
	 * depth search of cfg from current scope
	 * 
	 */
	public void analyzeWCMCdata(WCMCScopeData wcmcData, SCClassInstance currentClassInstance){
		
		
		if(!wcmcData.getExpressionList().isEmpty()){
			
			Expression expression = wcmcData.getExpressionList().get(0);

			wcmcData.getExpressionList().remove(0);
			
			WCMCExpressionAnalyzer eA = new WCMCExpressionAnalyzer(new WCMCAnalysisExpressionHandler(this,wcmcData));

			eA.analyzeExpression(expression, currentClassInstance);
			
			return;
			
		}
		
		if(wcmcData.getExpressionList().isEmpty() && wcmcData.hasParent()){
			
			WCMCScopeData parentWcmcData = wcmcData.getWcmcParent();
			
			if(parentWcmcData.getMemSize()+wcmcData.getBiggestMemSize()>parentWcmcData.getBiggestMemSize()){
				parentWcmcData.setBiggestMemSize(parentWcmcData.getMemSize()+wcmcData.getBiggestMemSize());
			}
			
			parentWcmcData.setMemSize(parentWcmcData.getMemSize()+wcmcData.getDynMemSize());
			parentWcmcData.setDynMemSize(parentWcmcData.getDynMemSize()+wcmcData.getDynMemSize());
			
			parentWcmcData.setUnclosedInstances(wcmcData.getUnclosedInstances());
			
			for(WCMCVar wcmcVar : wcmcData.getUnclosedInstancesInScope()){
				if(!parentWcmcData.unclosedInstancesOfScopeContains(wcmcVar.getVar())){
					parentWcmcData.getUnclosedInstancesInScope().add(wcmcVar);
				}
			}
			
			for(SCVariable scVar : wcmcData.getPossibleMemoryLeakVars()){
				if(!parentWcmcData.getPossibleMemoryLeakVars().contains(scVar)){
					parentWcmcData.getPossibleMemoryLeakVars().add(scVar);
				}
			}
			
			if(wcmcData.isLoop()){
				
				for(WCMCVar wcmcVar : wcmcData.getUnclosedInstancesInScope()){
					if(!this.getCurrentPathPossibleMemoryLeakVarsByLoop().contains(wcmcVar.getVar())){
						this.getCurrentPathPossibleMemoryLeakVarsByLoop().add(wcmcVar.getVar());
					}
				}
					
				for(SCVariable scVar : wcmcData.getPossibleMemoryLeakVars()){
					if(!this.getCurrentPathPossibleMemoryLeakVarsByLoop().contains(scVar)){
						this.getCurrentPathPossibleMemoryLeakVarsByLoop().add(scVar);
					}
				}

			}
			
			analyzeWCMCdata(parentWcmcData,currentClassInstance);
			
			return;
			
		}
		
		if(wcmcData.getExpressionList().isEmpty() && !wcmcData.hasParent()){

			if(wcmcData.getBiggestMemSize()>this.currentPathWorstCaseMemoryConsumption){
				this.currentPathWorstCaseMemoryConsumption = wcmcData.getBiggestMemSize();
			}
				
			for(WCMCVar wcmcVar : wcmcData.getUnclosedInstances()){
				if(!this.unclosedInstancesContains(wcmcVar.getVar())){
					this.getCurrentPathUnclosedInstances().add(wcmcVar);
				}
			}
				
			for(SCVariable scVar : wcmcData.getPossibleMemoryLeakVars()){

				if(!this.getCurrentPathPossibleMemoryLeakVars().contains(scVar)){
					this.getCurrentPathPossibleMemoryLeakVars().add(scVar);
				}
			}
			
			return;			
			
		}

	}

	public int analyzeSCVar(SCVariable scvar) {
		
		int currentMemorySize=0;

		if (scvar instanceof SCArray) {
			
			SCArray arr = (SCArray) scvar;
			Expression size = arr.getDerivedSize();			
			int multiplicator = exprToInt(size);
			
			if(dataTypesToMemorySize.containsKey(scvar.getType())){
				currentMemorySize +=  multiplicator*dataTypesToMemorySize.get(scvar.getType());
			}else{
				if(!getUnknownDatatypes().contains(scvar.getType())){
					getUnknownDatatypes().add(scvar.getType());
				}
			}

		} else if (scvar instanceof SCPointer) {
			
			currentMemorySize +=dataTypesToMemorySize.get("pointer");

		} else{

			if(dataTypesToMemorySize.containsKey(scvar.getType())){
				currentMemorySize +=dataTypesToMemorySize.get(scvar.getType());
			}else{
				if(!getUnknownDatatypes().contains(scvar.getType())){
					getUnknownDatatypes().add(scvar.getType());
				}
			}
			
		}
		return currentMemorySize;
		
	}

	public void computeSizeOfEachStruct(){
		
		// if there exists nested structs
		boolean checkAgain=false;
		
		for(SCClass scClass : scs.getClasses()){
			
			if(!(scClass.isChannel()||scClass.isSCModule())
					&& !dataTypesToMemorySize.containsKey(scClass.getName())){
				
				int memSize = 0;
				boolean checkAgainClasses = false;;
				
				for (SCVariable scvar : scClass.getMembers()) {
					
					// Struct
					if(scvar instanceof SCClassInstance){
						
						if(getStructs().containsKey(scvar.getType())){
							memSize+=getStructs().get(scvar.getType());
						}else{
							checkAgainClasses=true;
							checkAgain=true;
						}
					// simple type	
					}else{
					
						if(dataTypesToMemorySize.containsKey(scvar.getType())){
							memSize+=dataTypesToMemorySize.get(scvar.getType());
						}else{
							// not defined in wcmc.properties
							if(!getUnknownDatatypes().contains(scvar.getType())){
								getUnknownDatatypes().add(scvar.getType());
							}
						}
					
					}
					
				}
				
				if(checkAgainClasses==false){
					getStructs().put(scClass.getName(), memSize);
				}
				
			}
		}
		
		//check Size of each struct
		for(SCClassInstance classInstance : scs.getInstances()){
			
			SCClass scClass = classInstance.getSCClass();
		
			if (!(classInstance.isSCModule() || classInstance.isSCKnownType() || classInstance.isChannel())
					&& !dataTypesToMemorySize.containsKey(scClass.getName()) ){
				
				int memSize = 0;
				boolean checkAgainClassInstances = false;
				
				for (SCVariable scvar : scClass.getMembers()) {
					
					// Struct
					if(scvar instanceof SCClassInstance){
						
						if(getStructs().containsKey(scvar.getType())){
							memSize+=getStructs().get(scvar.getType());
						}else{
							checkAgainClassInstances=true;
							checkAgain=true;
						}
					// simple type	
					}else{
					
						if(dataTypesToMemorySize.containsKey(scvar.getType())){
							memSize+=dataTypesToMemorySize.get(scvar.getType());
						}else{
							// not defined in wcmc.properties
							if(!getUnknownDatatypes().contains(scvar.getType())){
								getUnknownDatatypes().add(scvar.getType());
							}
						}
					
					}
					
				}
				
				if(checkAgainClassInstances==false){
					getStructs().put(scClass.getName(), memSize);
				}
			}
		
		}
		
		// if a struct contains another structs
		if(checkAgain){
			computeSizeOfEachStruct();
		}
		
	}
	
	public void readWCMCProperties(){
		
		InputStream input = null;
	 
		try {
	 
			input = new FileInputStream(propertiesPath);
			
			Properties prop = new Properties();

			prop.load(input);
			
			Enumeration<?> e = prop.propertyNames();
			while (e.hasMoreElements()) {
				String key = (String) e.nextElement();
				Integer value = new Integer(prop.getProperty(key));
				dataTypesToMemorySize.put(key,value);
			}
	 
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	 		
	}

	public int exprToInt(Expression size) {
		int i = 0;
		if (size != null) {
			try {
				i = Integer.parseInt(size.toStringNoSem());
			} catch (NumberFormatException e) {
			}
			if (size instanceof SCVariableExpression) {
				// to get the value of 'int size = 2; int buf[size];'
				// this is wrong, in case of 'int size = 2; size = ...;
				// int buf[size];'
				if (((SCVariableExpression) size).getVar().hasInitialValue()) {
					SCVariableDeclarationExpression d = ((SCVariableExpression) size)
							.getVar().getDeclaration();
					return exprToInt(d.getFirstInitialValue());
				}
			}
		}
		return i;
	}
	
	public boolean unclosedInstancesContains(SCVariable scVar){
		
		for(WCMCVar wcmcVar : this.getCurrentPathUnclosedInstances()){
			if(wcmcVar.getVar()==scVar){
				return true;
			}
		}
		return false;
		
	}

	public SCSystem getScs() {
		return scs;
	}

	public void setScs(SCSystem scs) {
		this.scs = scs;
	}

	public Integer getWorstCaseMemoryConsumption() {
		return worstCaseMemoryConsumption;
	}

	public void setWorstCaseMemoryConsumption(Integer worstCaseMemoryConsumption) {
		this.worstCaseMemoryConsumption = worstCaseMemoryConsumption;
	}
	
	public HashMap<String, Integer> getDataTypesToMemorySize() {
		return dataTypesToMemorySize;
	}

	public void setDataTypesToMemorySize(
			HashMap<String, Integer> dataTypesToMemorySize) {
		this.dataTypesToMemorySize = dataTypesToMemorySize;
	}

	public List<WCMCVar> getCurrentPathUnclosedInstances() {
		return currentPathUnclosedInstances;
	}

	public void setCurrentPathUnclosedInstances(
			List<WCMCVar> currentPathUnclosedInstances) {
		this.currentPathUnclosedInstances = currentPathUnclosedInstances;
	}

	public List<SCVariable> getCurrentPathPossibleMemoryLeakVars() {
		return currentPathPossibleMemoryLeakVars;
	}

	public void setCurrentPathPossibleMemoryLeakVars(
			List<SCVariable> currentPathPossibleMemoryLeakVars) {
		this.currentPathPossibleMemoryLeakVars = currentPathPossibleMemoryLeakVars;
	}

	public List<SCVariable> getCurrentPathPossibleMemoryLeakVarsByLoop() {
		return currentPathPossibleMemoryLeakVarsByLoop;
	}

	public void setCurrentPathPossibleMemoryLeakVarsByLoop(
			List<SCVariable> currentPathPossibleMemoryLeakVarsByLoop) {
		this.currentPathPossibleMemoryLeakVarsByLoop = currentPathPossibleMemoryLeakVarsByLoop;
	}

	public List<Integer> getProcessWorstCaseMemoryConsumption() {
		return processWorstCaseMemoryConsumption;
	}

	public void setProcessWorstCaseMemoryConsumption(
			List<Integer> processWorstCaseMemoryConsumption) {
		this.processWorstCaseMemoryConsumption = processWorstCaseMemoryConsumption;
	}

	public List<String> getUnknownDatatypes() {
		return unknownDatatypes;
	}

	public void setUnknownDatatypes(List<String> unknownDatatypes) {
		this.unknownDatatypes = unknownDatatypes;
	}

	public HashMap<String, Integer> getStructs() {
		return structs;
	}

	public void setStructs(HashMap<String, Integer> structs) {
		this.structs = structs;
	}

	
}
