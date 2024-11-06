`timescale 1ns / 1ps


module unit_test;
    reg [7:0] a, b;
    reg clk, reset_i;
    wire [2:0] result;
    wire ready;
    reg start;

    cbrt cbrt_1 (
        .a(a),
        .clk(clk),
        .reset(reset_i),
        .start(start),

        .result(result),
        .ready(ready)
    );

    always begin
        #5 clk = ~clk;
    end

    function [2:0] expected_cbrt;
        input [7:0] a;
        integer i;
        begin
            for (i = 1; i < 7; i = i + 1) begin
                if (i * i * i >= a) begin
                    expected_cbrt = i * i * i == a ? i : i - 1;
                    i = 7;
                end
            end
        end
    endfunction

    integer i, expected;
    initial begin
        clk = 0;
        for (i = 0; i < 256; i = i + 1) begin
            a = i;
            reset_i = 1;
            #10;
            reset_i = 0;
            start = 1;
            
            wait(ready);
            start = 0;
            expected = expected_cbrt(i);
            $write("in: %3d | out: %d | expected: %1d", i, result, expected);
            if (expected != result)
                $display(" - False");
            else
                $display("");
            
            #10;
        end

        $finish;
    end
endmodule
