`timescale 1ns/1ps
`default_nettype none

module main(data, error_vector, ec_data);

parameter P = 3;

input wire [2**P - P - 2:0] data;
input wire [2**P - 2:0] error_vector;
output logic [2**P - P - 2:0] ec_data;
output logic [2**P - 2:0] tx_msg, rx_msg;


hamming_7_4_encoder #(.P(P)) encoder(data, tx_msg);
hamming_7_4_decoder #(.P(P)) decoder(rx_msg, ec_data);

always_comb begin : bit_error
    rx_msg = tx_msg ^ error_vector; 
end

endmodule