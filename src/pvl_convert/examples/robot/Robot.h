
#define MIN_DIST 50

SC_MODULE(Robot) {

public:
	bool obs_detected;
	int dist_in;

	SC_CTOR(Robot) {
		SC_THREAD(sensor);
		SC_THREAD(controller);
	}

	void sensor() {
	  int dist;
	  while(true) {
	      wait(2, SC_MS);
	      // read from 0 to 255
	      dist = dist_in % 256;
	      // collision possibility detection
	      if(dist < MIN_DIST) {
			  obs_detected = true;
	      }else{
			  obs_detected = false;
          }
	   }
	}
	
	void controller() {
	  bool alarm_flag = false;
	  while (true) {		
	    wait(2, SC_MS);
		if (obs_detected) {
	    	alarm_flag = true;
		}
		else {			
	    	alarm_flag = false;
		}
	  }
	}
};
