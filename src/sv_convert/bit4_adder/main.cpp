#include <systemc.h>
#include "bit4_adder.h"

struct Tb : sc_module {    
    sc_in_clk         clk{"clk"};
    sc_signal <bool>         rstn{"rstn"};

	sc_signal < bool > 	 Cin {"Cin"};
	sc_signal < bool > 	 A1 {"A1"};
	sc_signal < bool > 	 A2 {"A2"};
	sc_signal < bool > 	 A3 {"A3"};
	sc_signal < bool > 	 A4 {"A4"};
	sc_signal < bool > 	 B1 {"B1"};
	sc_signal < bool > 	 B2 {"B2"};
	sc_signal < bool > 	 B3 {"B3"};
	sc_signal < bool > 	 B4 {"B4"};

	sc_signal < bool > 	 S1 {"S1"};
	sc_signal < bool > 	 S2 {"S2"};
	sc_signal < bool > 	 S3 {"S3"};
	sc_signal < bool > 	 S4 {"S4"};
	sc_signal < bool > 	 Cout {"Cout"};

    bit4_adder dut_inst{"dut_inst"};

    SC_CTOR(Tb) 
    {        
        dut_inst.clk(clk);
        dut_inst.rstn(rstn);

        dut_inst.Cin(Cin);
        dut_inst.A1(A1);
        dut_inst.A2(A2);
        dut_inst.A3(A3);
        dut_inst.A4(A4);
        dut_inst.B1(B1);
        dut_inst.B2(B2);
        dut_inst.B3(B3);
        dut_inst.B4(B4);

        dut_inst.S1(S1);
        dut_inst.S2(S2);
        dut_inst.S3(S3);
        dut_inst.S4(S4);
        dut_inst.Cout(Cout);

        SC_CTHREAD(test_proc, clk.pos());
    }
    
    void test_proc() 
    {
        int aux = 0;
        cout << "test_proc() started" << endl;

    }
};

int sc_main(int argc, char* argv[]){	
    sc_clock clk{"clk", sc_time(1, SC_NS)};
    Tb tb("tb");
    tb.clk(clk);
    sc_start(200 ,SC_MS);
	return 0;
} 
