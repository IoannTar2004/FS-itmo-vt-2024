`timescale 1ns / 1ps

module test_seg;
    reg clk;
    wire [6:0] seg;
    wire [7:0] an;
    reg [15:0] sw;
    seg_7 segd (
        .clk(clk),
        .sw(sw),
        .seg(seg),
        .an(an)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 1;
        sw <= 771;
    end
endmodule
