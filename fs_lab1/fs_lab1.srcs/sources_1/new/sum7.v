`timescale 1ns / 1ps

module sum7(
    input wire[6:0] dozens,
    input wire[3:0] units,

    output wire[6:0] result
    );

    wire[6:0] ps;
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin
            if (i == 0) begin
                sum2 sum2_1 (
                    .a(dozens[i]),
                    .b(units[i]),
                    .p(0),
                    
                    .s(result[i]),
                    .p1(ps[i])
                );
            end else if (i > 0 && i < 4) begin
                sum2 sum2_1 (
                    .a(dozens[i]),
                    .b(units[i]),
                    .p(ps[i - 1]),

                    .s(result[i]),
                    .p1(ps[i])
                );
            end else begin
                sum2 sum2_1 (
                    .a(dozens[i]),
                    .b(0),
                    .p(ps[i - 1]),

                    .s(result[i]),
                    .p1(ps[i])
                );
            end
        end
    endgenerate
endmodule
