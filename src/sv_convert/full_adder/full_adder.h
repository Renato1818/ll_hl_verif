#include <systemc.h> 

struct full_adder : sc_module {   
  sc_in <bool>       clk{"clk"};
  sc_in <bool>       rstn{"rstn"};

	sc_in < bool >     a {"a"};
	sc_in < bool >     b {"b"};
	sc_in < bool > 	   carry_in {"carry_in"};

	sc_out < bool > 	 sum {"sum"};
	sc_out < bool > 	 carry_out {"carry_out"};

  sc_signal <bool>   c1 {"c1"};
  sc_signal <bool>   s1 {"s1"};
  sc_signal <bool>   c2 {"c2"};
  sc_signal <bool>   sum_next {"sum_next"};
  
  
  SC_CTOR(full_adder) {
    SC_CTHREAD (prc_or, clk.pos()); 
    async_reset_signal_is(rstn, false);

    SC_CTHREAD (prc_half_adder_1, clk.pos());     
    async_reset_signal_is(rstn, false);
    SC_CTHREAD (prc_half_adder_2, clk.pos()); 
    async_reset_signal_is(rstn, false);
  }

  void prc_or () {
    wait();
		while (true) {			
      carry_out = (c1 | c2);
      sum = sum_next;
      wait();
		}
  }


  void prc_half_adder_1(){
    wait();
		while (true) {			
      s1 = sum_(a, b);						
      c1 = (a & b);	
      wait();
		}
	}

  void prc_half_adder_2(){
    wait();
		while (true) {			
      sum_next = sum_(s1, carry_in);						
      c2 = (s1 & carry_in);	
      wait();
		}
	}

  bool sum_(bool a, bool b)  {
    bool s_nand, s_or;

    s_nand = !(a & b);
    s_or = a | b ;

    return (s_nand & s_or);	
  }
};
