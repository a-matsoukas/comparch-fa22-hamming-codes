`timescale 1ns/1ps
`default_nettype none

module hamming_7_4_decoder(rx_msg, ec_msg);

parameter P = 3;

input wire [2**P - 2:0] rx_msg;
output logic [2**P - P - 2:0] ec_msg;

logic [2:0] parity_groups;

always_comb begin : calc_parity_groups
    parity_groups[0] = ^({rx_msg[0], rx_msg[2], rx_msg[4], rx_msg[6]});
    parity_groups[1] = ^({rx_msg[1], rx_msg[2], rx_msg[5], rx_msg[6]});
    parity_groups[2] = ^({rx_msg[3], rx_msg[4], rx_msg[5], rx_msg[6]});
end

always_comb begin : create_ec_msg
    ec_msg[0] = rx_msg[2] ^ &({parity_groups[0], parity_groups[1], ~parity_groups[2]});
    ec_msg[1] = rx_msg[4] ^ &({parity_groups[0], ~parity_groups[1], parity_groups[2]});
    ec_msg[2] = rx_msg[5] ^ &({~parity_groups[0], parity_groups[1], parity_groups[2]});
    ec_msg[3] = rx_msg[6] ^ &({parity_groups[0], parity_groups[1], parity_groups[2]});
end

endmodule