
#define MIN_DIST 50

SC_MODULE(Robot) {

public:
	sc_event obs_detected;
	//bool obs_detected;

	SC_CTOR(Robot) {
		SC_THREAD(sensor);
		SC_THREAD(controller);
	}

	void sensor() {
	  int dist;
	  //int dist = 256;
	  while(true) {
	      wait(2, SC_MS);
	      // read from sensor values between 0 and 255
	      dist = rand() % 256;
	      // collision possibility detection
	      if(dist < MIN_DIST) {
              cout << "Obstacle detected. \n";
		      obs_detected.notify(SC_ZERO_TIME);
			  obs_detected = true;
	      }else{
              cout << "No obstacle around. \n";
			  obs_detected = false;
          }
	   }
	}
	
	void controller() {
	  bool alarm_flag = false;
	  while (true) {
	    // waiting for event
	    //wait(obs_detected);
        cout << "Setting the flag. \n";
		
	    wait(2, SC_MS);
		if (obs_detected) {
	    	alarm_flag = true;
		}
		else {			
	    	alarm_flag = false;
		}
		
	    //alarm_flag = true;
	  }
	}
};
