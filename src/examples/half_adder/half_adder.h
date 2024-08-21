#include <systemc.h>          

SC_MODULE (half_adder) {        
  sc_in  <bool> a;         
  sc_in  <bool> b;               

  sc_out <bool> sum;   
  sc_out <bool> carry;  

  bool s_nand, s_or;

  void prc_half_adder(){
		while (true) {		
      wait(5, SC_MS);	
      s_nand = !(a & b);
      s_or = a | b ;

      sum.write(s_nand & s_or);						
      carry.write(a & b);	
		}
	}

  SC_CTOR (half_adder) {        
    SC_THREAD (prc_half_adder);   
  }   
};    
  