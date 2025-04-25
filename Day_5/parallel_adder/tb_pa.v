`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 05:49:21 PM
// Design Name: 
// Module Name: tb_pa
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_pa( );

reg [3:0]a,b;
reg cin;
wire [3:0]s;
wire cout;

parallel_adder dut(a,b,cin,s,cout);

always begin
    a=$random;
    b=$random;
    cin=$random;
    #10;
end

initial begin
    $monitor("a=%b,b=%b,cin=%b,sum=%b,carry=%b",a,b,cin,s,cout);
    #60;
    $finish;

end

endmodule
