#include <systemc.h>
#include "bit8_adder_new.h"

int sc_main(int argc, char* argv[]){	
	bit8_adder adder("adder");
	sc_start(5000, SC_MS);
	return 0;
} 
