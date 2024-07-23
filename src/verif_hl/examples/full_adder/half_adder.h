// File: half_adder.h           

#include <systemc.h>          

SC_MODULE (half_adder) {        
  /*sc_in  <bool> a;         
  sc_in  <bool> b;               

  sc_out <bool> sum;   
  sc_out <bool> carry;  */

  bool a, b, sum, carry; 

  bool s_nand, s_or;

  void prc_half_adder(){
    wait(2, SC_MS);
		while (true) {			
      s_nand = !(a & b);
      s_or = a | b ;
      sum.write(s_nand & s_or);						
      carry.write(a & b);	
      wait(5, SC_MS);
		}
	}

  SC_CTOR (half_adder) {        
    //SC_THREAD (main_method); 
    SC_THREAD (prc_half_adder);   
    //sensitive << a << b;        
  }   
};    
  