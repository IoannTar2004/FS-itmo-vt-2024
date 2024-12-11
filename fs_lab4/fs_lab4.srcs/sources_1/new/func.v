`timescale 1ns / 1ps
`define reset_macro     \
    start_mul <= 0;     \
    start_cbrt <= 0;    \
    result <= 0;        \
    ready <= 0;

module func(
    input [7:0] a,
    input [7:0] b,
    input start,
    input clk,
    input reset,

    output reg [9:0] result,
    output reg ready
    );

    reg [7:0] multer1, multer2;
    reg start_mul, start_cbrt;
    reg [15:0] result_mul_reg1, result_mul_reg2;

    wire [15:0] result_mul;
    wire [2:0] result_cbrt;
    wire ready_mul, ready_cbrt;

    mult mult_1 (
        .a(multer1),
        .b(multer2),
        .clk(clk),
        .start(start_mul),
        .reset(reset),

        .result(result_mul),
        .ready(ready_mul)
    );

    cbrt cbrt_1 (
        .a(b),
        .clk(clk),
        .start(start_cbrt),
        .reset(reset),

        .result(result_cbrt),
        .ready(ready_cbrt)
    );

    localparam IDLE = 0;
    localparam ACT_0 = 1;
    localparam ACT_1 = 2;
    localparam READY = 3;
    
    reg [1:0] state;
    initial begin
        state <= IDLE;
    end

    always @(posedge clk) begin
        if (reset) begin
            `reset_macro
            state <= IDLE;
        end
        else
            case (state)
                IDLE: begin
                    if (start) begin
                        `reset_macro
                        multer1 <= 3;
                        multer2 <= a;
                        start_mul <= 1;
                        start_cbrt <= 1;

                        state <= ACT_0;
                    end
                end
                ACT_0: begin
                    start_mul <= 0;
                    start_cbrt <= 0;
                    result_mul_reg1 <= result_mul;
                    if (ready_mul && ready_cbrt && ~start_mul && ~start_cbrt) begin
                        start_mul <= 1;
                        multer1 <= 2;
                        multer2 <= result_cbrt;
                        state <= ACT_1;
                    end
                end

                ACT_1: begin
                    start_mul <= 0;
                    result_mul_reg2 <= result_mul;
                    if (ready_mul && ~start_mul) begin
                        state <= READY;
                    end
                end 

                READY: begin
                    result <= result_mul_reg1 + result_mul_reg2;
                    ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
endmodule
