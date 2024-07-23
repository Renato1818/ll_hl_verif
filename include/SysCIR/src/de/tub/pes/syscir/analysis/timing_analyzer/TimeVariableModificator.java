/**
 * 
 */
package de.tub.pes.syscir.analysis.timing_analyzer;

import java.util.LinkedList;
import java.util.List;

import de.tub.pes.syscir.engine.util.Pair;
import de.tub.pes.syscir.sc_model.variables.SCTime;

/**
 * @author mario
 *
 */
public class TimeVariableModificator {

	public enum Op{ ADD, SUB, MUL, SET};
	
	/**
	 * Sequence of operations
	 */
	private List<Pair<Op, Long>> mods;

	public TimeVariableModificator() {
		mods = new LinkedList<Pair<Op, Long>>();
	}
	
	public List<Pair<Op, Long>> getMods() {
		return mods;
	}

	public void apply(Long to) {
		for (Pair<Op, Long> mod : mods) {
			switch (mod.getFirst()) {
			case ADD:
				to += mod.getSecond();
				break;

			case SUB:
				to -= mod.getSecond();
				break;

			case MUL:
				to *= mod.getSecond();
				break;

			case SET:
				to = mod.getSecond();
				break;

			default:
				break;
			}
		}
	}

}
