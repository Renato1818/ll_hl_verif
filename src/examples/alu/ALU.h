#include <systemc.h>

SC_MODULE(ALU) {
	sc_in < sc_uint<3> > OPCODE;
	sc_in < sc_uint<4> > OP1,OP2;
	sc_out < bool > CARRY, ZERO;
	sc_out < sc_uint<4> > RESULT;

    sc_uint<4> data1, data2;
    sc_uint<5> result;

	SC_CTOR(ALU){
		SC_THREAD(operate);
	}

    void operate()	{
    	wait(2, SC_MS);
		while(true){
			ZERO = false;
			data1 = OP1.read();
			data2 = OP2.read();
			
			switch(OPCODE.read())
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
					result = data1 & data2;
					break;
					
				case 5: //or
					result = data1 | data2;
					break;
					
				case 6: //nand
					result.range(3, 0) = ~(data1 & data2);
					break;
					
				case 7: //xor
					result = data1 ^ data2;
					break;
			}
			
			RESULT.write(result.range(3, 0));			
			CARRY.write((bool) result[4]);			
			if(result == 0)
				ZERO.write(true);
			
			
      		wait(5, SC_MS);
		}
	}
    
};
