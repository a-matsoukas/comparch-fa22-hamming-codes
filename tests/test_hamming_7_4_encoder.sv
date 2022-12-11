`timescale 1ns/1ps
`default_nettype none
module test_hamming_7_4_encoder;

parameter P = 3;

logic [2**P - P - 2:0] data;
wire [2**P - 2:0] msg;

hamming_7_4_encoder #(.P(P)) UUT(.data(data), .msg(msg));

logic [2**P - 2:0] expected_msg;
logic is_correct;

always_comb is_correct = msg == expected_msg;

task print_io;
    $display("%b -> %b | %b |    %b", data, msg, expected_msg, is_correct);
endtask

initial begin
    $dumpfile("hamming_7_4_encoder.fst");
    $dumpvars(0, UUT);

    $display(" MSG -> Encoded |  Expect | Correct");
    $display("-----------------------------------");

    // Test 1
    data = 4'b0000;
    expected_msg = 7'b0000000;
    #1 print_io();

    // Test 2
    data = 4'b1111;
    expected_msg = 7'b1111111;
    #1 print_io();

    // Test 3
    data = 4'b0011;
    expected_msg = 7'b0011110;
    #1 print_io();

    // Test 4
    data = 4'b1010;
    expected_msg = 7'b1010010;
    #1 print_io();

    // Test 5
    data = 4'b1001;
    expected_msg = 7'b1001100;
    #1 print_io();

    // Test 6
    data = 4'b0111;
    expected_msg = 7'b0110100;
    #1 print_io();
end

endmodule