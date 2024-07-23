#include<systemc.h>

SC_MODULE(monitor){
	sc_in<bool> m_A, m_B, m_out;
	
	void monita(void)
	{
		cout<<"at "<<sc_time_stamp()<<" input is: "<<m_A<<" and "<<m_B<<", output is: | "<<m_out<<" | "<<endl;
	}
	
	SC_CTOR(monitor){
		SC_METHOD(monita);
		//sensitive<<m_A<<m_B<<m_out;
		dont_initialize();
	}
};
