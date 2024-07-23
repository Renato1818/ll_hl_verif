#include <systemc.h>
#include "myfifo.h"
#include "producer.h"
#include "consumer.h"

int sc_main(int argc, char* argv[])
{
    sc_clock clk("clk", 50, SC_NS);
    myfifo fifo_inst("thisfifo");
    producer prod_inst("producer",127);
    consumer cons_inst("consumer");
    fifo_inst.f_clock(clk);
    prod_inst.p_clock(clk);
    cons_inst.c_clock(clk);
    prod_inst.fifo(fifo_inst);
    cons_inst.fifo(fifo_inst);
    sc_start(1000,SC_NS);
    return 0;
}
