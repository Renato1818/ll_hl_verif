#include <systemc.h>
#include "ALU.h"
//#include "driver.h"
//#include "monitor.h"

/*
int sc_main(int argc, char* argv[]){
	sc_signal < sc_uint<3> > s_OPCODE;
	sc_signal < sc_uint<4> > s_OP1, s_OP2;
	sc_signal < bool > s_CARRY, s_ZERO;
	
	sc_signal < sc_uint<4> > s_RESULT;
	
	
	ALU alu("ALU");
	driver dr("stimulus");
	monitor mon("monitor");
	
	//inputs
	dr.d_OPCODE(s_OPCODE);
	alu.OPCODE(s_OPCODE);
	//mon.m_OPCODE(s_OPCODE);
	
	dr.d_OP1(s_OP1);
	dr.d_OP2(s_OP2);
	
	alu.OP1(s_OP1);
	alu.OP2(s_OP2);
	
	//mon.m_OP1(s_OP1);
	//mon.m_OP2(s_OP2);
	
	//outputs
	alu.CARRY(s_CARRY);
	alu.ZERO(s_ZERO);
	alu.RESULT(s_RESULT);
	
	mon.m_CARRY(s_CARRY);
	mon.m_ZERO(s_ZERO);
	mon.m_RESULT(s_RESULT);
		
	//simulation start
	sc_start(5000, SC_NS);
	
	return 0;
} /*/


int sc_main(int argc, char* argv[]){	
	ALU alu("ALU");
	/*driver dr("stimulus");
	monitor mon("monitor");
	
	//inputs
	dr.d_OPCODE(alu.s_OPCODE);
	mon.m_OPCODE(alu.s_OPCODE);
	
	dr.d_OP1(alu.s_OP1);
	dr.d_OP2(alu.s_OP2);
	
	mon.m_OP1(alu.s_OP1);
	mon.m_OP2(alu.s_OP2);
	
	//outputs	
	mon.m_CARRY(alu.s_CARRY);
	mon.m_ZERO(alu.s_ZERO);
	mon.m_RESULT(alu.s_RESULT);*/
	
	//simulation start
	sc_start(5000, SC_NS);
	
	return 0;
}  // */
