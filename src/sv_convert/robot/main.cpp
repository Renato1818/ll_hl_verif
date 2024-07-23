#include <systemc.h>
#include "Robot.h"

#define  MIN_DIST 50

struct Tb : sc_module 
{
    //typedef Robot::data_t data_t;

    sc_in_clk           clk{"clk"};
    sc_signal<bool>     rstn{"rstn"};

    sc_signal<data_t>       dist{"dist"};
    sc_signal<bool>      alarm_flag{"alarm_flag"};

    Robot<MIN_DIST> dut_inst{"dut_inst"};

    SC_CTOR(Tb) 
    {        
        dut_inst.clk(clk);
        dut_inst.rstn(rstn);

        dut_inst.dist(dist);
        dut_inst.alarm_flag(alarm_flag);

        SC_CTHREAD(test_proc, clk.pos());
    }
    
    void test_proc() 
    {
        cout << "test_proc() started" << endl;
        dist = 256;
        int aux = 0;
        while (aux < 50)
        {
            wait(2);
            dist = rand() % 256;
            ++aux;
        }
        
    }
};
 
 
int sc_main (int argc, char **argv) {
    sc_clock clk{"clk", sc_time(1, SC_NS)};
    srand(time(NULL));
    Tb tb("tb");
    tb.clk(clk);
    //Robot robot("Robot0");
    sc_start(20 ,SC_MS);
    return(0);
}
