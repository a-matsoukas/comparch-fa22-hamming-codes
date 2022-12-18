`timescale 1ns/1ps
`default_nettype none

module hamming_7_4_encoder(data, msg);

// P is number of parity bits for future implementation.
parameter P = 3;

input wire [2**P - P - 2:0] data;
output logic [2**P - 2:0] msg;

logic [2:0] parity_bits;

// We create parity bits setting the parity bit such that the number of 1s in
// the parity group (3 data bits used, 1 corresponding parity bit) is even.
always_comb begin : set_parity_bits
    parity_bits[0] = ^({data[0], data[1], data[3]});
    parity_bits[1] = ^({data[0], data[2], data[3]});
    parity_bits[2] = ^({data[1], data[2], data[3]});
end

// We combine these parity bits to create the 7 bit message: 
// {D_4, D_3, D_2, P_3, D_1, P_2, P_1}
always_comb begin : create_msg
    msg = {data[3:1], parity_bits[2], data[0], parity_bits[1:0]};
end

endmodule