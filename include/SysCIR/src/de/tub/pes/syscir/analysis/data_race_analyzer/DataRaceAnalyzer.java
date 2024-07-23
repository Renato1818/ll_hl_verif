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

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import de.tub.pes.syscir.analysis.Analyzer;
import de.tub.pes.syscir.engine.util.MutableInteger;
import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCClass;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCPROCESSTYPE;
import de.tub.pes.syscir.sc_model.SCProcess;
import de.tub.pes.syscir.sc_model.SCSystem;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;

/**
 * 
 * @author Björn Beckmann
 *
 */
public class DataRaceAnalyzer implements Analyzer{

	private static Logger logger = LogManager
			.getLogger(DataRaceAnalyzer.class.getName());
	
	/**
	 * list of all non-preemptive Blocks
	 */
	private List<AtomicBlock> atomicBlocks;
	
	/**
	 * list of dependent non-preemptive Blocks
	 */
	private HashMap<AtomicBlock, List<AtomicBlock>> dataRaces;
	
	/**
	 * current SysCIR Model
	 */
	private SCSystem scs;
	
	/**
	 * expression analyzer used by method searchAtomicBlocks
	 */
	private DRAExpressionAnalyzer expressionAnalyzer;
	
	/**
	 *	collects access expressions that do an context change to another class instance
	 */
	private HashMap<AccessExpression,List<Pair<SCClassInstance,SCClassInstance>>> accessExpressionToClassInstance;	
	
	/**
	 * 	possible pointer assignments
	 */
	private List<DRAPointerConnection> possiblePointerConnection;
	
	
	public DataRaceAnalyzer(){

		this.setAtomicBlocks(new LinkedList<AtomicBlock>());
		this.setDataRaces(new HashMap<AtomicBlock, List<AtomicBlock>>());
		this.setExpressionHandler(new DRAExpressionAnalyzer(new DRASearchAtomicBlocksExpressionHandler(this)));
		this.setAccesExpressionToClassInstance(new HashMap<AccessExpression,List<Pair<SCClassInstance,SCClassInstance>>>());
		this.setPossiblePointerConnection(new LinkedList<DRAPointerConnection>());
	}
	
	/**
	 *  analyzes a SysCIR-Model:
	 *  searches all atomic blocks and checks them with each other for data races
	 * 
	 */
	@Override
	public void analyze(SCSystem scs) {
		
		this.setScs(scs);
		
		for(SCClassInstance classInstance : scs.getInstances()){
			
			SCClass scClass = classInstance.getSCClass();
						
			for(SCProcess scProcess : scClass.getProcesses()){
				
				SCFunction scFunction = scProcess.getFunction();
				traverseCFGandAnalysePointer(scFunction.getBody(), classInstance);
				
			}
		
		}
		
		/*
		for(DRAPointerConnection pc : possiblePointerConnection){
			System.out.println(pc.toString());
		}
		*/
		
		for(SCClassInstance classInstance : scs.getInstances()){
			
			SCClass scClass = classInstance.getSCClass();
						
			for(SCProcess scProcess : scClass.getProcesses()){
				
				DRASearchAtomicBlocksExpressionHandler dSABEH = ((DRASearchAtomicBlocksExpressionHandler) expressionAnalyzer.expressionHandler);
				
				dSABEH.setClassInstance(classInstance);
				
				dSABEH.setProcess(scProcess);
				
				SCFunction scFunction = scProcess.getFunction();

				FunctionCallExpression fCE = new FunctionCallExpression(null, scFunction, null);
				
				AtomicBlock atomicBlock = new AtomicBlock(fCE, classInstance, scProcess, this.getScs(), this);
				
				this.getAtomicBlocks().add(atomicBlock);
				
				atomicBlock.analyzeAtomicBlock();

				if(scProcess.getType()==SCPROCESSTYPE.SCTHREAD){
					//search wait statements
					this.accessExpressionToClassInstance.clear();
					traverseCFG(scFunction.getBody(),classInstance,fCE);
				}
				
				this.accessExpressionToClassInstance.clear();
				
			}
									
		}
		
		// check atomic blocks for data races
		
		for(int i=0; i<this.getAtomicBlocks().size();i++){
			
				dataRaces.put(this.getAtomicBlocks().get(i), new LinkedList<AtomicBlock>());
			
				for(int k=0; k<this.getAtomicBlocks().size();k++){
					
						if(AtomicBlockDependency.dependency(this.getAtomicBlocks().get(i),this.getAtomicBlocks().get(k)) )
						{
								if(!dataRaces.get(this.getAtomicBlocks().get(i)).contains(this.getAtomicBlocks().get(k))){
									dataRaces.get(this.getAtomicBlocks().get(i)).add(this.getAtomicBlocks().get(k));
								}
						}else{

							if(AtomicBlockDependency.immediateNotification_dependency(this.getAtomicBlocks().get(i),this.getAtomicBlocks().get(k),this.getAtomicBlocks())){
								if(!dataRaces.get(this.getAtomicBlocks().get(i)).contains(this.getAtomicBlocks().get(k))){
									dataRaces.get(this.getAtomicBlocks().get(i)).add(this.getAtomicBlocks().get(k));
								}
							}

						}
				}
		}
			
	}
		
