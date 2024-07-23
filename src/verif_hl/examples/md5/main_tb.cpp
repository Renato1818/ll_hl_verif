#include <systemc.h>
#include "md5.h"
//#include "driver.h"
//#include "monitor.h"


int sc_main(int argc, char* argv[]){	
	md5 MD5("HA");
	sc_start(5000, SC_NS);
	return 0;  
} 
