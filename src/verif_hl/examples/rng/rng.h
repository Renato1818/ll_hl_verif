//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Random Number Generator Top Header                          ////
////                                                              ////
////  This file is part of the SystemC RNG project                ////
////                                                              ////
////  Description:                                                ////
////  Top file of random number generator                         ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

#include <systemc.h>    

//#define    N_RNG   32
//#define    N_LFSR  43 //Always N_LFSR > N_CASR
//#define    N_CASR  37

SC_MODULE (rng) {
    /*sc_in   < bool >   clk;
    sc_in   < bool >   reset;
              
    sc_in   < bool >   loadseed_i;
    //sc_in     < sc_uint < 32 > > seed_i;
    sc_in   < int >    seed_i;
    
    //sc_out    < sc_uint < 32 > > number_o;
    sc_out  < int >    number_o; */


    bool   clk;
    bool   reset;
    bool   loadseed_i;
    int    seed_i;
    int    number_o;

    //sc_signal < sc_uint < 43 > > LFSR_reg;
    int LFSR_reg;
    //sc_signal < sc_uint < 37 > > CASR_reg;
    int CASR_reg;

    int exp2_(int exponent) {
        int result = 1;
        for (int i = 0; i < exponent; i = 1 + i) {
            result = result * 2;
        }
        return result;
    }

    int bit_ (int var, int pos) {
        int aux = 0;        
        if (var == 0){
            return 0;
        }
        else {            
            aux = var % exp2_(pos+1);
        }               
        if (aux == 0){
            return 0;
        }
        return (aux / exp2_(pos));
    }

    int xor_ (int var, int pos, int A, int B) {

        if (A == 1) {
            if (B == 1){
                var = var - exp2_(pos);
            } 
            else {
                var = var + exp2_(pos);
            }
        }
        else {
            var = B * exp2_(pos);
        }

        return var;
    }

    void combinate () {
        wait(2, SC_MS);
		while (true) {			
            //if (!reset.read ()) {
            if (!reset) {
                //number_o.write (0);
                number_o = 0;
            }
            else {
                for (int i = 0; i < 32; i = 1 + i) {
                    number_o = xor_(number_o, i, bit_(LFSR_reg,i), bit_(CASR_reg,i));
                }            
                //number_o.write (LFSR_reg.read ().range (31, 0) ^ CASR_reg.read ().range (31, 0));
            }	
            wait(5, SC_MS);
		}
    }

    void LFSR () {
        //sc_uint < 43 > LFSR_var;
        int LFSR_var;
        int outbit;

        wait(2, SC_MS);
		while (true) {		
            if (!reset) {
                LFSR_reg = 1;
            }
            else {
                if (loadseed_i) {
                    if (seed_i == 0){
                        LFSR_reg = 0;
                    }
                    else {
                        LFSR_reg = seed_i % exp2_(32);
                    }
                }
                else {
                    if (LFSR_reg == 0){
                        LFSR_var = 0;
                        outbit = 0;
                    }
                    else {                        
                        LFSR_var = LFSR_reg % exp2_(43);

                        //outbit = LFSR_var[42];
                        outbit = LFSR_var / exp2_(42);
                        
                        LFSR_var = (LFSR_var % exp2_(42)) * 2 + outbit;
                    }

                    LFSR_var = xor_(LFSR_var, 41, outbit, bit_(LFSR_var, 41));
                    LFSR_var = xor_(LFSR_var, 20, outbit, bit_(LFSR_var, 20));
                    LFSR_var = xor_(LFSR_var,  1, outbit, bit_(LFSR_var,  1));

                    /*if (outbit == 1) {
                        //LFSR_var[41]
                        if (((LFSR_var % 2^^42)/2^^41) == 1){
                            LFSR_var = LFSR_var - 2^^41;
                        } 
                        else {
                            LFSR_var = LFSR_var + 2^^41;
                        }

                        //LFSR_var[20]
                        if (((LFSR_var % 2^^21)/2^^20) == 1){
                            LFSR_var = LFSR_var - 2^^20;
                        } 
                        else {
                            LFSR_var = LFSR_var + 2^^20;
                        }

                        //LFSR_var[1]
                        if (((LFSR_var % 2^^2)/2^^1) == 1){
                            LFSR_var = LFSR_var - 2^^1;
                        } 
                        else {
                            LFSR_var = LFSR_var + 2^^1;
                        }
                    }*/
                    if (LFSR_var == 0){
                        LFSR_reg = 0;
                    }
                    else {
                        LFSR_reg = LFSR_var % exp2_(43);
                    }
                }
            }
            wait(5, SC_MS);
		}
    }

    void CASR () {
        //sc_uint < 43 > CASR_var, CASR_out;
        int CASR_var, CASR_out;

        int CASR_plus, CASR_minus;
        int bit_plus, bit_minus;

        wait(2, SC_MS);
		while (true) {		
            if (!reset) {
                CASR_var = 1;
            }
            else {
                if (loadseed_i) {
                    if (seed_i == 0){
                        CASR_reg = 0;
                    }
                    else {
                        CASR_reg = seed_i % exp2_(32);
                    }
                }
                else {
                    if (CASR_reg == 0){
                        CASR_var = 0;
                        bit_plus = 0;
                        CASR_plus = 0;
                        bit_minus = 0;
                        CASR_minus = 0;
                    }
                    else {                        
                        CASR_var = CASR_reg % exp2_(37);

                        
                        bit_plus = CASR_var / exp2_(36);                
                        CASR_plus = (CASR_var % exp2_(36)) * 2 + bit_plus;

                        bit_minus = CASR_var % 1;                
                        CASR_minus = (CASR_var % exp2_(37)) / 2 + bit_minus * exp2_(36);
                    }


                    for (int i = 0; i < 37; i = 1 + i) {
                        CASR_out = xor_(CASR_out, i, bit_(CASR_plus,i), bit_(CASR_minus,i));
                    }
                    
                    if (CASR_out == 0){
                        CASR_reg = 0;
                    }
                    else {
                        CASR_reg = CASR_out % exp2_(37);
                    }
                }
            }
            wait(5, SC_MS);
		}
    }
    
    SC_CTOR (rng) {
        SC_METHOD(exp2_);
        SC_METHOD(bit_);
        SC_METHOD(xor_);

        SC_THREAD (CASR);
        //sensitive_pos << clk;
        //sensitive_neg << reset;

        SC_THREAD (LFSR);
        //sensitive_pos << clk;
        //sensitive_neg << reset;

        SC_THREAD (combinate);
        //sensitive_pos << clk;
        //sensitive_neg << reset;

    }

};
