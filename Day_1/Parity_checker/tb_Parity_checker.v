module tb_parity_checker();

reg [7:0]data_in;
reg parity;
reg clk;
wire error;

Parity_checker dut(data_in,parity,error);

always #5 clk=~clk;

initial begin
    clk=0;
    #10 data_in=8'b00000000; parity=1;
    #10 data_in=8'b00000001; parity=1;
    #10 data_in=8'b00000011; parity=0;
    #10 data_in=8'b00000111; parity=1;
    #10 data_in=8'b00001111; parity=1;
    #10 data_in=8'b00011111; parity=1;
    #10 data_in=8'b00111111; parity=1;
    #10 data_in=8'b01111111; parity=1;
    #10 $finish;
   
end

always @(posedge clk)begin
    $display("data_in:%b, parity:%b, error:%b",data_in, parity, error);
end

endmodule