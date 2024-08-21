#include <systemc.h> 

SC_MODULE(full_adder) {   
  sc_in <bool>       clk;
  sc_in <bool>       rstn;

	sc_in < bool >     A1;
	sc_in < bool >     B1;
	sc_in < bool > 	   Cin;

	sc_out < bool > 	 S1;
	sc_out < bool > 	 Cout;

  sc_signal <bool>   s11;
  sc_signal <bool>   c11;
  sc_signal <bool>   cin_1d;
  
  
  void ha_1() {
		while (true) {
      wait();			
      s11 = (!(A1 && B1)) && (A1 || B1);
      c11 = (A1 && B1);	
      cin_1d = Cin;
		}
  }


  void fa_1(){
		while (true) {	
      wait();		
      S1 = (!(s11 && cin_1d)) && (s11 || cin_1d);
      Cout = (c11 || (s11 && cin_1d));
		}
	}

  SC_CTOR(full_adder) {
    SC_CTHREAD (ha_1, clk.pos()); 
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (fa_1, clk.pos()); 
    async_reset_signal_is(rstn, false);
  }

};
