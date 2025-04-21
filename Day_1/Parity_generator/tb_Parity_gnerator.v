module tb_parity_generator();

reg [7:0] data_in;
reg clk;
wire parity;

Parity_generator dut(data_in,parity);

always #5 clk=~clk;

initial
begin
    clk=0;
    #10 data_in=8'b00000000;
    #10 data_in=8'b00000001;
    #10 data_in=8'b00000011;
    #10 data_in=8'b00000111;
    #10 data_in=8'b00001111;
    #10 data_in=8'b00011111;
    #10 data_in=8'b00111111;
    #10 data_in=8'b01111111;
    #10 $finish;
end
    
always@(posedge clk) begin
    $display("data: %b, parity:%b",data_in,parity);
end    
    
endmodule