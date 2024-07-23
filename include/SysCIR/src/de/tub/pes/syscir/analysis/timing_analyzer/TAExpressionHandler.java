/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.tub.pes.syscir.sc_model.variables.SCClassInstance;

/**
 * @author mario
 *
 */
public interface TAExpressionHandler {

	/**
	 * Interface to handle expressions from de.tub.pes.syscir.sc_model.expressions.Expression;
	 * 
	 * @param exp Expression to handle
	 * @param currentClassInstance link to the class instance
	 */
	public void handle(Expression exp, SCClassInstance currentClassInstance);

}
