#include <systemc.h>

SC_MODULE(stim) {
	sc_out<bool> sA,sB;
	//sc_in<bool> Clk;

	void StimGen()   {
		sA.write(false);     
		sB.write(false);
		wait();

		sA.write(false);     
		sB.write(true);     
		wait();     
	
		sA.write(true);     
		sB.write(false);     
		wait();     

		sA.write(true);     
		sB.write(true);     
		wait();     
		
		sc_stop();   
	}   

	SC_CTOR(stim)   {
		SC_THREAD(StimGen);     
		//sensitive << Clk.pos();   
	} 
};
