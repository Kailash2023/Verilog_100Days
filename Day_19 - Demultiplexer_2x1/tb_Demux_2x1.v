module tb_demux();

reg i, sel;
wire y0,y1;

Demux_2x1 uut(i,sel,y0,y1);

initial begin 
    sel=0; i=0; 
    #10;
    sel=0; i=1; 
    #10;
    sel=1; i=0; 
    #10;
    sel=1; i=1; 
end

initial 
     begin $monitor("sel: %b  i: %b  y[0]: %b  y[1]: %b", sel, i, y0, y1);
     #40 $finish;
     end

endmodule