// File: full_adder.h

//#include "half_adder.h"

SC_MODULE (full_adder) {
  /*sc_in<bool> a, b, carry_in;
  sc_out<bool> sum, carry_out;*/

  bool a, b, carry_in;
  bool sum, carry_out;

  bool c1, s1, c2;
  bool sum_next;
  
  void prc_or () {
    wait(2, SC_MS);
		while (true) {			
      carry_out = (c1 | c2);
      sum = sum_next;
      wait(5, SC_MS);
		}
  }


  void prc_half_adder_1(){
    wait(2, SC_MS);
		while (true) {			
      s1 = sum_(a, b);						
      c1 = (a & b);	
      wait(5, SC_MS);
		}
	}

  void prc_half_adder_2(){
    wait(2, SC_MS);
		while (true) {			
      sum_next = sum_(s1, carry_in);						
      c2 = (s1 & carry_in);	
      wait(5, SC_MS);
		}
	}

  bool sum_(bool a, bool b)  {
    bool s_nand, s_or;

    s_nand = !(a & b);
    s_or = a | b ;

    return (s_nand & s_or);	

  }
  /*
  half_adder ha1_ptr;
  ha1_ptr.a = a;
  ha1_ptr.b = b;
  ha1_ptr.sum = s1;
  ha1_ptr.carry = c1; */

  SC_CTOR (full_adder) {
    /*half_adder ha1_ptr();
    ha1_ptr.a (a);
    ha1_ptr.b (b);
    ha1_ptr.sum (s1);
    ha1_ptr.carry (c1);

    half_adder ha2_ptr();
    ha2_ptr.a (s1);
    ha2_ptr.b (carry_in);
    ha2_ptr.sum (sum);
    ha2_ptr.carry (c2);*/


    SC_THREAD (prc_or);
    //sensitive << c1 << c2;

    SC_THREAD (prc_half_adder_1);
    SC_THREAD (prc_half_adder_2);
    SC_METHOD(sum_);
  }
};
