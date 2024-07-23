// File: half_adder.h           

#include <systemc.h>          

struct half_adder : sc_module{    
  
    sc_in < bool >   clk  {"clk"};
    sc_in < bool >   rstn {"rstn"};   
     
    sc_in < bool >        a {"a"};         
    sc_in < bool >        b {"b"};               

    sc_out < bool >   sum {"sum"};
    sc_out < bool > carry {"carry"};  

    //bool a, b, sum, carry; 


    SC_CTOR (half_adder) {       
      SC_CTHREAD (prc_half_adder, clk.pos());   
      async_reset_signal_is(rstn, false);
      //sensitive << a << b;        
    }   

    void prc_half_adder(){
      bool s_nand, s_or;
      wait();
      while (true) {			
        s_nand = !(a & b);
        s_or = a | b ;
        sum.write(s_nand & s_or);						
        carry.write(a & b);	
        wait();
      }
    }

};    
  