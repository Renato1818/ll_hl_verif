#ifndef NANDGATE_H_
#define NANDGATE_H_

#include <systemc.h>

SC_MODULE(nand_gate)          // declare nand sc_module
{
  sc_in<bool> A, B;       // input signal ports
  sc_out<bool> out;         // output signal ports

  sc_event event;

  void n_gate(void);        // a C++ function  {

  SC_CTOR(nand_gate)          // constructor for nand2
  {
    //SC_THREAD(n_gate)
    SC_THREAD(main_method);  // register nand with kernel
    //sensitive << A << B;  // sensitivity list
  }
  
  /*void nand_gate::n_gate(void)
  {
  	next_trigger();
    out=( !(A && B) );
  }*/

  void main_method(void){
    wait(event);
    out =( !(A && B) );
  }

};
#endif /* NANDGATE_H_ */
