`timescale 1ns / 1ps

module device(
    input reset,
    input clk,
    input start,
    input test,
    input [15:0] sw,

    output reg [6:0] seg,
    output reg [7:0] an,
    output reg R,
    output reg G,
    output reg B
);

wire [9:0] result;
wire ready, ready_crc, lfsr1_rd, lfsr2_rd;
wire [7:0] lfsr1_out, lfsr2_out;

reg [13:0] counter;
reg [2:0] numbers;
reg [7:0] lfsr1, lfsr2;
reg [3:0] h1, d1, u1, h2, d2, u2;
reg test_state, st_func;

localparam LFSR1_INIT = 100;
localparam LFSR2_INIT = 50;

func func_1 (
    // .a(sw[15:8]),
    // .b(sw[7:0]),
    .a(lfsr1),
    .b(lfsr2),
    .reset(~reset | test),
    .start(st_func),
    .clk(clk),
    
    .result(result),
    .ready(ready)
);

lfsr lfsr_1 (
   .clk(clk),
   .reset(test),
   .init(LFSR1_INIT),
   .polynom(8'b10101001),
   .start(0),

   .lfsr_out(lfsr1_out),
   .ready(lfsr1_rd)
);
lfsr lfsr_2 (
   .clk(clk),
   .reset(test),
   .init(LFSR2_INIT),
   .polynom(8'b11010001),
   .start(0),

   .lfsr_out(lfsr2_out),
   .ready(lfsr2_rd)
);
self_testing st_1 (
   .clk(clk),
   .reset(reset),
   .value(result),
   .ready_func(ready),
   .start(test),

   .ready(ready_crc)
);

initial begin
    lfsr1 <= LFSR1_INIT;
    lfsr2 <= LFSR2_INIT;
    counter <= 0;
    numbers <= 0;
    test_state <= 0;
    G <= 0;
    st_func <= 0;
end

localparam MCS_5 = 5000;

always @(posedge clk) begin
    R <= 0;
    G <= ready;
    B <= 0;
    if (lfsr1_rd & lfsr2_rd) begin
        lfsr1 <= lfsr1_out;
        lfsr2 <= lfsr2_out;
        st_func <= 1;
    end
    else
        st_func <= 0;
    
    if (~reset) begin
        test_state <= 0;
        an <= 8'b11111111;
        counter <= 0;
        numbers <= 0;
    end
    else if (test && ~test_state) begin
        test_state <= 1;
        lfsr1 <= LFSR1_INIT;
        lfsr2 <= LFSR2_INIT; 
    end
    else if (~test_state) begin
        counter <= counter + 1;
        if (counter == MCS_5) begin
            counter <= 0;
            numbers <= numbers + 1;
            if (numbers == 8)
                numbers <= 0;
        end
        
        u1 <= ~ready ? sw[7:0] % 10 : result % 10;
        d1 <= ~ready ? (sw[7:0] / 10) % 10 : (result / 10) % 10;
        h1 <= ~ready ? sw[7:0] / 100 : result / 100;

        u2 <= ~ready ? sw[15:8] % 10 : 10;
        d2 <= ~ready ? (sw[15:8] / 10) % 10 : 10;
        h2 <= ~ready ? sw[15:8] / 100 : 10;

        case (numbers)
            0: begin
                seg <= get_segment(u1);
                an <= 8'b11111110;
            end
            1: begin
                seg <= get_segment(d1);
                an <= 8'b11111101;
            end 
            2: begin
                seg <= get_segment(h1);
                an <= 8'b11111011;
            end 
            4: begin
                seg <= get_segment(u2);
                an <= 8'b11101111;
            end
            5: begin
                seg <= get_segment(d2);
                an <= 8'b11011111;
            end
            6: begin
                seg <= get_segment(h2);
                an <= 8'b10111111;
            end
            default: an <= 8'b11111111;
        endcase
    end
    
end

function [6:0] get_segment(input [3:0] digit);
    case (digit)
        4'd0: get_segment = 7'b1000000; // 0
        4'd1: get_segment = 7'b1111001; // 1
        4'd2: get_segment = 7'b0100100; // 2
        4'd3: get_segment = 7'b0110000; // 3
        4'd4: get_segment = 7'b0011001; // 4
        4'd5: get_segment = 7'b0010010; // 5
        4'd6: get_segment = 7'b0000010; // 6
        4'd7: get_segment = 7'b1111000; // 7
        4'd8: get_segment = 7'b0000000; // 8
        4'd9: get_segment = 7'b0010000; // 9
        default: get_segment = 7'b1111111; // все сегменты выключены
    endcase
endfunction

endmodule
