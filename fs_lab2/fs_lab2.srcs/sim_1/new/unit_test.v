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

    reg [7:0] a_values [0:15];
    reg [7:0] b_values [0:15];
    reg [15:0] expected [0:15];

    integer i, count = 0;
    initial begin
        a_values[0] = 8'd0; b_values[0] = 8'd0; expected[0] = 10'd0;
        a_values[1] = 8'd218; b_values[1] = 8'd135; expected[1] = 10'd664;
        a_values[2] = 8'd196; b_values[2] = 8'd150; expected[2] = 10'd598;
        a_values[3] = 8'd98; b_values[3] = 8'd85; expected[3] = 10'd302;
        a_values[4] = 8'd182; b_values[4] = 8'd7; expected[4] = 10'd548;
        a_values[5] = 8'd125; b_values[5] = 8'd131; expected[5] = 10'd385;
        a_values[6] = 8'd54; b_values[6] = 8'd40; expected[6] = 10'd168;
        a_values[7] = 8'd114; b_values[7] = 8'd131; expected[7] = 10'd352;
        a_values[8] = 8'd59; b_values[8] = 8'd68; expected[8] = 10'd185;
        a_values[9] = 8'd2; b_values[9] = 8'd46; expected[9] = 10'd12;
        a_values[10] = 8'd255; b_values[10] = 8'd255; expected[10] = 10'd777;
        a_values[11] = 8'd65; b_values[11] = 8'd222; expected[11] = 10'd207;
        a_values[12] = 8'd99; b_values[12] = 8'd80; expected[12] = 10'd305;
        a_values[13] = 8'd233; b_values[13] = 8'd134; expected[13] = 10'd709;
        a_values[14] = 8'd216; b_values[14] = 8'd166; expected[14] = 10'd658;

        clk = 0;
        start = 0;
        for (i = 0; i < 15; i = i + 1) begin
            a = a_values[i];
            b = b_values[i];
            start = 0;
            #5;
            start = 1;
            
            wait(ready);
            $write("in: %3d | out: %3d | expected: %3d", i, result, expected[i]);
            if (expected[i] != result)
                $display(" - False");
            else begin
                $display("");
                count = count + 1;
            end
                
        end

        $display("Tests %d of 15 passed", count);
        $finish;
    end
endmodule