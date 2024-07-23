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
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;

public class DRAPointerConnection {
	
	private SCVariable var;
	private SCClassInstance classInstance;
	
	private List<Pair<SCVariable,SCClassInstance>> pointerConnections;
	
	public DRAPointerConnection(SCVariable var,SCClassInstance classInstance){
		this.var = var;
		this.classInstance = classInstance;
		setPointerConnections(new LinkedList<Pair<SCVariable, SCClassInstance>>());
	}
	
	public String toString(){
		String s="DRAPointerConnection: "+var+", "+classInstance+"\n";
		for(Pair<SCVariable,SCClassInstance> pair :  pointerConnections){
			s+="("+pair.getFirst()+", "+pair.getSecond()+")\n";
		}
		return s;
	}
	
	public SCVariable getVar() {
		return var;
	}

	public void setVar(SCVariable var) {
		this.var = var;
	}

	public SCClassInstance getClassInstance() {
		return classInstance;
	}

	public void setClassInstance(SCClassInstance classInstance) {
		this.classInstance = classInstance;
	}

	public List<Pair<SCVariable,SCClassInstance>> getPointerConnections() {
		return pointerConnections;
	}

	public void setPointerConnections(List<Pair<SCVariable,SCClassInstance>> pointerConnections) {
		this.pointerConnections = pointerConnections;
	}
	
}
