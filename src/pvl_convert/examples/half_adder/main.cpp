#include <systemc.h>
#include "half_adder.h"


int sc_main(int argc, char* argv[]){	
	half_adder half("HA");
	sc_start(5000, SC_NS);
	return 0;  
} 
