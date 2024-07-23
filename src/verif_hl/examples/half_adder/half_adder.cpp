// File: half_adder.cpp		
#include "half_adder.h"		

void half_adder::prc_half_adder () {	
//  sum = a ^ b;						  	
  sum.write(a ^ b);						
//  carry = a & b;						
  carry.write(a & b);					
}
