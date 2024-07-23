
#include <systemc.h>

//#define  MIN_DIST 50

typedef sc_uint<16> data_t;
template<int min_dist>

//SC_MODULE(Robot) 
struct Robot : sc_module
{
	//typedef sc_uint<16> data_t;

	//sc_event obs_detected;
    sc_in<bool>         clk{"clk"};
    sc_in<bool>         rstn{"rstn"};
	
    sc_in<data_t>       dist{"dist"};
    sc_out<bool>      alarm_flag{"alarm_flag"};



	SC_CTOR(Robot) {
		SC_CTHREAD(sensor, clk.pos());
        async_reset_signal_is(rstn, false);

		SC_CTHREAD(controller, clk.pos());
        async_reset_signal_is(rstn, false);
		//sensitive << obs_detected;
	}

	sc_signal<bool> obs_detected{"obs_detected"};

	void sensor() {
	  //int dist = 256;
	  obs_detected = false;
	  wait();
	  while(true) {
	      wait(2);
	      // read from sensor values between 0 and 255
	      //dist = rand() % 256;
	      // collision possibility detection
	      if(dist < (data_t)min_dist) {
              cout << "Obstacle detected. \n";
			  obs_detected = true;
		      //obs_detected.notify(SC_ZERO_TIME);
	      }else{
			obs_detected = false;
            cout << "No obstacle around. \n";
          }
	   }
	}
	
	void controller() {
	  alarm_flag = false;
	  wait();
	  while (true) {
	    // waiting for event
	    wait(1); 
		if (obs_detected){
			alarm_flag = true;
        	cout << "Setting the flag. \n";
		}
		
	  }
	}
};
