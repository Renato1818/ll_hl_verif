package de.wwu.embdsys.sc2pvl.pvlmodel.specifications;

import de.wwu.embdsys.sc2pvl.pvlmodel.PVLClass;
import de.wwu.embdsys.sc2pvl.pvlmodel.PVLSystem;

public class UnarySpecification extends Specification{
	
	private Specification specification;
	private String operator;
	private boolean prepost;

	public UnarySpecification(PVLClass corr_class, PVLSystem system,boolean prepost, String op, Specification exp) {
		super(corr_class, system);
		this.prepost = prepost;
		this.operator = op;
		setSpecification(exp);
	}

	@Override
	public String toString() {
		if (prepost) {
			if (operator.equals("return") && specification == null) {
				return super.toString() + operator + ";";
			} else {
				return super.toString() + operator
						+ specification.toString().replace(";", "") + ";";
			}
		} else {
			return super.toString() + specification.toString().replace(";", "")
					+ operator + ";";
		}
	}

	public Specification getSpecification() {
		return specification;
	}

	public void setSpecification(Specification specification) {
		this.specification = specification;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public boolean isPrepost() {
		return prepost;
	}

	public void setPrepost(boolean prepost) {
		this.prepost = prepost;
	}
}
