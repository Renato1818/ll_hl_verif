#include <systemc.h>

SC_MODULE(driver){
	sc_out < sc_uint<3> > d_OPCODE;
	sc_out < sc_uint<4> > d_OP1, d_OP2;
	
	//some local variables to operate on
	sc_uint<3> z;
	sc_uint<4> x, y;

		
	void main_method(void)
	{
		while(true){
			z=x=y=0;	
			for(int a=0; a<8; a++){
				y++;
				x=y-8;
				d_OPCODE.write(z); // 0,1,2,3,4,5,6,7
				d_OP1.write(x);
				d_OP2.write(y);
				z++;
				wait(5,SC_NS);
			}
			if (z == 8){
				z = 0;
			}
			if (y == 16){
				y = 0;
			}
		}
	}
	
	SC_CTOR(driver){
		SC_THREAD(main_method);
	}
};
