#include <systemc.h>

SC_MODULE(full_adder) {
  bool Cin, A1, B1;
  bool S1, Cout;

  bool s11, c11, cin_1d;

  void ha_1() {
    s11 = (!(A1 && B1)) && (A1 || B1);
    c11 = (A1 && B1);	
    cin_1d = Cin;
  }

  void fa_1() {
    S1 = (!(s11 && cin_1d)) && (s11 || cin_1d);
    Cout = (c11 || (s11 && cin_1d));
  }

  void process() {
    while (true) {
      wait(5, SC_MS); 
      ha_1(); 
      fa_1();  
    }
  }

  SC_CTOR (full_adder) {  
    SC_THREAD (process);
    SC_METHOD (ha_1);
    SC_METHOD (fa_1);    
  }
};
