module Structural_modelling_tb( );

reg a,b;
wire y0, y1,y2;

Structural_modelling uut(a,b,y0,y1,y2);

initial 
begin
        a=0; b=0; 
    #10 a=0; b=1;
    #10 a=1; b=0;
    #10 a=1; b=1;
    #10	

     $finish;
end

endmodule
