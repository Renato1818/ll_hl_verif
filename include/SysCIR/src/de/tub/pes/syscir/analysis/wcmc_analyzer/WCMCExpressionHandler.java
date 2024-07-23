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

import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.NewArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.NewExpression;
import de.tub.pes.syscir.sc_model.expressions.RefDerefExpression;
import de.tub.pes.syscir.sc_model.expressions.SCPortSCSocketExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.SwitchExpression;
import de.tub.pes.syscir.sc_model.expressions.UnaryExpression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCKnownType;

public interface WCMCExpressionHandler {
	
	public void accessExpressionHandler(AccessExpression expression, SCClassInstance currentClassInstance);

	public void ifElseExpressionHandler(IfElseExpression expression, SCClassInstance currentClassInstance);

	public void SwitchCaseExpressionHandler(SwitchExpression expression, SCClassInstance currentClassInstance);
	
	public void CaseExpressionHandler(CaseExpression expression, SCClassInstance currentClassInstance);

	public void loopExpressionHandler(LoopExpression expression, SCClassInstance currentClassInstance);

	public void portCallHandler(SCFunction scfunction, SCKnownType knownType, SCClassInstance currentClassInstance);

	public void portCallHandler(SCFunction scfunction, SCClassInstance classInstancePort, SCClassInstance currentClassInstance);

	public void binaryExpressionHandler(BinaryExpression expression, SCClassInstance currentClassInstance);

	public void unaryExpressionHandler(UnaryExpression expression, SCClassInstance currentClassInstance);
	
	public void sCVariableExpressionHandler(SCVariableExpression expression, SCClassInstance currentClassInstance);

	public void sCVariableDeclarationExpressionHandler(SCVariableDeclarationExpression expression, SCClassInstance currentClassInstance);

	public void eventNotificationExpressionHandler(EventNotificationExpression expression, SCClassInstance currentClassInstance);

	public void functionCallExpressionHandler(FunctionCallExpression expression, SCClassInstance currentClassInstance);
	
	public void sCPortSCSocketExpressionHandler(SCPortSCSocketExpression expression, SCClassInstance currentClassInstance);
	
	public void refDerefExpressionHandler(RefDerefExpression expression, SCClassInstance currentClassInstance);
	
	public void newExpressionExpressionHandler(NewExpression expression, SCClassInstance currentClassInstance);

	public void newArrayExpressionExpressionHandler(NewArrayExpression expression, SCClassInstance currentClassInstance);

	public void deleteExpressionExpressionHandler(DeleteExpression expression, SCClassInstance currentClassInstance);

	public void deleteArrayExpressionExpressionHandler(DeleteArrayExpression expression, SCClassInstance currentClassInstance);

	public void elseHandler(Expression expression, SCClassInstance currentClassInstance);

}
