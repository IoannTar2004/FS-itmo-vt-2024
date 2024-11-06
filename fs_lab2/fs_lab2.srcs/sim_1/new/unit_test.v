`timescale 1ns / 1ps


module unit_test;
    reg [7:0] a, b;
    reg clk, start;
    wire [9:0] result;
    wire ready;

    func func_1 (
        .a(a),
        .b(b),
        .clk(clk),
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
        start = 0;
        for (i = 1; i < 2; i = i + 1) begin
            a = 154;
            b = 108;
            start = 0;
            #10;
            start = 1;
            
            wait(ready);
            $display("%d", result);
            // expected = expected_cbrt(i);
            // start = 0;
            // $write("in: %3d | out: %d | expected: %1d", i, result, expected);
            // if (expected != result)
            //     $display(" - False");
            // else
            //     $display("");
            
            #10;
        end

        $finish;
    end
endmodule
