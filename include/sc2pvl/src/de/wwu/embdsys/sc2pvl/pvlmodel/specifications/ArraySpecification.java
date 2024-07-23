package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

public class ArraySpecification extends Specification {
	
	private final PVLVariable array;
	
	private final Expression size;

	public ArraySpecification(PVLClass corr_class, PVLSystem pvl_system, PVLVariable array, Expression size) {
		super(corr_class, pvl_system);
		this.array = array;
		this.size = size;
	}
	
	public String toString() {
		return "\\array(" + array.toStringNoType().replace(";", "") + ", " + size.toStringNoSem() + ");";
	}

}
