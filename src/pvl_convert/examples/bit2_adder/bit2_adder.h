#include <systemc.h>


SC_MODULE (bit2_adder) {
  bool Cin, A1, A2, B1, B2;
  bool S1, S2, Cout; 

  //Auxiliar variables to ha1 and fa1
  bool s11, c11, cin_1d;
  bool s1, c1;
  
  //Auxiliar variables to ha2 and fa2
  bool s21, c21, c1_1d;
  bool s2, c2;

  //Delay 2nd Inputs
  bool a2_1d, a2_2d, b2_1d, b2_2d;
  //Delay 1st Output
  bool s1_1d, s1_2d;


  void ha_1(){
    s11 = (!(A1 && B1)) && (A1 || B1);
    c11 = (A1 && B1);	
    cin_1d = Cin;

    //Delay 2nd inputs
    a2_1d = A2;
    b2_1d = B2;
	}

  void fa_1 () {
    s1 = (!(s11 && cin_1d)) && (s11 || cin_1d);
    c1 = (c11 || (s11 && cin_1d));
    
    //Delay 2nd inputs
    a2_2d = a2_1d;
    b2_2d = b2_1d;
  }

  
  void ha_2(){
    s21 = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
    c21 = (a2_2d && b2_2d);	
    c1_1d = c1;

    //Delay 1st Output
    s1_1d = s1;
	}
  
  void fa_2 () {	
    s2 = (!(s21 && c1_1d)) && (s21 || c1_1d);
    c2 = (c21 || (s21 && c1_1d));

    //Delay 1st Output
    s1_2d = s1_1d;

    //Final Outputs
    S1 = s1_2d;
    S2 = s2;
    Cout = c2;
  }

  void process() {
    while (true) {
      wait(5, SC_MS); 

      ha_1(); 
      fa_1();  
      ha_2();
      fa_2();
    }
  }

  SC_CTOR (bit2_adder){
    SC_THREAD (process);

    SC_METHOD (ha_1);
    SC_METHOD (fa_1);

    SC_METHOD (ha_2);
    SC_METHOD (fa_2);
  }

}; 
