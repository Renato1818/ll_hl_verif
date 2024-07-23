#include <systemc.h>

SC_MODULE (s7)
{

  sc_in < sc_uint < 6 > >stage1_input;
  sc_out < sc_uint < 4 > >stage1_output;

  void s7_box ();


  SC_CTOR (s7)
  {

    SC_METHOD (s7_box);
    sensitive << stage1_input;
  }
};
