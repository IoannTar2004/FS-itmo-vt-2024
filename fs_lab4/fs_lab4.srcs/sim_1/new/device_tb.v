`timescale 1ns / 1ps

module device_tb;
    reg clk, test, start, rand;
    wire [6:0] seg;
    wire [7:0] an;
    reg [15:0] sw;
    device device_1 (
        .clk(clk),
        .sw(sw),
        .seg(seg),
        .an(an),
        .test(test),
        .start(start),
        .rand(rand)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 1;
        sw <= 771;
        #20;
        test <= 1;
        #10000;
        test <= 0;
        #300000;

        $stop;
    end
endmodule
