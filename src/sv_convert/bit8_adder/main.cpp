#include <systemc.h>
#include "bit8_adder.h"

struct Tb : sc_module {    
    sc_in_clk         clk{"clk"};
    sc_signal <bool>         rstn{"rstn"};

	sc_signal < bool > 	 Cin {"Cin"};
	sc_signal < bool > 	 A1 {"A1"};
	sc_signal < bool > 	 A2 {"A2"};
	sc_signal < bool > 	 A3 {"A3"};
	sc_signal < bool > 	 A4 {"A4"};
	sc_signal < bool > 	 A5 {"A5"};
	sc_signal < bool > 	 A6 {"A6"};
	sc_signal < bool > 	 A7 {"A7"};
	sc_signal < bool > 	 A8 {"A8"};
	sc_signal < bool > 	 B1 {"B1"};
	sc_signal < bool > 	 B2 {"B2"};
	sc_signal < bool > 	 B3 {"B3"};
	sc_signal < bool > 	 B4 {"B4"};
	sc_signal < bool > 	 B5 {"B6"};
	sc_signal < bool > 	 B6 {"B6"};
	sc_signal < bool > 	 B7 {"B7"};
	sc_signal < bool > 	 B8 {"B8"};

	sc_signal < bool > 	 S1 {"S1"};
	sc_signal < bool > 	 S2 {"S2"};
	sc_signal < bool > 	 S3 {"S3"};
	sc_signal < bool > 	 S4 {"S4"};
	sc_signal < bool > 	 S5 {"S6"};
	sc_signal < bool > 	 S6 {"S6"};
	sc_signal < bool > 	 S7 {"S7"};
	sc_signal < bool > 	 S8 {"S8"};
	sc_signal < bool > 	 Cout {"Cout"};

    bit8_adder dut_inst{"dut_inst"};

    SC_CTOR(Tb) 
    {        
        dut_inst.clk(clk);
        dut_inst.rstn(rstn);

        dut_inst.Cin(Cin);
        dut_inst.A1(A1);
        dut_inst.A2(A2);
        dut_inst.A3(A3);
        dut_inst.A4(A4);
        dut_inst.A5(A5);
        dut_inst.A6(A6);
        dut_inst.A7(A7);
        dut_inst.A8(A8);
        dut_inst.B1(B1);
        dut_inst.B2(B2);
        dut_inst.B3(B3);
        dut_inst.B4(B4);
        dut_inst.B5(B5);
        dut_inst.B6(B6);
        dut_inst.B7(B7);
        dut_inst.B8(B8);

        dut_inst.S1(S1);
        dut_inst.S2(S2);
        dut_inst.S3(S3);
        dut_inst.S4(S4);
        dut_inst.S5(S5);
        dut_inst.S6(S6);
        dut_inst.S7(S7);
        dut_inst.S8(S8);
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
