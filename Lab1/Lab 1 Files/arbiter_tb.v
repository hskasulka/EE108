module arbiter_tb ();
    reg [7:0] in;
    reg [7:0] expected;
    wire [7:0] out;
    arbiter dut (.in(in), .out(out));

    initial begin
        // Basic test case #1
        in = 8'b00000110;
        expected = 8'b00000010;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

        // Basic test case #2
        in = 8'b00100000;
        expected = 8'b00100000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);

        in = 8'b00100101;
        expected = 8'b00000001;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b01111100;
        expected = 8'b00000100;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b10100101;
        expected = 8'b00000001;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b00100110;
        expected = 8'b00000010;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b11000000;
        expected = 8'b01000000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b11011000;
        expected = 8'b00001000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b11111111;
        expected = 8'b00000001;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b00010000;
        expected = 8'b00010000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        
        in = 8'b00000000;
        expected = 8'b00000000;
        #5
        $display("%b -> %b, expected %b", in, out, expected);
        // Add more test cases here

    end

endmodule
