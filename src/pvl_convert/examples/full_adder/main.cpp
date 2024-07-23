#include <systemc.h>
#include "full_adder.h"


int sc_main(int argc, char* argv[]){	
	full_adder adder("adder");
	sc_start(5000, SC_MS);
	return 0;
} 
