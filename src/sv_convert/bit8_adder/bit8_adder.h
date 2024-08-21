//#include "full_adder.h"


SC_MODULE (bit8_adder) {
  sc_in <bool>       clk;
  sc_in <bool>       rstn;

  sc_in  <bool> Cin;
  sc_in  <bool> A1, A2, A3, A4, A5, A6, A7, A8;
  sc_in  <bool> B1, B2, B3, B4, B5, B6, B7, B8;

  sc_out <bool> S1, S2, S3, S4, S5, S6, S7, S8;
  sc_out <bool> Cout; 

  //Auxiliar variables to ha1 and fa1
  sc_signal <bool> s11, c11, cin_1d;
  sc_signal <bool> s1, c1;
  
  //Auxiliar variables to ha2 and fa2
  sc_signal <bool> s21, c21, c1_1d;
  sc_signal <bool> s2, c2;

  //Auxiliar variables to ha3 and fa3
  sc_signal <bool> s31, c31, c2_1d;
  sc_signal <bool> s3, c3;
  
  //Auxiliar variables to ha4 and fa4
  sc_signal <bool> s41, c41, c3_1d;
  sc_signal <bool> s4, c4;

  //Auxiliar variables to ha5 and fa5
  sc_signal <bool> s51, c51, c4_1d;
  sc_signal <bool> s5, c5;
  
  //Auxiliar variables to ha6 and fa6
  sc_signal <bool> s61, c61, c5_1d;
  sc_signal <bool> s6, c6;

  //Auxiliar variables to ha7 and fa7
  sc_signal <bool> s71, c71, c6_1d;
  sc_signal <bool> s7, c7;
  
  //Auxiliar variables to ha8 and fa8
  sc_signal <bool> s81, c81, c7_1d;
  sc_signal <bool> s8, c8;

  //Delay Inputs to prevent miss match
  sc_signal <bool> a2_1d, a2_2d;
  sc_signal <bool> b2_1d, b2_2d;
  sc_signal <bool> a3_1d, a3_2d, a3_3d, a3_4d;
  sc_signal <bool> b3_1d, b3_2d, b3_3d, b3_4d;
  sc_signal <bool> a4_1d, a4_2d, a4_3d, a4_4d, a4_5d, a4_6d;
  sc_signal <bool> b4_1d, b4_2d, b4_3d, b4_4d, b4_5d, b4_6d;
  sc_signal <bool> a5_1d, a5_2d, a5_3d, a5_4d, a5_5d, a5_6d, a5_7d, a5_8d;
  sc_signal <bool> b5_1d, b5_2d, b5_3d, b5_4d, b5_5d, b5_6d, b5_7d, b5_8d;
  sc_signal <bool> a6_1d, a6_2d, a6_3d, a6_4d, a6_5d, a6_6d, a6_7d, a6_8d, a6_9d, a6_10d;
  sc_signal <bool> b6_1d, b6_2d, b6_3d, b6_4d, b6_5d, b6_6d, b6_7d, b6_8d, b6_9d, b6_10d;
  sc_signal <bool> a7_1d, a7_2d, a7_3d, a7_4d, a7_5d, a7_6d, a7_7d, a7_8d, a7_9d, a7_10d, a7_11d, a7_12d;
  sc_signal <bool> b7_1d, b7_2d, b7_3d, b7_4d, b7_5d, b7_6d, b7_7d, b7_8d, b7_9d, b7_10d, b7_11d, b7_12d;
  sc_signal <bool> a8_1d, a8_2d, a8_3d, a8_4d, a8_5d, a8_6d, a8_7d, a8_8d, a8_9d, a8_10d, a8_11d, a8_12d, a8_13d, a8_14d;
  sc_signal <bool> b8_1d, b8_2d, b8_3d, b8_4d, b8_5d, b8_6d, b8_7d, b8_8d, b8_9d, b8_10d, b8_11d, b8_12d, b8_13d, b8_14d;

  //Delay Outputs
  sc_signal <bool> s1_1d, s1_2d, s1_3d, s1_4d, s1_5d, s1_6d, s1_7d, s1_8d, s1_9d, s1_10d, s1_11d, s1_12d, s1_13d, s1_14d;
  sc_signal <bool> s2_1d, s2_2d, s2_3d, s2_4d, s2_5d, s2_6d, s2_7d, s2_8d, s2_9d, s2_10d, s2_11d, s2_12d;
  sc_signal <bool> s3_1d, s3_2d, s3_3d, s3_4d, s3_5d, s3_6d, s3_7d, s3_8d, s3_9d, s3_10d;
  sc_signal <bool> s4_1d, s4_2d, s4_3d, s4_4d, s4_5d, s4_6d, s4_7d, s4_8d;
  sc_signal <bool> s5_1d, s5_2d, s5_3d, s5_4d, s5_5d, s5_6d;
  sc_signal <bool> s6_1d, s6_2d, s6_3d, s6_4d;
  sc_signal <bool> s7_1d, s7_2d;


  void ha_1() {
    //wait(2, SC_MS);
		while (true) {			
      wait();
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
      b5_1d = B5;
      a5_1d = A5;
      b6_1d = B6;
      a6_1d = A6;
      b7_1d = B7;
      a7_1d = A7;
      b8_1d = B8;
      a8_1d = A8;
		}
	}

  void fa_1() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s1 = (!(s11 && cin_1d)) && (s11 || cin_1d);
      c1 = (c11 || (s11 && cin_1d));
      
      //Delay inputs
      a2_2d = a2_1d;
      b2_2d = b2_1d;
      a3_2d = a3_1d;
      b3_2d = b3_1d;
      a4_2d = a4_1d;
      b4_2d = b4_1d;
      a5_2d = a5_1d;
      b5_2d = b5_1d;
      a6_2d = a6_1d;
      b6_2d = b6_1d;
      a7_2d = a7_1d;
      b7_2d = b7_1d;
      a8_2d = a8_1d;
      b8_2d = b8_1d;
		}
  }

  void ha_2() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s21 = (!(a2_2d && b2_2d)) && (a2_2d || b2_2d);
      c21 = (a2_2d && b2_2d);	
      c1_1d = c1;

      //Delay inputs
      a3_3d = a3_2d;
      b3_3d = b3_2d;
      a4_3d = a4_2d;
      b4_3d = b4_2d;
      a5_3d = a6_2d;
      b5_3d = b6_2d;
      a6_3d = a6_2d;
      b6_3d = b6_2d;
      a7_3d = a7_2d;
      b7_3d = b7_2d;
      a8_3d = a8_2d;
      b8_3d = b8_2d;

      //Delay output
      s1_1d = s1;
		}
	}
  
  void fa_2 () {
    //wait(2, SC_MS);
		while (true) {	
      wait();			
      s2 = (!(s21 && c1_1d)) && (s21 || c1_1d);
      c2 = (c21 || (s21 && c1_1d));

      //Delay inputs
      a3_4d = a3_3d;
      b3_4d = b3_3d;
      a4_4d = a4_3d;
      b4_4d = b4_3d;
      a5_4d = a6_3d;
      b5_4d = b6_3d;
      a6_4d = a6_3d;
      b6_4d = b6_3d;
      a7_4d = a7_3d;
      b7_4d = b7_3d;
      a8_4d = a8_3d;
      b8_4d = b8_3d;

      //Delay output
      s1_2d = s1_1d;
		}
  }

  void ha_3() {
    //wait(2, SC_MS);
		while (true) {			
      wait();
      s31 = (!(a3_4d && b3_4d)) && (a3_4d || b3_4d);
      c31 = (a3_4d && b3_4d);	
      c2_1d = c2;

      
      //Delay inputs
      a4_5d = a4_4d;
      b4_5d = b4_4d;
      a5_5d = a6_4d;
      b5_5d = b6_4d;
      a6_5d = a6_4d;
      b6_5d = b6_4d;
      a7_5d = a7_4d;
      b7_5d = b7_4d;
      a8_5d = a8_4d;
      b8_5d = b8_4d;

      //Delay output
      s1_3d = s1_2d;
      s2_1d = s2;
		}
	}

  void fa_3() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s3 = (!(s31 && c2_1d)) && (s31 || c2_1d);
      c3 = (c31 || (s31 && c2_1d));
      
      //Delay inputs
      a4_6d = a4_5d;
      b4_6d = b4_5d;
      a5_6d = a6_5d;
      b5_6d = b6_5d;
      a6_6d = a6_5d;
      b6_6d = b6_5d;
      a7_6d = a7_5d;
      b7_6d = b7_5d;
      a8_6d = a8_5d;
      b8_6d = b8_5d;
      
      //Delay output
      s1_4d = s1_3d;
      s2_2d = s2_1d;
		}
  }

  void ha_4() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s41 = (!(a4_6d && b4_6d)) && (a4_6d || b4_6d);
      c41 = (a4_6d && b4_6d);	
      c3_1d = c3;

      //Delay inputs
      a5_7d = a6_6d;
      b5_7d = b6_6d;
      a6_7d = a6_6d;
      b6_7d = b6_6d;
      a7_7d = a7_6d;
      b7_7d = b7_6d;
      a8_7d = a8_6d;
      b8_7d = b8_6d;

      //Delay output
      s1_5d = s1_4d;
      s2_3d = s2_2d;
      s3_1d = s3;
		}
	}
  
  void fa_4() {
    //wait(2, SC_MS);
		while (true) {	
      wait();			
      s4 = (!(s41 && c3_1d)) && (s41 || c3_1d);
      c4 = (c41 || (s41 && c3_1d));

      //Delay inputs
      a5_8d = a6_7d;
      b5_8d = b6_7d;
      a6_8d = a6_7d;
      b6_8d = b6_7d;
      a7_8d = a7_7d;
      b7_8d = b7_7d;
      a8_8d = a8_7d;
      b8_8d = b8_7d;

      //Delay output
      s1_6d = s1_5d;
      s2_4d = s2_3d;
      s3_2d = s3_1d;
		}
  }


  void ha_5() {
    //wait(2, SC_MS);
		while (true) {			
      wait();
      s51 = (!(a5_8d && b5_8d)) && (a5_8d || b5_8d);
      c51 = (a5_8d && b5_8d);	
      c4_1d = c4;

      //Delay inputs
      a6_9d = a6_8d;
      b6_9d = b6_8d;
      a7_9d = a7_8d;
      b7_9d = b7_8d;
      a8_9d = a8_8d;
      b8_9d = b8_8d;

      //Delay output
      s1_7d = s1_6d;
      s2_5d = s2_4d;
      s3_3d = s3_2d;
      s4_1d = s4;
		}
	}

  void fa_5() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s5 = (!(s51 && c4_1d)) && (s51 || c4_1d);
      c5 = (c51 || (s51 && c4_1d));
      
      //Delay inputs
      a6_10d = a6_9d;
      b6_10d = b6_9d;
      a7_10d = a7_9d;
      b7_10d = b7_9d;
      a8_10d = a8_9d;
      b8_10d = b8_9d;

      //Delay output
      s1_8d = s1_7d;
      s2_6d = s2_5d;
      s3_4d = s3_3d;
      s4_2d = s4_1d;
		}
  }

  void ha_6() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s61 = (!(a6_10d && b6_10d)) && (a6_10d || b6_10d);
      c61 = (a6_10d && b6_10d);	
      c5_1d = c5;

      //Delay inputs
      a7_11d = a7_10d;
      b7_11d = b7_10d;
      a8_11d = a8_10d;
      b8_11d = b8_10d;

      //Delay output
      s1_9d = s1_8d;
      s2_7d = s2_6d;
      s3_5d = s3_4d;
      s4_3d = s4_2d;
      s5_1d = s5;
		}
	}
  
  void fa_6 () {
    //wait(2, SC_MS);
		while (true) {	
      wait();			
      s6 = (!(s61 && c5_1d)) && (s61 || c5_1d);
      c6 = (c61 || (s61 && c5_1d));

      //Delay inputs
      a7_12d = a7_11d;
      b7_12d = b7_11d;
      a8_12d = a8_11d;
      b8_12d = b8_11d;

      //Delay output
      s1_10d = s1_9d;
      s2_8d  = s2_7d;
      s3_6d  = s3_5d;
      s4_4d  = s4_3d;
      s5_2d  = s5_1d;
		}
  }

  void ha_7() {
    //wait(2, SC_MS);
		while (true) {			
      wait();
      s71 = (!(a7_12d && b7_12d)) && (a7_12d || b7_12d);
      c71 = (a7_12d && b7_12d);	
      c6_1d = c6;

      
      //Delay inputs
      a8_13d = a8_12d;
      b8_13d = b8_12d;

      //Delay output
      s1_11d = s1_10d;
      s2_9d  = s2_8d;
      s3_7d  = s3_6d;
      s4_5d  = s4_4d;
      s5_3d  = s5_2d;
      s6_1d = s6;
		}
	}

  void fa_7() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s7 = (!(s71 && c6_1d)) && (s71 || c6_1d);
      c7 = (c71 || (s71 && c6_1d));
      
      //Delay inputs
      a8_14d = a8_13d;
      b8_14d = b8_13d;

      //Delay output
      s1_12d = s1_11d;
      s2_10d = s2_9d;
      s3_8d  = s3_7d;
      s4_6d  = s4_5d;
      s5_4d  = s5_3d;
      s6_2d  = s6_1d;
		}
  }

  void ha_8() {
    //wait(2, SC_MS);
		while (true) {		
      wait();	
      s81 = (!(a8_14d && b8_14d)) && (a8_14d || b8_14d);
      c81 = (a8_14d && b8_14d);	
      c7_1d = c7;

      //Delay output
      s1_13d = s1_12d;
      s2_11d = s2_10d;
      s3_9d  = s3_8d;
      s4_7d  = s4_6d;
      s5_5d  = s5_4d;
      s6_3d  = s6_2d;
      s7_1d  = s7;
		}
	}
  
  void fa_8() {
    //wait(2, SC_MS);
		while (true) {	
      wait();			
      s8 = (!(s81 && c7_1d)) && (s81 || c7_1d);
      c8 = (c81 || (s81 && c7_1d));

      //Delay output
      s1_14d = s1_13d;
      s2_12d = s2_11d;
      s3_10d = s3_9d;
      s4_8d  = s4_7d;
      s5_6d  = s5_5d;
      s6_4d  = s6_3d;
      s7_2d  = s7_1d;

      //Final Outputs
      S1 = s1_14d;
      S2 = s2_12d;
      S3 = s3_10d;
      S4 = s4_8d;
      S5 = s5_6d;
      S6 = s6_4d;
      S7 = s7_2d;
      S8 = s8;
      Cout = c8;
		}
  }

  SC_CTOR (bit8_adder){
    SC_CTHREAD (ha_1, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_1, clk.pos());
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_2, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_2, clk.pos());    
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_3, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_3, clk.pos());
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_4, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_4, clk.pos());
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_5, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_5, clk.pos());
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_6, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_6, clk.pos());    
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_7, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_7, clk.pos());
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (ha_8, clk.pos());
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (fa_8, clk.pos());
    async_reset_signal_is(rstn, false);
  }

}; 
