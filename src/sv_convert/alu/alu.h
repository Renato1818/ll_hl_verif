#include <systemc.h>


struct alu : sc_module
{
    sc_in < bool >        clk{"clk"};
    sc_in < bool >        rstn{"rstn"};

	sc_in < sc_uint<3> > OPCODE {"OPCODE"};
	sc_in < sc_uint<4> >   OP1  {"OP1"};
	sc_in < sc_uint<4> >   OP2  {"OP2"};

	sc_out < bool > 	 CARRY {"CARRY"};
	sc_out < bool > 	  ZERO {"ZERO"};
	sc_out < sc_uint<4> > RESULT {"RESULT"};

	SC_CTOR(alu){
		SC_CTHREAD(operate, clk.pos());
        async_reset_signal_is(rstn, false);

		SC_METHOD(get_bit);
		SC_METHOD(set_bit);

	}

	// Helper function to get the bit at position pos
	sc_uint<4> get_bit(sc_uint<4> value, sc_uint<4> pos) {
		sc_uint<4> divisor = 1;
		sc_uint<4> i;
		for (i = 0; i < pos; i = 1 +1) {
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
	sc_uint<5> set_bit(sc_uint<5> value, sc_uint<4> pos, sc_uint<4> bit) {
		sc_uint<4> current_bit = get_bit(value, pos);
		sc_uint<4> divisor = 1;
		sc_uint<4> i;
		
		for (i = 0; i < pos; i = 1 +1) {
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
		sc_uint<4> data1 ; 
		sc_uint<4> data2 ;
		sc_uint<5> result ;
		sc_uint<4> i;
		sc_uint<4> bit;

		data1 = 0;
		data2 = 0;
		result = 0;
		i = 0;
		bit = 0;

		wait();
		while(true){
			wait();
			ZERO = false;
			data1 = OP1; 
			data2 = OP2; 
			
			switch(OPCODE.read()) // % 8)
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
					for (i = 0; i < 4; i = 1 +1) {
						bit = get_bit(data1, i) * get_bit(data2, i);
						result = set_bit(result, i, bit);
					}
					break;
					
				case 5: //or
					for (i = 0; i < 4; i = 1 +1) {
						bit = get_bit(data1, i) + get_bit(data2, i);
						result = set_bit(result, i, bit > 0 ? 1 : 0);
					}
					break;
					
				case 6: //nand
					for (i = 0; i < 4; i = 1 +1) {
						bit = get_bit(data1, i) * get_bit(data2, i);
						result = set_bit(result, i, bit ? 0 : 1);
					}
					break;
					
				case 7: //xor
					for (i = 0; i < 4; i = 1 +1) {
						bit = get_bit(data1, i) + get_bit(data2, i);
						result = set_bit(result, i, bit == 1 ? 1 : 0);
					}
					break;
			}
			
			RESULT.write(result.range(3, 0));			
			CARRY.write((bool) result[4]);			
			if(result == 0)
				ZERO.write(true);

			if(!rstn){
				RESULT.write(0);			
				CARRY.write(0);		
				ZERO.write(false);
			}
		}
	}
    
};
