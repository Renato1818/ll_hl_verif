package de.wwu.embdsys.sc2pvl.pvlmodel;

public class PVLEventVariable {

	private int event_id;
	
	public PVLEventVariable(int id) {
		event_id = id;
	}

	public int getEventId() {
		return event_id;
	}

	public void setEventId(int event_id) {
		this.event_id = event_id;
	}
	
	public String toString() {
		return "" + event_id;
	}
}
