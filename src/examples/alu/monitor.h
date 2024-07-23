#include <systemc.h>

SC_MODULE(monitor){
	sc_in < sc_uint<3> > m_OPCODE;
	sc_in < sc_uint<4> > m_OP1, m_OP2;
	sc_in < bool > m_CARRY, m_ZERO;
	sc_in < sc_uint<4> > m_RESULT;

	sc_event obs_detected;
	
	void main_method(void){
		while (true) 
		{
			// waiting for event
			wait(obs_detected);
			cout << "at " << sc_time_stamp() << " OPCODE is:" 
			<< m_OPCODE << " inputs are: | " << m_OP1 << " | " 
			<< m_OP2 << " outputs are: | ";
			cout << m_CARRY << " | " << m_ZERO << " | " << m_RESULT << endl;
			//<<" input is: "<<m_din
		}
	}
	
	SC_CTOR(monitor){
		SC_METHOD(main_method);
		//sensitive<<m_OPCODE<<m_RESULT;
		//dont_initialize();
	}
};
