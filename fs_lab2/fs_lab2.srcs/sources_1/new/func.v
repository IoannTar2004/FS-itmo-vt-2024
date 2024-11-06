`timescale 1ns / 1ps

module func(
    input [7:0] a,
    input [7:0] b,
    input start,
    input clk,

    output reg [9:0] result,
    output reg ready
    );

    reg [7:0] multer1, multer2;
    reg start_mul, start_cbrt;
    reg [15:0] result_mul_reg;

    wire [15:0] result_mul;
    wire [2:0] result_cbrt;
    wire ready_mul, ready_cbrt;

    mult mult_1 (
        .a(multer1),
        .b(multer2),
        .clk(clk),
        .start(start_mul),

        .result(result_mul),
        .ready(ready_mul)
    );

    cbrt cbrt_1 (
        .a(b),
        .clk(clk),
        .start(start_cbrt),

        .result(result_cbrt),
        .ready(ready_cbrt)
    );

    localparam ACT_0 = 0;
    localparam ACT_1 = 1;
    
    reg state;
    
    always @(negedge start) begin
        start_mul <= 0;
        start_cbrt <= 0;
        result <= 0;
        ready <= 0;
        state <= ACT_0;
    end

    always @(posedge start) begin
        multer1 <= 3;
        multer2 <= a;
    end

    always @(posedge clk) begin
        if (~ready && start) begin
            case (state)
                ACT_0: begin
                    start_mul <= 1;
                    start_cbrt <= 1;
                    result_mul_reg <= result_mul;
                    if (ready_mul && ready_cbrt) begin
                        start_mul <= 0;
                        multer1 <= 2;
                        multer2 <= result_cbrt;
                        state <= ACT_1;
                    end
                end

                ACT_1: begin
                    start_mul <= 1;
                    if (ready_mul) begin
                        result <= result_mul_reg + result_mul;
                        ready <= 1;
                    end
                end 
            endcase
        end
    end
endmodule
