#ifndef CONSUMER_H
#define CONSUMER_H

#include <systemc.h>
#include <iostream>

SC_MODULE(consumer)
{
    sc_port<myfifo_if> fifo;
    sc_port<sc_clock> c_clock;
    
    void consume(int c_param)
    {
      int wait_time = 200;
      wait(wait_time, SC_NS);
      cout << sc_time_stamp() << " consumer: " << c_param << " read" << std::endl;
    }

    void main_method(void)
    {
      int c = 0;
      while(true)
      {
        wait();
        c = fifo->read();
	consume(c);
      }
    }

    
    SC_CTOR(consumer)
    {
    	SC_THREAD(main_method);
    	sensitive << c_clock;
    }    

};

#endif
