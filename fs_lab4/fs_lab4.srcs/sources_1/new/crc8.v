`timescale 1ns / 1ps

module crc8(
    input [9:0] data_in,
    input start,
    input clk,
    input [8:0] polynom,

    output reg [7:0] crc_out,
    output reg ready
);

reg [10:0] shift_reg;
reg [9:0] data;
reg [7:0] crc;
reg [2:0] state;
reg [3:0] ctr;
wire bit;

assign bit = shift_reg[10];

localparam IDLE = 0;
localparam XOR = 1;
localparam SHIFT = 2;
localparam WRITE = 3;
localparam CHECK = 4;

initial begin
    state <= 0;
    crc <= 0;
end

always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (start) begin
                data <= data_in;
                state <= XOR;
                ready <= 0;
            end
            ctr <= 0;
        end 
        XOR: begin
            shift_reg <= data ^ crc;
            state <= SHIFT;
        end
        SHIFT: begin
            shift_reg <= shift_reg << 1;
            state <= WRITE;
        end
        WRITE: begin
            crc <= bit == 1 ? shift_reg ^ polynom : shift_reg;
            state <= CHECK;
        end
        CHECK: begin
            if (ctr == 9) begin
                crc_out <= crc;
                ready <= 1;
                state <= IDLE;
            end
            else begin
                shift_reg[10] <= 0;
                ctr <= ctr + 1;
                state <= XOR;
            end
        end
    endcase
end

endmodule
