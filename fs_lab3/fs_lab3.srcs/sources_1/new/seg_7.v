`timescale 1ns / 1ps

module seg_7(
    input clk,
    input [15:0] sw,
    output reg [6:0] seg,
    output reg [7:0] an
);

reg [31:0] counter;
reg [2:0] numbers;
reg [3:0] h1, d1, u1, h2, d2, u2;

initial begin
    counter <= 0;
    numbers <= 0;
end

localparam MCS_5 = 5000;
    // Сегменты для цифры 8: включены все сегменты кроме точки

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == MCS_5) begin
        counter <= 0;
        numbers <= numbers + 1;
        if (numbers == 8)
            numbers <= 0;
    end
    
    u1 <= sw[7:0] % 10;
    d1 <= (sw[7:0] / 10) % 10;
    h1 <= sw[7:0] / 100;

    u2 <= sw[15:8] % 10;
    d2 <= (sw[15:8] / 10) % 10;
    h2 <= sw[15:8] / 100;

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
