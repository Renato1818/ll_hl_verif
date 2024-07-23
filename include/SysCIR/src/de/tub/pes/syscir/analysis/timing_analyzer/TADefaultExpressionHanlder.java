/**
 * Author: 	mario
 * file:	TADefaultExpressionHanlder.java
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.CaseExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.DeleteExpression;
import de.tub.pes.syscir.sc_model.expressions.EventNotificationExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.GoalAnnotation;
import de.tub.pes.syscir.sc_model.expressions.IfElseExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.NewArrayExpression;
import de.tub.pes.syscir.sc_model.expressions.NewExpression;
import de.tub.pes.syscir.sc_model.expressions.RefDerefExpression;
import de.tub.pes.syscir.sc_model.expressions.ReturnExpression;
import de.tub.pes.syscir.sc_model.expressions.SCPortSCSocketExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.SwitchExpression;
import de.tub.pes.syscir.sc_model.expressions.UnaryExpression;

/**
 * @author mario
 * Simply delegate all handle...Expression calls to the
 * default handler (that does nothing here).
 * Child classes should override the default handle 
 * and all handle functions that have to be specialized. 
 */
public abstract class TADefaultExpressionHanlder {

	protected void handleAccessExpression(AccessExpression expression){
		handleDefaultExpression(expression);
	} 

	protected void handleReturnExpression(ReturnExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleFunctionCallExpression(FunctionCallExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleBinaryExpression(BinaryExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleIfElseExpression(IfElseExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleSwitchExpression(SwitchExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleCaseExpression(CaseExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleLoopExpression(LoopExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleUnaryExpression(UnaryExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleEventNotificationExpression(EventNotificationExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleSCVariableDeclarationExpression( SCVariableDeclarationExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleSCVariableExpression(SCVariableExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleSCPortSCSocketExpression(SCPortSCSocketExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleRefDerefExpression(RefDerefExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleNewExpressionExpression(NewExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleNewArrayExpression(NewArrayExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleDeleteExpression(DeleteExpression expression) {
		handleDefaultExpression(expression);
	}

	protected void handleDeleteArrayExpression(DeleteArrayExpression expression) {
		handleDefaultExpression(expression);
	}
	
	protected void handleGoalAnnotation(GoalAnnotation expression) {
		handleDefaultExpression(expression);
	}

	protected void handleDefaultExpression(Expression expression) {
		
	}

	public void analyzeExpression(Expression expression){

		if(expression instanceof IfElseExpression){
			handleIfElseExpression((IfElseExpression) expression);
		}
		else if(expression instanceof SwitchExpression){
			handleSwitchExpression((SwitchExpression) expression);
		}
		else if(expression instanceof CaseExpression){
			handleCaseExpression((CaseExpression) expression);
		}
		else if(expression instanceof LoopExpression){
			handleLoopExpression((LoopExpression) expression);
		}
		else if(expression instanceof AccessExpression){
			handleAccessExpression((AccessExpression) expression);
		}
		else if(expression instanceof UnaryExpression){
			handleUnaryExpression((UnaryExpression) expression);
		}
		else if(expression instanceof BinaryExpression){
			handleBinaryExpression((BinaryExpression) expression);
		}
		else if(expression instanceof FunctionCallExpression){
			handleFunctionCallExpression((FunctionCallExpression) expression);
		}
		else if(expression instanceof EventNotificationExpression){
			handleEventNotificationExpression((EventNotificationExpression) expression);
		}
		else if(expression instanceof SCVariableDeclarationExpression){
			handleSCVariableDeclarationExpression((SCVariableDeclarationExpression) expression);
		}
		else if(expression instanceof SCVariableExpression){
			handleSCVariableExpression((SCVariableExpression) expression);
		}
		else if(expression instanceof SCPortSCSocketExpression){
			handleSCPortSCSocketExpression((SCPortSCSocketExpression) expression);
		}
		else if(expression instanceof RefDerefExpression){
			handleRefDerefExpression((RefDerefExpression) expression);
		}
		else if(expression instanceof NewExpression){
			handleNewExpressionExpression((NewExpression) expression);
		}
		else if(expression instanceof NewArrayExpression){
			handleNewArrayExpression((NewArrayExpression) expression);
		}
		else if(expression instanceof DeleteExpression){
			handleDeleteExpression((DeleteExpression) expression);
		}
		else if(expression instanceof DeleteArrayExpression){
			handleDeleteArrayExpression((DeleteArrayExpression) expression);
		}
		else if(expression instanceof GoalAnnotation) {
			handleGoalAnnotation((GoalAnnotation)expression);
		}
		else {
			handleDefaultExpression(expression);
		}
	}


}
