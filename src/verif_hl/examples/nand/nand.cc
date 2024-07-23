#include <systemc.h>
#include "nand.h"

/*
void nand_gate::n_gate(void)
  {
  	next_trigger();
    out=( !(A && B) );
  }


int sc_main(int argc, char* argv[]){
    nand_gate nand_inst("thisnand");
    sc_start(5000, SC_NS);
    return 0;
  } */

int sc_main (int argc, char* argv[]) {
    srand(time(NULL));
    nand_gate nand("thisnand");
    sc_start(200 ,SC_MS);
    return(0);
}

