`timescale 1ns / 1ps

module lfsr(
    input clk,
    input reset,
    input [7:0] init,
    input [7:0] polynom,

    output reg [7:0] lfsr_out,
    output reg ready
);

reg [7:0] shift_reg;
reg [2:0] ctr, state;
reg bit;
wire [7:0] partial_xor;

localparam START = 3'd0;
localparam FEEDBACK = 3'd1;
localparam SHIFT = 3'd2;
localparam WRITE = 3'd3;
localparam CHECK = 3'd4;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        assign partial_xor[i] = shift_reg[i] & polynom[i];
    end
endgenerate

initial begin
    state <= START;
    shift_reg <= init;  
end

always @(posedge clk, posedge reset) begin
    if (reset) begin
        state <= START;
        shift_reg <= init;
        ctr <= 0;
    end
    else
        case (state)
            START: begin
                state <= FEEDBACK;
                ready <= 0;
                ctr <= 0;
            end
            FEEDBACK: begin
                bit <= ^partial_xor;
                state <= SHIFT;
            end
            SHIFT: begin
                shift_reg <= shift_reg << 1;
                state <= WRITE;
            end
            WRITE: begin
                shift_reg[0] <= bit;
                state <= CHECK;
            end
            CHECK: begin
                if (ctr == 7) begin
                    lfsr_out <= shift_reg;
                    ready <= 1;
                    state <= START;
                end
                else begin
                    ctr <= ctr + 1;
                    state <= FEEDBACK;
                end
            end
        endcase
end

endmodule
