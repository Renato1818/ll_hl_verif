#include <systemc.h>


SC_MODULE (bit4_adder) {
  sc_in  <bool> Cin;
  sc_in  <bool> A1, A2, A3, A4;
  sc_in  <bool> B1, B2, B3, B4;

  sc_out <bool> S1, S2, S3, S4;
  sc_out <bool> Cout; 

  //Auxiliar variables to ha1 and fa1
  bool s11, c11, cin_1d;
  bool s1, c1;
  
  //Auxiliar variables to ha2 and fa2
  bool s21, c21, c1_1d;
  bool s2, c2;

  //Auxiliar variables to ha3 and fa3
  bool s31, c31, c2_1d;
  bool s3, c3;
  
  //Auxiliar variables to ha4 and fa4
  bool s41, c41, c3_1d;
  bool s4, c4;

  //Delay Inputs to prevent miss match
  bool a2_1d, a2_2d, b2_1d, b2_2d;
  bool a3_1d, a3_2d, a3_3d, a3_4d, b3_1d, b3_2d, b3_3d, b3_4d;
  bool a4_1d, a4_2d, a4_3d, a4_4d, a4_5d, a4_6d;
  bool b4_1d, b4_2d, b4_3d, b4_4d, b4_5d, b4_6d;

  //Delay Outputs
  bool s1_1d, s1_2d, s1_3d, s1_4d, s1_5d, s1_6d;
  bool s2_1d, s2_2d, s2_3d, s2_4d;
  bool s3_1d, s3_2d;


  void ha_1() {
      s11 = (!(A1 && B1)) && (A1 || B1);
      c11 = (A1 && B1);	
      cin_1d = Cin;

      //Delay Inputs
      a2_1d = A2;
      b2_1d = B2;
      a3_1d = A3;
      b3_1d = B3;
      a4_1d = A4;
      b4_1d = B4;
	}

  void fa_1() {
      s1 = (!(s11 && cin_1d)) && (s11 || cin_1d);
      c1 = (c11 || (s11 && cin_1d));
      
      //Delay inputs
      a2_2d = a2_1d;
      b2_2d = b2_1d;
      a3_2d = a3_1d;
      b3_2d = b3_1d;
      a4_2d = a4_1d;
      b4_2d = b4_1d;
  }

  
  void ha_2() {
      s21 = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
      c21 = (a2_2d && b2_2d);	
      c1_1d = c1;

      //Delay inputs
      a3_3d = a3_2d;
      b3_3d = b3_2d;
      a4_3d = a4_2d;
      b4_3d = b4_2d;

      //Delay output
      s1_1d = s1;
	}
  
  void fa_2 () {		
      s2 = (!(s21 && c1_1d)) && (s21 || c1_1d);
      c2 = (c21 || (s21 && c1_1d));

      //Delay inputs
      a3_4d = a3_3d;
      b3_4d = b3_3d;
      a4_4d = a4_3d;
      b4_4d = b4_3d;

      //Delay output
      s1_2d = s1_1d;
  }

  void ha_3() {
      s31 = (!(a3_4d && b3_4d)) && (a3_4d || b3_4d);
      c31 = (a3_4d && b3_4d);	
      c2_1d = c2;

      
      //Delay inputs
      a4_5d = a4_4d;
      b4_5d = b4_4d;

      //Delay output
      s1_3d = s1_2d;
      s2_1d = s2;
	}

  void fa_3() {
      s3 = (!(s31 && c2_1d)) && (s31 || c2_1d);
      c3 = (c31 || (s31 && c2_1d));
      
      //Delay inputs
      a4_6d = a4_5d;
      b4_6d = b4_5d;
      
      //Delay output
      s1_4d = s1_3d;
      s2_2d = s2_1d;
  }

  
  void ha_4() {
      s41 = (!(a4_6d && b4_6d)) && (a4_6d || b4_6d);
      c41 = (a4_6d && b4_6d);	
      c3_1d = c3;

      //Delay output
      s1_5d = s1_4d;
      s2_3d = s2_2d;
      s3_1d = s3;
	}
  
  void fa_4() {	
      s4 = (!(s41 && c3_1d)) && (s41 || c3_1d);
      c4 = (c41 || (s41 && c3_1d));

      //Delay output
      s1_6d = s1_5d;
      s2_4d = s2_3d;
      s3_2d = s3_1d;

      //Final Outputs
      S1 = s1_6d;
      S2 = s2_4d;
      S3 = s3_2d;
      S4 = s4;
      Cout = c4;
  }

  void process() {
    while (true) {
      wait(5, SC_MS); 

      ha_1(); 
      fa_1();  
      ha_2();
      fa_2();
      ha_3(); 
      fa_3();  
      ha_4();
      fa_4();
    }
  }

  SC_CTOR (bit4_adder){
    SC_THREAD (process);
    
    SC_METHOD (ha_1);
    SC_METHOD (fa_1);
    SC_METHOD (ha_2);
    SC_METHOD (fa_2);    
    SC_METHOD (ha_3);
    SC_METHOD (fa_3);
    SC_METHOD (ha_4);
    SC_METHOD (fa_4);
  }

}; 
