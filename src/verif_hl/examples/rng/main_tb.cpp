#include <systemc.h>
#include "rng.h"


int sc_main(int argc, char* argv[]){	
	rng rn("RN");
	sc_start(5000, SC_MS);
	return 0;
} 
