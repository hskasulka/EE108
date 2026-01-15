module length_finder_tb ();

    reg  [63:0] in;
    reg  [3:0]  expected;
    wire [3:0]  len;

    length_finder dut (
        .string(in),
        .length(len)
    );

    initial begin
        // Test case 1: NULL in byte 0
        in = 64'hAABBCCDDEEFFAA00;
        expected = 4'd0;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 2: no NULLs
        in = 64'hAABBCCDDEEFFAA99;
        expected = 4'd8;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 3: NULL in byte 1
        in = 64'hAABBCCDDEEFF00AA;
        expected = 4'd1;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 4: NULL in byte 2
        in = 64'hAABBCCDDEE00FFAA;
        expected = 4'd2;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 5: multiple NULLs, first at byte 2
        in = 64'hAABBCC00EE00FFAA;
        expected = 4'd2;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 6: NULL in byte 7 (MSB)
        in = 64'h00BBCCDDEE44FFAA;
        expected = 4'd7;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 7: NULL in byte 4
        in = 64'h00BBCC00EE44FFAA;
        expected = 4'd4;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 8: no NULLs (tricky pattern)
        in = 64'h44BBC00DEE44FFAA;
        expected = 4'd8;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

        // Test case 9: all NULLs
        in = 64'h0000000000000000;
        expected = 4'd0;
        #5
        $display("%h -> %d, expected %d", in, len, expected);

    end

endmodule
