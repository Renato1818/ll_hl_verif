#include <systemc.h>

//N_BITS = 31
#define MAX_RESULT 2147483648 // => 2^N_bits

SC_MODULE(ALU) {
    int OPCODE;
    int OP10, OP11;
    int OP20, OP21;
    bool CARRY, ZERO;
    int RESULT0, RESULT1;

    //internal varibles
    int data10, data11;
    int data20, data21;
    int opcode;
    int result0, result1;
    int i;

    void operate() {
        while (true) {
            wait(5, SC_MS);
            ZERO = false;
            data10 = OP10 % MAX_RESULT;  
            data11 = OP11 % MAX_RESULT;  
            data20 = OP20 % MAX_RESULT;  
            data21 = OP21 % MAX_RESULT;  
            opcode = (OPCODE % MAX_RESULT);

            switch (opcode) {
                case 0: // Addition
                    result0 = data10 + data20;
                    result1 = data11 + data21;
                    if (data10 > (MAX_RESULT - data20)) {
                        result1 = result1 + 1;
                    }
                    break;

                case 1: // Subtraction
                    result0 = data10 - data20;
                    result1 = data11 - data21;
                    if (result0 < 0) {
                        result0 = MAX_RESULT - result0;
                        result1 = result1 - 1;
                    }
                    break;

                case 2: // Increment
                    result0 = data10 + 1;
                    result1 = data11;
                    if ((data10 == (MAX_RESULT-1))) {
                        result1 = result1 + 1;
                    }
                    break;

                case 3: // Decrement
                    result0 = data10 - 1;
                    result1 = data11;
                    if (result0 < 0) {
                        result0 = MAX_RESULT - result0;
                        result1 = result1 - 1;
                    }
                    break;
            }
            RESULT0 = result0 % MAX_RESULT; 
            RESULT1 = result1 % MAX_RESULT; 
            CARRY = ((result1 / MAX_RESULT) % 2) == 1 ? true : false;
            ZERO = (result0 % MAX_RESULT) == 0 ? ((result1 % MAX_RESULT) == 0 ? true : false) : false;
        }
    }

    SC_CTOR(ALU) {
        SC_THREAD(operate);
    }
    
};
