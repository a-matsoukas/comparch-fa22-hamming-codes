`timescale 1ns/1ps
`default_nettype none

module hamming_7_4_encoder(data, msg);

parameter P = 3;

input wire [2**P - P - 2:0] data;
output logic [2**P - 2:0] msg;

logic [2:0] parity_bits;

always_comb begin : set_parity_bits
    parity_bits[0] = ^({data[0], data[1], data[3]});
    parity_bits[1] = ^({data[0], data[2], data[3]});
    parity_bits[2] = ^({data[1], data[2], data[3]});
end

always_comb begin : create_msg
    msg = {data[3:1], parity_bits[2], data[0], parity_bits[1:0]};
end

endmodule