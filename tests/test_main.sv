`timescale 1ns/1ps
`default_nettype none
module test_main;

parameter P = 3;

logic [2**P - P - 2:0] data;
logic [2**P - 2:0] error_vector;
logic [2**P - P - 2:0] ec_data;
logic [2**P - 2:0] tx_msg, rx_msg;
wire [2**P - P - 2:0] ec_data_bar;
wire [2**P - 2:0] tx_msg_bar, rx_msg_bar;

main #(.P(P)) UUT(.data(data), .error_vector(~error_vector), 
                  .tx_msg_bar(tx_msg_bar), .rx_msg_bar(rx_msg_bar),
                  .ec_data_bar(ec_data_bar));

logic [2**P - P - 2:0] expected_data;
logic is_correct;

always_comb begin
    ec_data = ~ec_data_bar;
    tx_msg = ~tx_msg_bar;
    rx_msg = ~rx_msg_bar;
end
always_comb is_correct = ec_data == data;

task print_io;
    $display("%b -> %b + %b -> %b -> %b |    %b", data, tx_msg, error_vector, rx_msg, ec_data, is_correct);
endtask

initial begin
    $dumpfile("main.fst");
    $dumpvars(0, UUT);

    $display("DATA -> TX      +  ERR    -> RX      -> EC   | Correct");
    $display("------------------------------------------------------");

    // Test 1
    data = 4'b0000;
    error_vector = 7'b0000000;
    #1 print_io();

    // Test 2
    data = 4'b1111;
    error_vector = 7'b0000001;
    #1 print_io();

    // Test 3
    data = 4'b0011;
    error_vector = 7'b0000010;
    #1 print_io();

    // Test 4
    data = 4'b1010;
    error_vector = 7'b0000100;
    #1 print_io();

    // Test 5
    data = 4'b1001;
    error_vector = 7'b0001000;
    #1 print_io();

    // Test 6
    data = 4'b0111;
    error_vector = 7'b0010000;
    #1 print_io();

    // Test 7
    data = 4'b1000;
    error_vector = 7'b0100000;
    #1 print_io();

    // Test 8
    data = 4'b1100;
    error_vector = 7'b1000000;
    #1 print_io();
end

endmodule