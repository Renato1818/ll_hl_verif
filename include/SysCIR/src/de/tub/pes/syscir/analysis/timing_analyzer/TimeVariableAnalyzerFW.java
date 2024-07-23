/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.HashMap;
import java.util.Map;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCVariable;
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
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;
import de.tub.pes.syscir.sc_model.variables.SCPeq;
import de.tub.pes.syscir.sc_model.variables.SCTime;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * @author mario
 * 
 * Tracks a given time variable through the given expressions and annotates
 * the calculated values to all wait and peq.notify calls.
 * Notify and wait are expected to be called with exactly this variable
 * and no connected expressions.
 *
 */
public class TimeVariableAnalyzerFW extends TADefaultExpressionHanlder{

	private static Logger logger = LogManager.getLogger(TimeVariableAnalyzerFW.class.getName());
	/**
	 * The variable to track.
	 */
	SCTime var;

	/**
	 * The time value of var
	 */
	long t; 
	
	/**
	 * Map for all wait-calls to the value of the time variable.
	 */
	Map<Expression, Long> wcDelayMap;
	
	
	public Map<Expression, Long> getWCTimeMap() {
		return wcDelayMap;
	}
	public TimeVariableAnalyzerFW(SCTime varToTrack, long initialValue) {
		this.var = varToTrack;
		this.t = initialValue;
		this.wcDelayMap = new HashMap<Expression, Long>();
	}
	@Override
	public void handleFunctionCallExpression(FunctionCallExpression fce) {
		SCFunction fct = fce.getFunction();
		if (fct.getName().equals("wait")){ // sc_time t; -> wait(t)
			if (fct.getParameters().get(0).getVar().equals(var)) {
				if (wcDelayMap.containsKey(fce)) {
					// WC analysis
					logger.debug("overwriting annotated value to fct call");
					wcDelayMap.put(fce, Math.max(wcDelayMap.get(fct),t));
				}
				else {
					wcDelayMap.put(fce, t);
				}
			}
		}
	}
	
	@Override
	protected void handleEventNotificationExpression(EventNotificationExpression expression) {
		Expression evExpr = expression.getEvent();
		if (! (evExpr instanceof SCVariableExpression)) return;
		SCVariable evVar = ((SCVariableExpression)evExpr).getVar();
		if (evVar instanceof SCPeq) {
			Expression other = expression.getParameters().get(2);
			if (other instanceof SCVariableExpression) {
				SCVariable otherVar = ((SCVariableExpression)other).getVar();
				if (otherVar.equals(var)) {
					if (wcDelayMap.containsKey(expression)) {
						// WC analysis
						logger.debug("overwriting annotated value to fct call");
						wcDelayMap.put(expression, Math.max(wcDelayMap.get(expression),t));
					}
					else {
						wcDelayMap.put(expression, t);
					}
				}
			}
		}
	};

	@Override
	protected void handleAccessExpression(AccessExpression expression) {
		Expression left  = expression.getLeft();
		Expression right  = expression.getRight();
		if (left instanceof SCVariableExpression) {
			SCVariable var = ((SCVariableExpression)left).getVar();
			if (var instanceof SCPeq) {
				if (right instanceof FunctionCallExpression) {
					FunctionCallExpression fce = (FunctionCallExpression)right;
					handleFunctionCallExpression(fce);
				}
			}
		}
	};
	
	@Override
	public void handleIfElseExpression(IfElseExpression expression) {
		logger.warn("unhandled if-else in variable analyzer");
		//TODO
	}
	
	@Override
	public void handleBinaryExpression(BinaryExpression bE) {
		Expression left = bE.getLeft();
		Expression right = bE.getRight();
		String op = bE.getOp();


		// check if left is our variable
		if (left instanceof SCVariableExpression) {
			SCVariable leftVar = ((SCVariableExpression)left).getVar();
			if (leftVar instanceof SCTime) {
				SCTime leftTime = (SCTime)leftVar;
				if (leftTime.equals(var)) {
					handleTimeAssignment(op, right);
				}
			}
		}
	}

	private void handleTimeAssignment(String op, Expression right) {
		//TODO use TimeVariableModificator
		TimeVariableAnalyzer tva = new TimeVariableAnalyzer();
		long rightTime = tva.analyzeTimeAssignment(right);
		if (op.equals("=")) {
			t = rightTime;
		}
		else if (op.equals("+=")) {
			t += rightTime;
		}
	}

	public long getTime() {
		return t;
	}

}