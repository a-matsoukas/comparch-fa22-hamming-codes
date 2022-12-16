`timescale 1ns/1ps
`default_nettype none

module main(data, error_vector, tx_msg_bar, rx_msg_bar, ec_data_bar);

// P is number of parity bits for future implementation.
parameter P = 3;

// We receive these inputs from switches on the bread board.
input wire [2**P - P - 2:0] data;
input wire [2**P - 2:0] error_vector;

logic [2**P - P - 2:0] ec_data;
logic [2**P - 2:0] tx_msg, rx_msg;

// These outputs are used to light up LEDs and verify it works.
output logic [2**P - P - 2:0] ec_data_bar;
output logic [2**P - 2:0] tx_msg_bar, rx_msg_bar;


hamming_7_4_encoder #(.P(P)) encoder(data, tx_msg);
hamming_7_4_decoder #(.P(P)) decoder(rx_msg, ec_data);

// This block combines transmitted message with an error vector to simulate a
// noisy channel. This produced the received message.
always_comb begin : bit_error
    rx_msg = tx_msg ^ ~error_vector; 
end

// We want to power LEDs from a power rail due to pin current constraints, so
// the cathode is connected to our specific pin. To do this, we NOT the signals
// so that HIGH is LED off and LOW is LED on.
always_comb begin : outputs
    tx_msg_bar = ~tx_msg;
    rx_msg_bar = ~rx_msg;
    ec_data_bar = ~ec_data;
end


endmodule