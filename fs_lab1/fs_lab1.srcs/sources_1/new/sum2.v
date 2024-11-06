`timescale 1ns / 1ps
module sum2(
    input a,
    input b,
    input p,

    output s,
    output p1
    );

    function [0:0] _nor;
        input a;
        input b;
        
        _nor = ~(a | b);
    endfunction

    function [0:0] _not;
        input a;
        
        _not = _nor(a, a);
    endfunction
    
    function [0:0] _or;
        input a;
        input b;
        
        _or = _not(_nor(a, b));
    endfunction

    wire a_xor_b; 
    assign a_xor_b = _or(_nor(_not(a), b), _nor(a, _not(b)));
    assign s = _or(_nor(_not(a_xor_b), p), _nor(a_xor_b, _not(p)));
    assign p1 = _or(_or(_nor(_not(a), _not(b)), _nor(_not(a), _not(p))), _nor(_not(b), _not(p)));
endmodule
