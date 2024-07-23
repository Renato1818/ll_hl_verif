#ifndef NANDGATE_H_
#define NANDGATE_H_

#include <systemc.h>

SC_MODULE(nand_gate)          // declare nand sc_module
{
    bool A, B;       // input signal ports
    bool out;         // output signal ports

    sc_event event;

  SC_CTOR(nand_gate) {
    SC_THREAD(write_a);
    SC_THREAD(write_b);
    SC_THREAD(read);

    A = true;
    B = false;
    out = false;
  }
  
  void write_a(){
    bool a = true;
    while (true)
    {
      A = a;
      a = !a;
      wait(5, SC_SEC);
    }
    
  }
  void write_b(){
    bool b = true;
    while (true)
    {
      B = b;
      b = !b;
      wait(3, SC_SEC);
    }
    
  }

  int read(void){
    while (true)
    {
      wait(event);
      out = ( !(A && B) );
      cout << sc_time_stamp() << "out = " << out << std::endl;
    }    
    return 1;
  }


  /*
  void n_gate(void){        // a C++ function  {
  	next_trigger();
    out = ( !(A && B) );
  }

  SC_CTOR(nand_gate)          // constructor for nand2
  {
    //SC_THREAD(n_gate)
    SC_THREAD(main_method);  // register nand with kernel
    //sensitive << A << B;  // sensitivity list
  }
  
  void nand_gate::n_gate(void)
  {
  	next_trigger();
    out=( !(A && B) );
  }*/


};
#endif /* NANDGATE_H_ */
