#include <systemc.h>
#include "ALU.h"


int sc_main(int argc, char* argv[]){	
	ALU alu("ALU");	
	//simulation start
	sc_start(5000, SC_NS);
	
	return 0;
} 
