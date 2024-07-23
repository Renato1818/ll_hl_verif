#include <systemc.h>

SC_MODULE (s5)
{

  sc_in < sc_uint < 6 > >stage1_input;
  sc_out < sc_uint < 4 > >stage1_output;

  void s5_box ();


  SC_CTOR (s5)
  {

    SC_METHOD (s5_box);
    sensitive << stage1_input;

  }
};
