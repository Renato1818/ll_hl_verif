#include <systemc.h>
#include "alu.h"

int sc_main(int argc, char* argv[]){	
	ALU alu("ALU");
	sc_start(5000, SC_NS);	
	return 0;
} 
