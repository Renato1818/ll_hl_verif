#include <systemc.h>
#include "bit2_adder.h"


int sc_main(int argc, char* argv[]){	
	bit2_adder adder("adder");
	sc_start(5000, SC_MS);
	return 0;
} 
