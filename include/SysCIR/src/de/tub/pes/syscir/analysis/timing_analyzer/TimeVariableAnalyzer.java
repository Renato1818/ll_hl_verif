/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.sc_model.SCFunction;
import de.tub.pes.syscir.sc_model.SCVariable;
import de.tub.pes.syscir.sc_model.expressions.AccessExpression;
import de.tub.pes.syscir.sc_model.expressions.BinaryExpression;
import de.tub.pes.syscir.sc_model.expressions.ConstantExpression;
import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.expressions.FunctionCallExpression;
import de.tub.pes.syscir.sc_model.expressions.LoopExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableDeclarationExpression;
import de.tub.pes.syscir.sc_model.expressions.SCVariableExpression;
import de.tub.pes.syscir.sc_model.expressions.TimeUnitExpression;
import de.tub.pes.syscir.sc_model.variables.SCTIMEUNIT;
import de.tub.pes.syscir.sc_model.variables.SCTime;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
/**
 * @author mario
 *
 * Just functions to derive the time value as long
 * from different SystemC expressions.
 */
public class TimeVariableAnalyzer {

	private static Logger logger = LogManager.getLogger(ProcessAnalyzer.class.getName());
	/**
	 * This function tries to resolve a sc_time variable to a 
	 * fixed time value. Only works if the variable always has a static
	 * VALUE at this expression.
	 * If the VARIABLE is static this in not supported.
	 * The original expression is needed for back-tracking.
	 * 
	 * @param t The sc_time variable to investigate.
	 * @param callExpr The expression where the variable is used.
	 * @return The time value if possible
	 */
	public long getTimeFromVariable(SCTime t, Expression callExpr) {
		// const
		if (t.isConst() && t.hasInitialValue() ) {
			String initString = t.getInitializationString();
			String numberString = initString.substring(2);
			numberString = numberString.trim();
			logger.error("const sc_time unhandled (TODO)");
			return Long.valueOf(-1);
		}
		if (t.isStatic()) {
			// race cond
			logger.error("can't handle static time variables");
			return -1;
		}
		// no back-tracking of function calls
		return analyzeSCTimeVarBackward(t, callExpr);
	}
	
	public long getTimeFromExpression(Expression expr) {
		if (expr instanceof SCVariableExpression) {
			SCVariable var = ((SCVariableExpression)expr).getVar();
			if (var instanceof SCTime) {
				SCTime timeVar = (SCTime)var;
				return getTimeFromVariable(timeVar, expr.getParent());
			}
		}
		else if (expr instanceof FunctionCallExpression) {
			return analyzeSCTimeCall((FunctionCallExpression)expr);
		}

		
		return -1;
	}

	/**
	 * This function is to get the value of a SCTime variable.
	 * It tries to find the last expression where the variable had a const value. 
	 * From there the only (+=) of const. values is supported.
	 * 
	 * @param t
	 * @param callExpr
	 * @return
	 */
	public long analyzeSCTimeVarBackward(SCTime t, Expression callExpr) {
		// search parent for assignment
		Expression parentExpr = callExpr.getParent();
		if (parentExpr == null) {
			logger.error("BW variable analysis failed. No parent found");
			return -1;
		}
		if (parentExpr instanceof AccessExpression) {
			return analyzeSCTimeVarBackward(t, parentExpr);
		}
		else if (parentExpr instanceof BinaryExpression) {
			return analyzeSCTimeVarBackward(t, parentExpr);
		}

		List<Expression> exprList = parentExpr.crawlDeeper();
		int i = exprList.indexOf(callExpr)-1;
		for (; i >=0; i--) { // go back through possible modifications
			Expression currExpr = exprList.get(i);
			if (currExpr instanceof BinaryExpression) {
				BinaryExpression binExpr = (BinaryExpression)currExpr;
				if (binExpr.getLeft() instanceof SCVariableExpression) {
					SCVariable v = ((SCVariableExpression)binExpr.getLeft()).getVar();
					if(v instanceof SCTime) {
						SCTime tCand = (SCTime)v;
						if (tCand.equals(t)) {
							// t =  ...
							if (binExpr.getOp().equals("=")) { // assignment
								return analyzeTimeAssignment(binExpr.getRight());
							}
							// t += ...
							if (binExpr.getOp().equals("+=")) {
								return analyzeSCTimeVarBackward(t, callExpr) + 
										analyzeTimeAssignment(binExpr.getRight());
							}
						}
					}
				}
			}
			// sc_time t = ...
			if (currExpr instanceof SCVariableDeclarationExpression) {
				SCVariableDeclarationExpression decl = (SCVariableDeclarationExpression)currExpr;
				if (decl.getVariable() instanceof SCVariableExpression) {
					if ( ((SCVariableExpression)decl.getVariable()).getVar() instanceof SCTime) { 
						SCTime newT = (SCTime)((SCVariableExpression)decl.getVariable()).getVar(); 
						if (newT.equals(t)) {
							return getTimeFromSCTimeCTOR(decl.getFirstInitialValue(), decl.getInitialValues().get(1));
						}
					}
				}
			}
		} // expr not found in list
		// try parent again, shouldn't happen
		return analyzeSCTimeVarBackward(t, parentExpr);
	}

	/**
	 * Use this for expressions that are assigned to SCTime values.
	 * 
	 * @param assignExpr The right value
	 * @return the new time in femto seconds
	 */
	public long analyzeTimeAssignment(Expression assignExpr) {
		if (assignExpr instanceof FunctionCallExpression) {
			FunctionCallExpression fctCallExpr = (FunctionCallExpression) assignExpr;
			if (fctCallExpr.getFunction().getName().equals("sc_time")) {
				return analyzeSCTimeCall(fctCallExpr);
			}
		}
		// other variable assigned -> trace it as well
		else if (assignExpr instanceof SCVariableExpression) {
			SCVariable var = ((SCVariableExpression)assignExpr).getVar();
			if (var instanceof SCTime){
				return getTimeFromVariable((SCTime)var, assignExpr);
			}
		}
		logger.error("unhandled time assignment");
		return -1;
	}
	
	public long analyzeSCTimeCall(FunctionCallExpression fce) {
		SCFunction fct = fce.getFunction();
		if (fct.getName().equals("sc_time")) {
			Expression firstExpr = fce.getParameters().get(0);
			Expression secExpr = fce.getParameters().get(1); // second par must be time unit
			return getTimeFromSCTimeCTOR(firstExpr, secExpr);
		}
		logger.error("unhandled sc_time call");
		return -1;
	}
	
	public long getTimeFromSCTimeCTOR(Expression firstExpr, Expression secExpr) {
		long time = -1;
		if (firstExpr instanceof ConstantExpression){ // fixed numeral in source code
			if (secExpr instanceof TimeUnitExpression) {
				time = Long.valueOf(((ConstantExpression)firstExpr).toString());
				SCTIMEUNIT timeUnit = ((TimeUnitExpression)secExpr).getTimeUnit();
				int exponent =  15 - Math.abs(timeUnit.getExponent());
				for (int i = 0; i < exponent; i++) {
					time *= 10; // 64 bit needed
				}
			}
		}
		return time;
	}

}
