`timescale 1ns / 1ps

module mult(
    input [7:0] a,
    input [7:0] b,
    input start,
    input clk,

    output ready,
    output reg [15:0] result
    );
 
    reg [3:0] ctr;
    assign ready = ctr == 8;

    always @(negedge start) begin
        ctr <= 0;
        result <= 0;
    end

    always @(posedge clk) begin
        if (~ready && start) begin
            if (ctr < 8) begin
                if (b[ctr]) begin
                    result <= result + (a << ctr);
                end
                ctr <= ctr + 1;
            end
        end
    end

endmodule
