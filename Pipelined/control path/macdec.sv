//******************************************************************************************
// Design: macdec.sv
// Author: Adam
// Description: mac decoder
// v 0.1
//******************************************************************************************
import types::*;

module macdec (
       input  mac_control_t mac_control,
       output mac_op_t      mac_op
);

always_comb
   case(mac_control)
        MAC_CONTROL_MADD :   mac_op = MADD;  // addition
        MAC_CONTROL_MSUB :   mac_op = MSUB;  // subtraction
        MAC_CONTROL_MMUL :   mac_op = MMUL;  // multiplication
        MAC_CONTROL_MLOAD:   mac_op = MLOAD; // load matrices to register

        default: ;

   endcase
endmodule