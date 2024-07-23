#include <systemc.h>
#include "half_adder.h"
//#include "driver.h"
//#include "monitor.h"

struct Tb : sc_module {    
    sc_in_clk         clk{"clk"};
    sc_signal <bool>         rstn{"rstn"};

	sc_signal < bool > 	 a {"a"};
	sc_signal < bool > 	  b {"b"};

	sc_signal < bool > 	  sum {"sum"};
	sc_signal < bool > 	 carry {"carry"};

    half_adder dut_inst{"dut_inst"};

    SC_CTOR(Tb) 
    {        
        dut_inst.clk(clk);
        dut_inst.rstn(rstn);

        dut_inst.a(a);
        dut_inst.b(b);

        dut_inst.sum(sum);
        dut_inst.carry(carry);

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
 
 
int sc_main (int argc, char* argv[]) {
    sc_clock clk{"clk", sc_time(1, SC_NS)};
    srand(time(NULL));
    Tb tb("tb");
    tb.clk(clk);
    sc_start(200 ,SC_MS);
    return(0);
}


