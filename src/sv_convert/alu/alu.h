#include <systemc.h>


SC_MODULE(ALU) {
    sc_in < bool >        clk;
    sc_in < bool >        rstn;

	sc_in < sc_uint<3> > OPCODE;
	sc_in < sc_uint<4> > OP1,OP2;

	sc_out < bool > CARRY, ZERO;
	sc_out < sc_uint<4> > RESULT;

	void operate()	{
		sc_uint<4> data1 ; 
		sc_uint<4> data2 ;
		sc_uint<5> result ;
		sc_uint<4> i;
		sc_uint<4> bit;

		data1 = 0;
		data2 = 0;
		result = 0;

		wait();
		while(true){
			wait();
			ZERO = false;
			data1 = OP1; 
			data2 = OP2; 
			
			switch(OPCODE.read()) {					
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
	
	SC_CTOR(alu){
		SC_CTHREAD(operate, clk.pos());
        async_reset_signal_is(rstn, false);
	}
    
};
