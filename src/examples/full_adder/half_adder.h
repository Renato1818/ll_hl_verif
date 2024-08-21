#include <systemc.h>          

SC_MODULE (half_adder) {     
  sc_in  <bool> a, b;
  sc_out <bool> sum, carry; 

  void prc_half_adder(){
		while (true) {		
      wait(5, SC_MS);	      
      sum.write(a ^ b);						
      carry.write(a & b);	
		}
	}

  SC_CTOR (half_adder) {        
    SC_THREAD (prc_half_adder);   
  }   
};    
  