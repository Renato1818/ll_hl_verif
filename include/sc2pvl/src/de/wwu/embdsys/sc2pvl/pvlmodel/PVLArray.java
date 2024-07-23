package de.wwu.embdsys.sc2pvl.pvlmodel;

import de.tub.pes.syscir.sc_model.expressions.Expression;

public class PVLArray extends PVLVariable {

	private Expression size;
	
	public PVLArray(String name, String type, PVLClass corr_class) {
		super(name, type, corr_class);
	}

	public Expression getSize() {
		return size;
	}

	public void setSize(Expression size) {
		this.size = size;
	}
	
	public String toString() {
		return super.getType() + "[" +
				"] " +
				super.getName() +
				";";
	}

}
