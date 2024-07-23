#include <systemc.h>
#include "half_adder.h"
//#include "driver.h"
//#include "monitor.h"


int sc_main(int argc, char* argv[]){	
	//sc_signal<bool> ASig, BSig,CarrySig,SumSig;   
	//sc_clock TestClk("TestClock", 10, SC_NS,2,SC_NS);  

	half_adder half("HA");
	/*HA1.a(ASig);
	HA1.b(BSig);
	HA1.carry(CarrySig);
	HA1.sum(SumSig);

	/*stim Stim1("Stimulus");   
	Stim1.sA(HA1.a);   
	Stim1.sB(HA1.b);
	Stim1.Clk(TestClk);


  	mon Monitor1("Monitor");   
	Monitor1.A(HA1.a);   
	Monitor1.B(HA1.b);   
	Monitor1.C(CarrySig);   
	Monitor1.S(SumSig);
	Monitor1.Clk(TestClk);  */

	//sc_start();  // run forever  
	sc_start(5000, SC_NS);
	return 0;  
} 
