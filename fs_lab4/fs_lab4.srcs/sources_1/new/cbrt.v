`timescale 1ns / 1ps
`define reset_macro     \
    ready <= 0;         \
    result <= 0;        \
    start_mul <= 0;     \

module cbrt(
    input [7:0] a,
    input start,
    input clk,
    input reset,

    output reg [2:0] result,
    output reg ready
    );

    reg [7:0] x;
    reg signed [3:0] s;
    reg [15:0] a_mul, b_mul, result_mul;
    reg start_mul;
    wire [15:0] intermediate_result;
    wire ready_mul;

    mult mult_2 (
        .a(a_mul),
        .b(b_mul),
        .clk(clk),
        .start(start_mul),
        .reset(reset),

        .result(intermediate_result),
        .ready(ready_mul)
    );

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam MUL_1 = 3'd2;
    localparam MUL_2 = 3'd3;
    localparam CMP = 3'd4;
    localparam INC = 3'd5;
    localparam SUB = 3'd6;
    localparam DEC = 3'd7;

    reg [2:0] state;

    initial begin
        state <= 0;
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
                        x <= a;
                        s <= 6;
                        state <= START;
                    end
                end
                START: begin
                    if (s == -3) begin
                        ready <= 1;
                        state <= IDLE;
                    end
                    else begin
                        result <= result << 1;
                        a_mul <= 3;
                        b_mul <= result << 1;
                        state <= MUL_1;
                        start_mul <= 1;
                    end
                end

                MUL_1: begin
                    start_mul <= 0;
                    result_mul <= intermediate_result;
                    if (ready_mul && ~start_mul) begin
                        b_mul <= result_mul;
                        a_mul <= result + 1;
                        start_mul <= 1;
                        state <= MUL_2;
                    end
                end

                MUL_2 : begin
                    start_mul <= 0;
                    result_mul <= intermediate_result;
                    if (ready_mul && ~start_mul) begin
                        state <= CMP;
                    end
                end

                CMP: begin
                    result_mul <= (result_mul + 1) << s;
                    state <= INC;
                end

                INC: begin
                    if (x >= result_mul) begin
                        result <= result + 1;
                        state <= SUB;
                    end
                    else
                        state <= DEC;
                end

                SUB: begin
                    x <= x - result_mul;
                    state <= DEC;
                end

                DEC: begin
                    s <= s - 3;
                    state <= START;
                end
            endcase
    end
endmodule
