module tb_gates();

reg a,b;
wire gate_and,gate_or,gate_not;

gates_using_2x1_mux dut(a,b,gate_and,gate_or,gate_not);

initial begin
            a= 1'b0; b= 1'b0;
        #10 a= 1'b0; b= 1'b1;
        #10 a= 1'b1; b= 1'b0;
        #10 a= 1'b1; b= 1'b1;
    end

initial begin 
    $monitor("a=%b,b=%b,gate_and=%b,gate_or=%b,gate_not=%b",a,b,gate_and,gate_or,gate_not);
    #40 $finish;
end

endmodule
