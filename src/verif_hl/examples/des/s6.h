#include <systemc.h>

SC_MODULE (s6)
{

  sc_in < sc_uint < 6 > >stage1_input;
  sc_out < sc_uint < 4 > >stage1_output;

  void s6_box ();

  SC_CTOR (s6)
  {

    SC_METHOD (s6_box);
    sensitive << stage1_input;

  }
};
