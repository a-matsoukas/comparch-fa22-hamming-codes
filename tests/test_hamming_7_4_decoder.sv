`timescale 1ns/1ps
`default_nettype none
module test_hamming_7_4_decoder;

parameter P = 3;

logic [2**P - 2:0] rx_msg;
wire [2**P - P - 2:0] ec_msg;

hamming_7_4_decoder #(.P(P)) UUT(.rx_msg(rx_msg), .ec_msg(ec_msg));

logic [2**P - P - 2:0] expected_ec_msg;
logic is_correct;

always_comb is_correct = ec_msg == expected_ec_msg;

task print_io;
    $display("%b ->  %b  |  %b  |   %b", rx_msg, ec_msg, expected_ec_msg, is_correct);
endtask

initial begin
    $dumpfile("hamming_7_4_encoder.fst");
    $dumpvars(0, UUT);

    $display(" RX_MSG -> EC_MSG | Expect | Correct");
    $display("-----------------------------------");

    // Test 1
    rx_msg = 7'b0001000;
    expected_ec_msg = 4'b0000;
    #1 print_io();

    // Test 2
    rx_msg = 7'b1111110;
    expected_ec_msg = 4'b1111;
    #1 print_io();

    // Test 3
    rx_msg = 7'b1011110;
    expected_ec_msg = 4'b0011;
    #1 print_io();

    // Test 4
    rx_msg = 7'b1010010;
    expected_ec_msg = 4'b1010;
    #1 print_io();

    // Test 5
    rx_msg = 7'b1001101;
    expected_ec_msg = 4'b1001;
    #1 print_io();

    // Test 6
    rx_msg = 7'b0010100;
    expected_ec_msg = 4'b0111;
    #1 print_io();
end

endmodule