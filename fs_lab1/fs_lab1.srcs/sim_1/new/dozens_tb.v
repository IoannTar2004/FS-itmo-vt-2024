`timescale 1ns / 1ps

module dozens_tb;
    reg[3:0] in_reg;
    wire[6:0] out_reg;

    dozens dozens_1 (
        .x1(in_reg[3]),
        .x2(in_reg[2]),
        .x3(in_reg[1]),
        .x4(in_reg[0]),

        .b1(out_reg[6]),
        .b2(out_reg[5]),
        .b3(out_reg[4]),
        .b4(out_reg[3]),
        .b5(out_reg[2]),
        .b6(out_reg[1]),
        .b7(out_reg[0])
    );

    integer i, count;
    initial begin
        for (i = 0; i < 100; i = i + 10) begin
            in_reg = i / 10;
            #10;
            $write("input: %b, output: %b, expected: %7b", in_reg, out_reg, i); 
            if (out_reg != i) begin
                $display(" - false");
            end
            else begin
                $display("");
            end
        end
        $stop;
    end
endmodule
