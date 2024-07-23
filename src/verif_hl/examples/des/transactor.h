#include <systemc.h>

class transactor_ports:public sc_module
{
public:

  // Ports
  sc_in < bool > clk;
  sc_out < bool > reset;

  //Ports to RT model
  sc_out < bool > rt_load_o;
  sc_out < bool > rt_decrypt_o;
  sc_out < sc_uint < 64 > >rt_des_data_o;
  sc_out < sc_uint < 64 > >rt_des_key_o;
  sc_in < bool > rt_des_ready_i;

  //Ports to C model
  sc_fifo_out < bool > c_decrypt_o;
  sc_fifo_out < sc_uint < 64 > >c_des_key_o;
  sc_fifo_out < sc_uint < 64 > >c_des_data_o;

};


class rw_task_if:virtual public sc_interface
{

public:
  //Funciones para el transactor 
  virtual void resetea (void) = 0;
  virtual void encrypt (sc_uint < 64 > data, sc_uint < 64 > key) = 0;
  virtual void decrypt (sc_uint < 64 > data, sc_uint < 64 > key) = 0;
  virtual void wait_cycles (int cycles) = 0;

};


//Transactor
class des_transactor:public rw_task_if, public transactor_ports
{

public:

  SC_CTOR (des_transactor)
  {

    cout.unsetf (ios::dec);
    cout.setf (ios::hex);

  }


  void resetea (void)
  {
    reset.write (0);
    wait (clk->posedge_event ());
    reset.write (1);
    cout << "Reseted" << endl;
  }

  void encrypt (sc_uint < 64 > data, sc_uint < 64 > key)
  {

    wait (clk->posedge_event ());

    //To RT model
    rt_load_o.write (1);
    rt_des_data_o.write (data);
    rt_des_key_o.write (key);
    rt_decrypt_o.write (0);

    //To C model through fifos
    c_des_data_o.write (data);
    c_des_key_o.write (key);
    c_decrypt_o.write (0);

    wait (clk->posedge_event ());
    rt_load_o.write (0);
    wait (rt_des_ready_i->posedge_event ());
  }

  void decrypt (sc_uint < 64 > data, sc_uint < 64 > key)
  {

    wait (clk->posedge_event ());

    //To RT model
    rt_load_o.write (1);
    rt_des_data_o.write (data);
    rt_des_key_o.write (key);
    rt_decrypt_o.write (1);

    //To C model through fifos
    c_des_data_o.write (data);
    c_des_key_o.write (key);
    c_decrypt_o.write (1);

    wait (clk->posedge_event ());
    rt_load_o.write (0);
    wait (rt_des_ready_i->posedge_event ());

  }

  void wait_cycles (int cycles)
  {
    for (int i = 0; i < cycles; i++)
      {
	wait (clk->posedge_event ());
      }
  }

};
