`timescale 1ns / 1ps
`define reset_macro \
    ctr <= 0;       \
    result <= 0;    \
    ready <= 0;     \

module mult(
    input [7:0] a,
    input [7:0] b,
    input start,
    input reset,
    input clk,

    output reg ready,
    output reg [15:0] result
    );
 
    reg [3:0] ctr;
    reg [7:0] a_mul, b_mul;

    localparam IDLE = 0;
    localparam WORK = 1;

    reg state;
    initial begin
        state <= IDLE;
    end
    always @(posedge clk) begin
        if (reset) begin
            `reset_macro;
            state <= IDLE;
        end
        else
            case (state)
                IDLE: begin
                    if (start) begin
                        `reset_macro
                        a_mul <= a;
                        b_mul <= b;
                        state <= WORK;
                    end
                end 
                WORK: begin
                    if (ctr < 8) begin
                        if (b_mul[ctr]) begin
                            result <= result + (a_mul << ctr);
                        end
                        ctr <= ctr + 1;
                    end
                    else begin
                        ready <= 1;
                        state <= IDLE;
                    end
                end
            endcase 
    end

endmodule
