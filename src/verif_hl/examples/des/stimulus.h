
#include "transactor.h"
#include "scv.h"

//Random number generator

class random_generator:virtual public scv_constraint_base
{
public:

  scv_smart_ptr < sc_uint < 64 > >des_key;
  scv_smart_ptr < sc_uint < 64 > >des_data;

  scv_smart_ptr < bool > decrypt;

  SCV_CONSTRAINT_CTOR (random_generator)
  {
  }
};

class test:public sc_module
{
public:

  sc_port < rw_task_if > transactor;

  void tb ();

    SC_CTOR (test)
  {
    SC_THREAD (tb);
  }
};
