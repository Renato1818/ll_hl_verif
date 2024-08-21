#include <systemc.h> 

SC_MODULE (bit2_adder) {
  sc_in <bool>       clk;
  sc_in <bool>       rstn;

  sc_in  <bool> Cin, A1, A2, B1, B2;
  sc_out <bool> S1, S2, Cout;

  //Auxiliar variables to ha1 and fa1
  sc_signal <bool> s11, c11, cin_1d;
  sc_signal <bool> s1, c1;
  
  //Auxiliar variables to ha2 and fa2
  sc_signal <bool> s21, c21, c1_1d;
  sc_signal <bool> s2, c2;

  //Delay 2nd Inputs
  sc_signal <bool> a2_1d, a2_2d, b2_1d, b2_2d;
  //Delay 1st Output
  sc_signal <bool> s1_1d, s1_2d;


  void ha_1(){
    wait();
		while (true) {			
      s11 = (!(A1 && B1)) && (A1 || B1);
      c11 = (A1 && B1);	
      cin_1d = Cin;

      //Delay 2nd inputs
      a2_1d = A2;
      b2_1d = B2;
      wait();
		}
	}

  void fa_1 () {
    wait();
		while (true) {			
      s1 = (!(s11 && cin_1d)) && (s11 || cin_1d);
      c1 = (c11 || (s11 && cin_1d));
      
      //Delay 2nd inputs
      a2_2d = a2_1d;
      b2_2d = b2_1d;
      wait();
		}
  }

  
  void ha_2(){
    wait();
		while (true) {			
      s21 = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
      c21 = (a2_2d && b2_2d);	
      c1_1d = c1;

      //Delay 1st Output
      s1_1d = s1;
      wait();
		}
	}
  
  void fa_2 () {
    wait();
		while (true) {				
      s2 = (!(s21 && c1_1d)) && (s21 || c1_1d);
      c2 = (c21 || (s21 && c1_1d));

      //Delay 1st Output
      s1_2d = s1_1d;

      //Final Outputs
      S1 = s1_2d;
      S2 = s2;
      Cout = c2;
      wait();
		}
  }


  SC_CTOR (bit2_adder){
    SC_CTHREAD (ha_1, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_1, clk.pos());
    async_reset_signal_is(rstn, false);
    
    SC_CTHREAD (ha_2, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_2, clk.pos());
    async_reset_signal_is(rstn, false);
  }

}; 