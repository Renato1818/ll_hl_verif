package de.wwu.embdsys.sc2pvl.pvlmodel.expressions;

import java.io.Serial;
import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;

import de.tub.pes.syscir.sc_model.expressions.Expression;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specifiable;
import de.wwu.embdsys.sc2pvl.pvlmodel.specifications.Specification;

/**
 * Represents a PVL Expression of the Loop Statement.
 *
 */
public abstract class PVLLoopExpression extends Expression implements Specifiable {

	@Serial
	private static final long serialVersionUID = -7437420044561371962L;
	/**
	 * Condition of the loop.
	 */
	private Expression condition;
	/**
	 * Body of the loop.
	 */
	private List<Expression> loopBody;
	/**
	 * List of specifications representing the loop invariant.
	 */
	private List<Specification> spec;
	/**
	 * Class the loop is declared in.
	 */
	private PVLClass corrClass;
	
	private List<Expression> path_condition;

	/**
	 * Standard constructor.
	 * 
	 * @param n         Node -> not used here just needed to extend Expression
	 * @param l         -> not used here just needed to extend Expression
	 * @param cond      Condition of the loop
	 * @param body      Body of the loop
	 * @param corrClass Class this loop is used in
	 */
	public PVLLoopExpression(Node n, String l, Expression cond, List<Expression> body, PVLClass corrClass, List<Expression> path_condition) {
		super(n, l);
		setCondition(cond);
		setLoopBody(body);
		spec = new LinkedList<Specification>();
		this.corrClass = corrClass;
		this.setPathCondition(path_condition);
	}

	/**
	 * Returns the condition.
	 */
	public Expression getCondition() {
		return condition;
	}

	/**
	 * Sets the condition.
	 */
	public void setCondition(Expression condition) {
		this.condition = condition;
	}

	/**
	 * Returns the loop body.
	 */
	public List<Expression> getLoopBody() {
		return loopBody;
	}

	/**
	 * Sets the loop body.
	 */
	public void setLoopBody(List<Expression> loopBody) {
		this.loopBody = loopBody;
	}

	/**
	 * Returns the class the loop is declared in.
	 */
	public PVLClass getCorrClass() {
		return corrClass;
	}

	/**
	 * Sets the class the loop is declared in.
	 */
	public void setCorrClass(PVLClass corrClass) {
		this.corrClass = corrClass;
	}

	/**
	 * Returns the loop invariant.
	 */
	public List<Specification> getSpecifications() {
		return spec;
	}

	/**
	 * Sets the loop invariant.
	 */
	public void setSpecifications(List<Specification> specifications) {
		this.spec = specifications;
	}

	/**
	 * Adds a specification to the loop invariant.
	 */
	public void appendSpecification(Specification s) {
		spec.add(s);

	}

	public List<Expression> getPathCondition() {
		return path_condition;
	}

	public void setPathCondition(List<Expression> path_condition) {
		this.path_condition = path_condition;
	}

}
