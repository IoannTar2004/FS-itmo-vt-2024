`timescale 1ns / 1ps

module test(
    input wire [7:0] sw,       // Переключатели
    output reg [6:0] seg,      // Сегменты A-G
    output reg [7:0] an        // Аноды индикаторов
);

// Регистры для текущего числа
    reg [2:0] current_digit;

    // Таблица сегментов для чисел 0–7
    always @(*) begin
        case (current_digit)
            3'd0: seg = 7'b0000001; // 0
            3'd1: seg = 7'b1001111; // 1
            3'd2: seg = 7'b0010010; // 2
            3'd3: seg = 7'b0000110; // 3
            3'd4: seg = 7'b1001100; // 4
            3'd5: seg = 7'b0100100; // 5
            3'd6: seg = 7'b0100000; // 6
            3'd7: seg = 7'b0001111; // 7
            default: seg = 7'b1111111; // Пусто
        endcase
    end

    // Управление анодами и выбор числа
    always @(*) begin
        case (sw)
            8'b00000001: begin an = 8'b11111110; current_digit = 3'd0; end // sw[0]
            8'b00000010: begin an = 8'b11111101; current_digit = 3'd1; end // sw[1]
            8'b00000100: begin an = 8'b11111011; current_digit = 3'd2; end // sw[2]
            8'b00001000: begin an = 8'b11110111; current_digit = 3'd3; end // sw[3]
            8'b00010000: begin an = 8'b11101111; current_digit = 3'd4; end // sw[4]
            8'b00100000: begin an = 8'b11011111; current_digit = 3'd5; end // sw[5]
            8'b01000000: begin an = 8'b10111111; current_digit = 3'd6; end // sw[6]
            8'b10000000: begin an = 8'b01111111; current_digit = 3'd7; end // sw[7]
            default:     begin an = 8'b11111111; current_digit = 3'd0; end // Все выключены
        endcase
    end

endmodule
