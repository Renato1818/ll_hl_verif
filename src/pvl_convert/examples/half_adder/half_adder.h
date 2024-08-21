#include <systemc.h>          

SC_MODULE (half_adder) {       
  bool a, b, sum, carry; 

  void prc_half_adder(){
		while (true) {			
      wait(5, SC_MS);	
      sum = !(a & b) & (a | b) ;						
      carry = a & b;	
		}
	}

  SC_CTOR (half_adder) {       
    SC_THREAD (prc_half_adder);    
  }   
};    
  