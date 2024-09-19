#include <systemc.h>

SC_MODULE(ALU) {
	int OPCODE;
	int OP1,OP2;
	bool CARRY, ZERO;
	int RESULT;

    int data1, data2;
    int result;

    void operate()	{
		while(true){
      		wait(5, SC_MS);
			ZERO = false;
			data1 = OP1 % 16;
			data2 = OP2 % 16;
			
			switch(OPCODE % 8){					
				case 0: //addition
					result = data1 + data2;
					break;
					
				case 1: //subtration
					result = data1 - data2;
					break;
					
				case 2: //increment
					result = data1 + 1;
					break;
					
				case 3: //decrement
					result = data1 - 1;
					break;
					
			}
			
			RESULT = (result % 16);  // Ensuring RESULT is 4-bit
			CARRY = ((result / 16) % 2); 
			if((result % 16) == 0)
				ZERO = (true);
								
		}
	}
    
	SC_CTOR(ALU){
		SC_THREAD(operate);
	}
};
