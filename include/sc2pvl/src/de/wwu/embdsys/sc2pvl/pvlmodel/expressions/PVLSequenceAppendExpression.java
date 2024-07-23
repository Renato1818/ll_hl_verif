package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import org.w3c.dom.Node;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLVariable;

import java.io.Serial;

public class PVLSequenceAppendExpression extends PVLVariableExpression {
	
	@Serial
	private static final long serialVersionUID = -5179646106640878317L;
	
	private PVLVariableExpression append;

	public PVLSequenceAppendExpression(Node n, PVLVariable var, PVLClass pvl_class, PVLVariableExpression append) {
		super(n, var, pvl_class);
		this.setAppend(append);
	}

	public PVLVariableExpression getAppend() {
		return append;
	}

	public void setAppend(PVLVariableExpression append) {
		this.append = append;
	}
	
	public String toString() {
		return "(" + var.toString().replace(";", "") + " ++ " + append.toString().replace(";", "") + ");";
	}

}