	/**
	 * traverse deeply @param list and build a new Atomic Block for each found wait Statement
	 * @param list
	 * @param currentClassInstance
	 */
	void traverseCFG(List<Expression> list, SCClassInstance currentClassInstance, Expression parent) {
		
		for(int i=0; i<list.size(); i++){
			
			Expression expression = list.get(i);

			expression.setParent(parent);
			
			expressionAnalyzer.analyzeExpression(expression, currentClassInstance);
			
		}
				
	}

	/**
	 * traverses deeply @param list and analyses Pointer
	 * @param list
	 * @param currentClassInstance
	 */
	void traverseCFGandAnalysePointer(List<Expression> list, SCClassInstance currentClassInstance) {
		
		for(int i=0; i<list.size(); i++){
			DRAExpressionAnalyzer eA = new DRAExpressionAnalyzer(new DRAPointerExpressionHandler(this));
			
			Expression expression = list.get(i);

			eA.analyzeExpression(expression, currentClassInstance);
			
		}
				
	}
	
	public List<AtomicBlock> getAtomicBlocks() {
		return atomicBlocks;
	}

	public void setAtomicBlocks(List<AtomicBlock> blocks) {
		this.atomicBlocks = blocks;
	}

	public HashMap<AtomicBlock, List<AtomicBlock>> getDataRaces() {
		return dataRaces;
	}

	public void setDataRaces(HashMap<AtomicBlock, List<AtomicBlock>> dataRaces) {
		this.dataRaces = dataRaces;
	}

	public DRAExpressionAnalyzer getExpressionHandler() {
		return expressionAnalyzer;
	}

	public void setExpressionHandler(DRAExpressionAnalyzer expressionHandler) {
		this.expressionAnalyzer = expressionHandler;
	}

	public SCSystem getScs() {
		return scs;
	}

	public void setScs(SCSystem scs) {
		this.scs = scs;
	}
	
	private void removeBlocksWithoutBlockNumber() {
		List<AtomicBlock> removableBlocks = new LinkedList<AtomicBlock>();
		for (AtomicBlock block : getAtomicBlocks()) {
			if (block.getAtomicBlockNumber() == null) {
				removableBlocks.add(block);
			}
		}
		for (AtomicBlock block : removableBlocks) {
			getAtomicBlocks().remove(block);
		}
	}
	
