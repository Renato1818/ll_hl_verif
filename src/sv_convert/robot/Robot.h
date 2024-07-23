#include <systemc.h>


typedef sc_uint<16> data_t;
template<int min_dist>

struct Robot : sc_module {
    sc_in <bool>         clk{"clk"};
    sc_in <bool>         rstn{"rstn"};
	
    sc_in <data_t>       dist{"dist"};
    sc_out <bool>      alarm_flag{"alarm_flag"};

	SC_CTOR(Robot) {
		SC_CTHREAD(sensor, clk.pos());
        async_reset_signal_is(rstn, false);

		SC_CTHREAD(controller, clk.pos());
        async_reset_signal_is(rstn, false);
	}

	sc_signal <bool> obs_detected{"obs_detected"};

	void sensor() {
	  obs_detected = false;
	  wait();
	  while(true) {
	      wait(2);
	      if(dist < (data_t)min_dist) {
			  obs_detected = true;
	      }else{
			obs_detected = false;
          }
	   }
	}
	
	void controller() {
	  alarm_flag = false;
	  wait();
	  while (true) {
	    wait(1); 
		if (obs_detected){
			alarm_flag = true;
		} else{
			alarm_flag = false;
        }
		
	  }
	}
};
