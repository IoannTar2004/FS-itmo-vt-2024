`timescale 1ns / 1ps


module cbrt(
    input [7:0] a,
    input start,
    input clk,

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

        .result(intermediate_result),
        .ready(ready_mul)
    );

    localparam START = 2'b0;
    localparam MUL_1 = 2'b1;
    localparam MUL_2 = 2'b10;
    localparam NEXT = 2'b11; 

    reg [1:0] state;

    always @(posedge start) begin
        x <= a;
    end
    always @(negedge start) begin
        state <= START;
        s <= 6;
        ready <= 0;
        result <= 0;
        start_mul <= 0;
    end

    always @(posedge clk) begin
        if (~ready && start) begin
            if (s > -3) begin
                case (state)
                    START: begin
                        result = result << 1;
                        a_mul <= 3;
                        b_mul <= result;
                        state <= MUL_1;
                    end

                    MUL_1: begin
                        start_mul <= 1;
                        result_mul <= intermediate_result;
                        if (ready_mul) begin
                            b_mul <= result_mul;
                            a_mul <= result + 1;
                            start_mul <= 0;
                            state <= MUL_2;
                        end
                    end

                    MUL_2 : begin
                        start_mul <= 1;
                        result_mul <= intermediate_result;
                        if (ready_mul) begin
                            result_mul <= (result_mul + 1) << s;
                            state <= NEXT;
                        end
                    end

                    default: begin
                        start_mul <= 0;
                        if (x >= result_mul) begin
                            x <= x - result_mul;
                            result <= result + 1;
                        end
                        s <= s - 3;
                        state <= START;
                    end
                endcase
            end
            else
                ready <= 1;
        end 
    end
endmodule
