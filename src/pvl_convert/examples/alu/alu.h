#include <systemc.h>

SC_MODULE(ALU) {
	int OPCODE;
	int OP1,OP2;
	bool CARRY, ZERO;
	int RESULT;

    int data1, data2;
    int result;
	int i;
	int bit;

	// Helper function to get the bit at position pos
	int get_bit(int value, int pos) {
		int divisor = 1;
		for (int i = 0; i < pos; i++) {
			divisor = divisor * 2;
		}
		if (divisor != 0) {
			return (value / divisor) % 2;
		}
		else {
			return 0;
		}
	}

	// Manually bitwise shift
	int set_bit(int value, int pos, int bit) {
		int current_bit = get_bit(value, pos);
		int divisor = 1;
		for (i = 0; i < pos; i++) {
			divisor = divisor * 2;
		}
		if (current_bit == bit) {
			return value; 
		} else if (bit == 1) {
			return value + divisor;
		} else {
			return value - divisor;
		}
	}

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
					
				case 4: //and
					for (i = 0; i < 4; i++) {
						bit = get_bit(data1, i) * get_bit(data2, i);
						result = set_bit(result, i, bit);
					}
					break;
					
				case 5: //or
					for (i = 0; i < 4; i++) {
						bit = get_bit(data1, i) + get_bit(data2, i);
						result = set_bit(result, i, bit > 0 ? 1 : 0);
					}
					break;
					
				case 6: //nand
					for (i = 0; i < 4; i++) {
						bit = get_bit(data1, i) * get_bit(data2, i);
						result = set_bit(result, i, bit ? 0 : 1);
					}
					break;
					
				case 7: //xor
					for (i = 0; i < 4; i++) {
						bit = get_bit(data1, i) + get_bit(data2, i);
						result = set_bit(result, i, bit == 1 ? 1 : 0);
					}
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
		SC_METHOD(get_bit);
		SC_METHOD(set_bit);
	}
};
