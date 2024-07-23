#include <systemc.h>
#include "alu.h"

struct Tb : sc_module {    
    sc_in_clk         clk{"clk"};
    sc_signal <bool>         rstn{"rstn"};

	sc_signal < sc_uint<3> > OPCODE {"OPCODE"};
	sc_signal < sc_uint<4> >   OP1  {"OP1"};
	sc_signal < sc_uint<4> >   OP2  {"OP2"};

	sc_signal < bool > 	 CARRY {"CARRY"};
	sc_signal < bool > 	  ZERO {"ZERO"};
	sc_signal < sc_uint<4> > RESULT {"RESULT"};

    alu dut_inst{"dut_inst"};

    SC_CTOR(Tb) 
    {        
        dut_inst.clk(clk);
        dut_inst.rstn(rstn);

        dut_inst.OPCODE(OPCODE);
        dut_inst.OP1(OP1);
        dut_inst.OP2(OP2);

        dut_inst.CARRY(CARRY);
        dut_inst.ZERO(ZERO);
        dut_inst.RESULT(RESULT);

        SC_CTHREAD(test_proc, clk.pos());
    }
    
    void test_proc() 
    {
        OPCODE = 0;
        OP1 = 0;
        OP2 = 0;
        int aux = 0;

        cout << "test_proc() started" << endl;

        while (aux < 50) {
            for(int z=0; z<8; z++){
                
                OPCODE = z;
                OP1 = rand() % 16;
                OP2 = rand() % 16;

                wait(2);
            }
            ++aux;
        }
    }
};
 
 
int sc_main (int argc, char* argv[]) {
    sc_clock clk{"clk", sc_time(1, SC_NS)};
    srand(time(NULL));
    Tb tb("tb");
    tb.clk(clk);
    sc_start(20 ,SC_MS);
    return(0);
}
