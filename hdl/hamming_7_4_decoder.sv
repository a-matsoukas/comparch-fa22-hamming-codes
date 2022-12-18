`timescale 1ns/1ps
`default_nettype none

module hamming_7_4_decoder(rx_msg, ec_msg);

// P is number of parity bits for future implementation.
parameter P = 3;

input wire [2**P - 2:0] rx_msg;
output logic [2**P - P - 2:0] ec_msg;

logic [2:0] parity_groups;

// We check if each parity group has an even number of 1s, indicating no error.
always_comb begin : calc_parity_groups
    parity_groups[0] = ^({rx_msg[0], rx_msg[2], rx_msg[4], rx_msg[6]});
    parity_groups[1] = ^({rx_msg[1], rx_msg[2], rx_msg[5], rx_msg[6]});
    parity_groups[2] = ^({rx_msg[3], rx_msg[4], rx_msg[5], rx_msg[6]});
end

// Each data bit belongs to a unique subset of parity groups, so if there is an
// error in all of the groups it is a part of and no other, then it is flipped.
always_comb begin : create_ec_msg
    ec_msg[0] = rx_msg[2] ^ &({parity_groups[0], parity_groups[1], ~parity_groups[2]});
    ec_msg[1] = rx_msg[4] ^ &({parity_groups[0], ~parity_groups[1], parity_groups[2]});
    ec_msg[2] = rx_msg[5] ^ &({~parity_groups[0], parity_groups[1], parity_groups[2]});
    ec_msg[3] = rx_msg[6] ^ &({parity_groups[0], parity_groups[1], parity_groups[2]});
end

endmodule