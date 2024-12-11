`timescale 1ns / 1ps

module self_testing(
    input [9:0] value,
    input ready_func, start, reset, clk,

    output reg [7:0] crc_total,
    output reg ready,
    output ready_crc
);

reg [1:0] state;
reg start_crc;
reg [7:0] crc_reg, ctr;
wire [7:0] crc;

crc8 crc8_1 (
    .data_in(value),
    .clk(clk),
    .start(start_crc),
    .polynom(9'b101110001),

    .crc_out(crc),
    .ready(ready_crc)
);

localparam IDLE = 0;
localparam WAIT_FUNC = 1;
localparam WAIT_CRC = 2;
localparam CHECK = 3;

initial begin
    state <= 0;
end

always @(posedge clk, posedge reset) begin
    if (reset) begin
        state <= IDLE;
        crc_total <= 0;
        ready <= 0;
    end
    else
        case (state)
            IDLE: begin
                if (start) begin
                    crc_total <= 0;
                    ready <= 0;
                    state <= WAIT_FUNC;
                end
                ctr <= 0;
            end
            WAIT_FUNC: begin
                if (ready_func) begin
                    start_crc <= 1;
                    state <= WAIT_CRC;
                end
            end
            WAIT_CRC: begin
                start_crc <= 0;
                if (ready_crc) begin
                    crc_reg <= crc;
                    state <= CHECK;
                end
            end 
            CHECK: begin
                if (ctr == 255) begin
                    crc_total <= crc;
                    $display(crc);
                    $stop;
                    ready <= 1;
                end
                else begin 
                    ctr <= ctr + 1;
                    state <= WAIT_FUNC;
                end
            end
        endcase
end
endmodule