	// order list AtomicBlocks 
	public void sortAtomicBlocks() {
		
		removeBlocksWithoutBlockNumber();
		List<AtomicBlock> newFinalList = new LinkedList<AtomicBlock>();
		
		//Sort AtomicBlocks by ClassInstance
		HashMap<SCClassInstance, LinkedList<AtomicBlock> > sortedBlocks = new HashMap();
		
		//All Initializer at the beginning at the beginning:
		List<AtomicBlock> initializers = new LinkedList<AtomicBlock>();
		for (AtomicBlock block : getAtomicBlocks()) {
			if (block.getTopLevelClassInstance() == block.getWaitLevelClassInstance() &&
				!block.isProcessNoInit()
				
			) {
				initializers.add(block);
			}
		}
		
		for (AtomicBlock initBlock : initializers) {
			getAtomicBlocks().remove(initBlock);
			newFinalList.add(initBlock);
		}
		
		for (AtomicBlock block : getAtomicBlocks()) {
			SCClassInstance topInstance = block.getTopLevelClassInstance();
			if (sortedBlocks.containsKey(topInstance)) {
				sortedBlocks.get(topInstance).add(block);
			} else {
				LinkedList<AtomicBlock> blockList = new LinkedList<AtomicBlock>();
				blockList.add(block);
				sortedBlocks.put(topInstance, blockList);
			}
		}
		
		//For every instance sort by same blockNumbers to keep blocks together for right offset
		for (SCClassInstance topInstance : sortedBlocks.keySet()) {		
			//sort by blockNumber in HashMap
			List<AtomicBlock> instanceBlocks = sortedBlocks.get(topInstance);
			HashMap<MutableInteger, List<AtomicBlock> > sameTopInstanceSameBlockNumber = new HashMap(); 
			for (AtomicBlock block : instanceBlocks) {
				MutableInteger blockNumber = block.getAtomicBlockNumber();
				if (sameTopInstanceSameBlockNumber.containsKey(blockNumber)) {
					sameTopInstanceSameBlockNumber.get(blockNumber).add(block);
				} else {
					LinkedList<AtomicBlock> sameBlockNumberList = new LinkedList<AtomicBlock>();
					sameBlockNumberList.add(block);
					sameTopInstanceSameBlockNumber.put(blockNumber, sameBlockNumberList);
				}
			}
			
			for (MutableInteger blockNumber : sameTopInstanceSameBlockNumber.keySet()) {
				List<AtomicBlock> blocks = sameTopInstanceSameBlockNumber.get(blockNumber);
				
				//Sort blocks with same blockNumberByOffset
				AtomicBlock blockArray[] = new AtomicBlock[blocks.size()];
				for (AtomicBlock block : blocks) {
					blockArray[block.getOffset()] = block;
				}
				for (AtomicBlock block : blockArray) {
					if (block != null) {
						newFinalList.add(block);
					}
				}
			}
			
		}
		
		//newFinalList is the new sorted order of Atomic block -> recalculate BlockNumber
		HashSet<MutableInteger> recalculatedBlockNumber = new HashSet<MutableInteger>();
		for (int i = 0; i < newFinalList.size(); i++) {
			AtomicBlock block = newFinalList.get(i);
			if (recalculatedBlockNumber.contains(block.getAtomicBlockNumber())) {
				//do nothing, already set
			} else {
				block.getAtomicBlockNumber().setI(i);
				recalculatedBlockNumber.add(block.getAtomicBlockNumber());
			}
		}
		
		//replace atomic block list with sorted one
		this.setAtomicBlocks(newFinalList);
		
		for(int i = 0; i < this.getAtomicBlocks().size(); i++){
			logger.info(this.getAtomicBlocks().get(i).toString(false));
		}

	}
	
	
	/**
	 *  merges dependencies from atomic blocks with same atomic block number
	 */
	public void mergeAtomicBlockDependencys(){
		
		for(AtomicBlock aB : this.getAtomicBlocks()){

		    for(AtomicBlock innerAB : this.getAtomicBlocks()){

		        if(aB != innerAB){
		           
		            if(aB.getAtomicBlockNumber() == innerAB.getAtomicBlockNumber()){

		                for(AtomicBlock dataRaceAB : this.getDataRaces().get(innerAB) ){
		                   
		                    if(!this.getDataRaces().get(aB).contains(dataRaceAB)){

		                    	this.getDataRaces().get(aB).add(dataRaceAB);
		                    	
			                    if(!this.getDataRaces().get(dataRaceAB).contains(aB)){
			                    	
			                    	this.getDataRaces().get(dataRaceAB).add(aB);

			                    }
		                   
		                    }

		                }
		                
		            }

		        }

		    }

		}
	}
	
	public HashMap<AccessExpression,List<Pair<SCClassInstance,SCClassInstance>>> getAccesExpressionToClassInstance() {
		return accessExpressionToClassInstance;
	}

	public void setAccesExpressionToClassInstance(
			HashMap<AccessExpression,List<Pair<SCClassInstance,SCClassInstance>>> accesExpressionToClassInstance) {
		this.accessExpressionToClassInstance = accesExpressionToClassInstance;
	}

	public List<DRAPointerConnection> getPossiblePointerConnection() {
		return possiblePointerConnection;
	}

	public void setPossiblePointerConnection(
			List<DRAPointerConnection> possiblePointerConnection) {
		this.possiblePointerConnection = possiblePointerConnection;
	}

}	
	