`timescale 1ns / 1ps

module mult(
    input [7:0] a,
    input [7:0] b,
    input reset,
    input start,
    input clk,

    output reg ready,
    output reg [15:0] result
    );

    reg [2:0] ctr;

    always @(posedge reset) begin
        ctr <= 0;
        ready <= 0;
        result <= 0;
    end

    always @(posedge clk) begin
        if (~ready && start) begin
            if (ctr < 7) begin
                if (b[ctr])
                    result <= result + (a << ctr);
                ctr = ctr + 1;
            end
            else
                ready <= 1;
        end
    end

endmodule
