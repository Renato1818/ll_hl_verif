#ifndef PRODUCER_H
#define PRODUCER_H

#include <systemc.h>
#include <iostream>


SC_MODULE(producer)
{
    
    sc_port<sc_clock> p_clock;    
    sc_port<myfifo_if> fifo;

    int pid;

    int produce(int c_param)
    {
      int wait_time = 100;
      wait(wait_time, SC_NS);
      c_param = (c_param + 1)%10;
      return c_param;
    }

    void main_method(void)
    {
      int c = 0;
      
      while(true)
      {
        wait();
        c = produce(c);
        fifo->write(c);
        cout << sc_time_stamp() << " producer: " << c << " written" << std::endl;
      }
    }

    SC_HAS_PROCESS(producer);
    
    producer(sc_module_name name, int i) : sc_module(name)
    {
      pid = i;
	    SC_THREAD(main_method);
	    sensitive << p_clock;
    }

    
};

#endif
