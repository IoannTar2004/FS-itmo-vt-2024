`timescale 1ns / 1ps

module device_tb;
    reg clk, test;
    wire [6:0] seg;
    wire [7:0] an;
    reg [15:0] sw;
    device device_1 (
        .clk(clk),
        .sw(sw),
        .seg(seg),
        .an(an),
        .test(test)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 1;
        sw <= 771;
        #4780;
        test <= 1;
        #10;
        test <= 0;
    end
endmodule
