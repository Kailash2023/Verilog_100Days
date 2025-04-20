module tb_Behaviour_modelling();
reg a,b;
wire y0,y1,y2;

Behaviour_modelling dut(a,b,y0,y1,y2);

initial 
begin
    #10 a=1'b0; b=1'b0; 
    #10 a=1'b0; b=1'b1; 
    #10 a=1'b1; b=1'b0; 
    #10 a=1'b1; b=1'b1; 
    
    $finish;
end


endmodule