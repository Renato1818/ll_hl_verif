#include <systemc.h>
#include "full_adder.h"

struct Tb : sc_module {    
    sc_in_clk         clk{"clk"};
    sc_signal <bool>         rstn{"rstn"};

	sc_signal < bool > 	 A1 {"A1"};
	sc_signal < bool > 	 B1 {"B1"};
	sc_signal < bool > 	 Cin {"Cin"};

	sc_signal < bool > 	 S1 {"S1"};
	sc_signal < bool > 	 Cout {"Cout"};

    full_adder dut_inst{"dut_inst"};

    SC_CTOR(Tb) 
    {        
        dut_inst.clk(clk);
        dut_inst.rstn(rstn);

        dut_inst.A1(A1);
        dut_inst.B1(B1);
        dut_inst.Cin(Cin);

        dut_inst.S1(S1);
        dut_inst.Cout(Cout);

        SC_CTHREAD(test_proc, clk.pos());
    }
    
    void test_proc() 
    {
        int aux = 0;
        cout << "test_proc() started" << endl;

        while (aux < 50) {
            a.write(false);     
            b.write(false);
            wait(3);

            a.write(false);     
            b.write(true);     
            wait(2);     
        
            a.write(true);     
            b.write(false);     
            wait(6);     

            a.write(true);     
            b.write(true);     
            wait(3);  
            aux++;
        }
    }
};

int sc_main(int argc, char* argv[]){	
    sc_clock clk{"clk", sc_time(1, SC_NS)};
    Tb tb("tb");
    tb.clk(clk);
    sc_start(200 ,SC_MS);
	return 0;
} 
