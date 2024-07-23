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

/**
 * 
 * @author Björn Beckmann
 *
 */
public class DRAExpressionAnalyzer {
	
	DRAExpressionHandler expressionHandler;
	
	public DRAExpressionAnalyzer(DRAExpressionHandler expressionHandler){
		this.expressionHandler=expressionHandler;
	}
	
	public void analyzeExpression(Expression expression, SCClassInstance currentClassInstance){
	
		if(expression instanceof IfElseExpression){
			expressionHandler.ifElseExpressionHandler((IfElseExpression) expression, currentClassInstance);
		}else
		if(expression instanceof SwitchExpression){
			expressionHandler.SwitchCaseExpressionHandler((SwitchExpression) expression, currentClassInstance);
		}else
		if(expression instanceof CaseExpression){
			expressionHandler.CaseExpressionHandler((CaseExpression) expression, currentClassInstance);
		}else
		if(expression instanceof LoopExpression){
			expressionHandler.loopExpressionHandler((LoopExpression) expression, currentClassInstance);
		}else
		if(expression instanceof AccessExpression){
			expressionHandler.accessExpressionHandler((AccessExpression) expression, currentClassInstance);
		}else
		if(expression instanceof UnaryExpression){
			expressionHandler.unaryExpressionHandler((UnaryExpression) expression, currentClassInstance);
		}else
		if(expression instanceof BinaryExpression){
			expressionHandler.binaryExpressionHandler((BinaryExpression) expression, currentClassInstance);
		}else
		if(expression instanceof FunctionCallExpression){
			expressionHandler.functionCallExpressionHandler((FunctionCallExpression) expression, currentClassInstance);
		}else
		if(expression instanceof EventNotificationExpression){
			expressionHandler.eventNotificationExpressionHandler((EventNotificationExpression) expression, currentClassInstance);
		}else
		if(expression instanceof SCVariableDeclarationExpression){
			expressionHandler.sCVariableDeclarationExpressionHandler((SCVariableDeclarationExpression) expression, currentClassInstance);
		}else
		if(expression instanceof SCVariableExpression){
			expressionHandler.sCVariableExpressionHandler((SCVariableExpression) expression, currentClassInstance);
		}else
		if(expression instanceof SCPortSCSocketExpression){
			expressionHandler.sCPortSCSocketExpressionHandler((SCPortSCSocketExpression) expression, currentClassInstance);
		}else
			if(expression instanceof RefDerefExpression){
				expressionHandler.refDerefExpressionHandler((RefDerefExpression) expression, currentClassInstance);
		}else{
			expressionHandler.elseHandler(expression, currentClassInstance);

		}

	}//analyzeExpression
	
}
