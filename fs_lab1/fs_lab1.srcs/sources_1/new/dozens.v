`timescale 1ns / 1ps

module dozens(
    input wire[3:0] values,
    output wire[7:0] dozens
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

     function [0:0] _nor3;
        input a;
        input b;
        input c;
        
        _nor3 = _nor(_or(a, b), c);
    endfunction

    wire x1 = values[3], x2 = values[2], x3 = values[1], x4 = values[0];

    wire nx1 = _not(x1);
    wire nx2 = _not(x2);
    wire nx3 = _not(x3);
    wire nx4 = _not(x4);
    
    wire z1, z2, z3, z4, z5;

    assign z1 = _or(x2, x3), z2 =_or(x1, nx2), z3 = _nor(nx3, x4);
    assign z4 = _nor(x1, nx3), z5 = _nor(z1, nx4);

    assign dozens[6] = _or(_nor(z1, nx1), ~(nx3 | nx4 | z2));
    assign dozens[5] = _nor(z2, _nor(z3, nx3));
    assign dozens[4] = _or(_nor(x2, _nor(z4, _nor(nx1, x3))), _nor(z2, _nor(z3, _nor(x3, nx4))));
    assign dozens[3] = _or(_nor(x1, _nor(_nor(x2, nx4), _nor(nx2, x4))), z5);
    assign dozens[2] = z4;
    assign dozens[1] = _or(_nor(x1, nx4), z5);
    assign dozens[0] = 0;
    
endmodule
