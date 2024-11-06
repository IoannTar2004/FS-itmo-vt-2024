`timescale 1ns / 1ps

module BCD_bin_tb;
    reg[7:0] input_values;
    wire[6:0] result;

    wire[6:0] dozens;
    dozens dozens_1 (
        .values(input_values[7:4]),
        .dozens(dozens)
    );

    sum7 sum7_1 (
        .dozens(dozens),
        .units(input_values[3:0]),

        .result(result)
    );

    integer i, units;
    initial begin
        for (i = 0; i < 100; i = i + 1) begin
            input_values[7:4] = i / 10;
            units = i % 10;
            input_values[3:0] = units;
            #10;

            $write("%d (%b) | %1d (%4b) | %d (%b) | %2d (%7b)", dozens, dozens, units, units,
                    result, result, i, i);
            if (result != i)
                $display(" - false");
            else begin
                $display("");
            end
        end
        $stop;
    end
endmodule
