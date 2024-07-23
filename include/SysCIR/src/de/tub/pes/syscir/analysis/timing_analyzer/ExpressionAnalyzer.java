/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import de.tub.pes.syscir.sc_model.expressions.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
/**
 * @author mario
 * 
 * Class to switch between expression type cases.
 * Hold an expression handler and call the appropriate handle functions
 */
public class ExpressionAnalyzer {

	private static Logger logger = LogManager.getLogger(ProcessAnalyzer.class.getName());

	private TADefaultExpressionHanlder expressionHandler;

	public ExpressionAnalyzer(TADefaultExpressionHanlder def) {
		this.expressionHandler = def;
	}

	public void analyzeExpression(Expression expression){

		if(expression instanceof IfElseExpression){
			expressionHandler.handleIfElseExpression((IfElseExpression) expression);
		}
		else if(expression instanceof SwitchExpression){
			expressionHandler.handleSwitchExpression((SwitchExpression) expression);
		}
		else if(expression instanceof CaseExpression){
			expressionHandler.handleCaseExpression((CaseExpression) expression);
		}
		else if(expression instanceof LoopExpression){
			expressionHandler.handleLoopExpression((LoopExpression) expression);
		}
		else if(expression instanceof AccessExpression){
			expressionHandler.handleAccessExpression((AccessExpression) expression);
		}
		else if(expression instanceof UnaryExpression){
			expressionHandler.handleUnaryExpression((UnaryExpression) expression);
		}
		else if(expression instanceof BinaryExpression){
			expressionHandler.handleBinaryExpression((BinaryExpression) expression);
		}
		else if(expression instanceof FunctionCallExpression){
			expressionHandler.handleFunctionCallExpression((FunctionCallExpression) expression);
		}
		else if(expression instanceof EventNotificationExpression){
			expressionHandler.handleEventNotificationExpression((EventNotificationExpression) expression);
		}
		else if(expression instanceof SCVariableDeclarationExpression){
			expressionHandler.handleSCVariableDeclarationExpression((SCVariableDeclarationExpression) expression);
		}
		else if(expression instanceof SCVariableExpression){
			expressionHandler.handleSCVariableExpression((SCVariableExpression) expression);
		}
		else if(expression instanceof SCPortSCSocketExpression){
			expressionHandler.handleSCPortSCSocketExpression((SCPortSCSocketExpression) expression);
		}
		else if(expression instanceof RefDerefExpression){
			expressionHandler.handleRefDerefExpression((RefDerefExpression) expression);
		}
		else if(expression instanceof NewExpression){
			expressionHandler.handleNewExpressionExpression((NewExpression) expression);
		}
		else if(expression instanceof NewArrayExpression){
			expressionHandler.handleNewArrayExpression((NewArrayExpression) expression);
		}
		else if(expression instanceof DeleteExpression){
			expressionHandler.handleDeleteExpression((DeleteExpression) expression);
		}
		else if(expression instanceof DeleteArrayExpression){
			expressionHandler.handleDeleteArrayExpression((DeleteArrayExpression) expression);
		}
		else if(expression instanceof GoalAnnotation) {
			expressionHandler.handleGoalAnnotation((GoalAnnotation)expression);
		}
		else {
			expressionHandler.handleDefaultExpression(expression);
		}
	}
}
