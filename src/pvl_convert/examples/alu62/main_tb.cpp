#include <systemc.h>
#include "alu62.h"

int sc_main(int argc, char* argv[]){	
	ALU alu("ALU");
	sc_start(5000, SC_NS);
	return 0;
} 

