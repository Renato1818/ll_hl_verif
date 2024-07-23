#include <systemc.h>

SC_MODULE(ALU) {
	/*sc_in < sc_uint<3> > OPCODE;
	sc_in < sc_uint<4> > OP1,OP2;
	sc_out < bool > CARRY, ZERO;
	sc_out < sc_uint<4> > RESULT;

    sc_uint<4> data1, data2;
    sc_uint<5> result;*/

	int OPCODE;
	int OP1,OP2;
	bool CARRY, ZERO;
	int RESULT;

    int data1, data2;
    int result;
	int i;
	int bit;


	SC_CTOR(ALU){
		SC_THREAD(operate);
		//sensitive << OP1 << OP2 << OPCODE;
		//OP1 = 0;
		//OP2 = 0;
		//OPCODE = 0;
		SC_METHOD(get_bit);
		SC_METHOD(set_bit);
	}

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
    	wait(2, SC_MS);
		while(true){
			ZERO = false;
			data1 = OP1.read() % 16;
			data2 = OP2.read() % 16;
			
			switch(OPCODE.read() % 8)
			{					
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
			
			RESULT.write(result % 16);  // Ensuring RESULT is 4-bit
			CARRY.write((result / 16) % 2); 
			if((result % 16) == 0)
				ZERO.write(true);
			/*
			RESULT.write(result.range(3, 0));			
			CARRY.write((bool) result[4]);			
			if(result == 0)
				ZERO.write(true);*/
			
			
      		wait(5, SC_MS);
		}
	}
    
};
/*
				case 4: //and
					result = data1 & data2;
					break;
					
				case 5:
					result = data1 | data2;
					break;
					
				case 6:
					result.range(3, 0) = ~(data1 & data2);
					break;
					
				case 7:
					result = data1 ^ data2;
					break;
					*/