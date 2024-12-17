`timescale 1ns / 1ps

module bist(
    input test, clk, reset, rand,

    output lfsr1_rd, lfsr2_rd,
    output [7:0] lfsr1, lfsr2,
    output reg [7:0] test_mode_ctr,
    output reg mux, state
);

localparam LFSR1_INIT = 8'd100;
localparam LFSR2_INIT = 8'd50;

initial begin
    test_mode_ctr <= 0;
    mux <= 0;
    state <= 0;
end

lfsr lfsr_1 (
   .clk(clk),
   .reset(test),
   .init(LFSR1_INIT),
   .polynom(8'b10101001),

   .lfsr_out(lfsr1),
   .ready(lfsr1_rd)
);

lfsr lfsr_2 (
   .clk(clk),
   .reset(test),
   .init(LFSR2_INIT),
   .polynom(8'b11010001),

   .lfsr_out(lfsr2),
   .ready(lfsr2_rd)
);

always @(posedge clk, posedge reset) begin
    if (reset) begin
        mux <= 0;
        state <= 0;
    end
    else if (rand | test) begin
        mux <= 1;
        if (state != 1 & test) begin
            test_mode_ctr <= test_mode_ctr + 1;
            state <= 1;
        end 
    end
    else if (~rand & state == 0) begin
        mux <= 0;
    end
end

endmodule
