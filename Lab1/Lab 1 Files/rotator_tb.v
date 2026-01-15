module rotator_tb ();

    // Test two different widths of rotator

    reg [7:0] in_8;
    reg [7:0] expected_8;
    wire [7:0] out_8;
    reg [7:0] distance_8;
    reg direction_8;
    rotator #(.WIDTH(8)) dut_8 (
        .in(in_8),
        .out(out_8),
        .distance(distance_8),
        .direction(direction_8)
    );

    reg [31:0] in_32;
    reg [31:0] expected_32;
    wire [31:0] out_32;
    reg [7:0] distance_32;
    reg direction_32;
    rotator #(.WIDTH(32)) dut_32 (
        .in(in_32),
        .out(out_32),
        .distance(distance_32),
        .direction(direction_32)
    );

    reg err;

    initial begin
        err = 1'b0;
        
        ////// 8-bit tests ////////////////////

        // Basic test cases
        direction_8 = 0;
        distance_8 = 8'd2;
        in_8 = 8'b00010000;
        expected_8 = 8'b00000100;
        #5
        $display ("%b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: 8-bit test failed!");
            err = 1'b1;
        end

        direction_8 = 1;
        expected_8 = 8'b01000000;
        #5
        $display ("%b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: 8-bit test failed!");
            err = 1'b1;
        end

        // Edge case: rotate by 0 (should be unchanged)
        direction_8 = 0;
        distance_8 = 8'd0;
        in_8 = 8'b10101010;
        expected_8 = 8'b10101010;
        #5
        $display ("Rotate by 0: %b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: Rotate by 0 test failed!");
            err = 1'b1;
        end
        
        // Edge case: rotate by full width (8)
        direction_8 = 0;
        distance_8 = 8'd8;
        in_8 = 8'b11001100;
        expected_8 = 8'b11001100;  // Full rotation returns to original
        #5
        $display ("Rotate by 8: %b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: Rotate by 8 test failed!");
            err = 1'b1;
        end
        
        // Rotate left by 1
        direction_8 = 1;
        distance_8 = 8'd1;
        in_8 = 8'b10110001;
        expected_8 = 8'b01100011;
        #5
        $display ("Rotate left by 1: %b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: Rotate left by 1 test failed!");
            err = 1'b1;
        end
        
        // Rotate right by 1
        direction_8 = 0;
        distance_8 = 8'd1;
        in_8 = 8'b10110001;
        expected_8 = 8'b11011000;
        #5
        $display ("Rotate right by 1: %b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: Rotate right by 1 test failed!");
            err = 1'b1;
        end
        
        // Rotate left by 4 (half width)
        direction_8 = 1;
        distance_8 = 8'd4;
        in_8 = 8'b11110000;
        expected_8 = 8'b00001111;
        #5
        $display ("Rotate left by 4: %b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: Rotate left by 4 test failed!");
            err = 1'b1;
        end
        
        // Rotate right by 7 (almost full rotation)
        direction_8 = 0;
        distance_8 = 8'd7;
        in_8 = 8'b10000000;
        expected_8 = 8'b00000001;
        #5
        $display ("Rotate right by 7: %b -> %b, expected %b", in_8, out_8, expected_8);
        if (expected_8 !== out_8) begin
            $display ("ERROR: Rotate right by 7 test failed!");
            err = 1'b1;
        end


        ////// 32-bit tests ///////////////////
        // Don't worry about repeating ALL of your 8-bit tests here, the point is
        // just to make sure that parameterization of the module works correctly.
        // Basic tests will suffice, edge case tests aren't necessary for this lab

        // Add basic 32-bit test cases here
        // Basic rotate right
        direction_32 = 0;
        distance_32 = 8'd4;
        in_32 = 32'h12345678;
        expected_32 = 32'h81234567;
        #5
        $display ("32-bit rotate right: %h -> %h, expected %h", in_32, out_32, expected_32);
        if (expected_32 !== out_32) begin
            $display ("ERROR: 32-bit rotate right test failed!");
            err = 1'b1;
        end
        
        // Basic rotate left
        direction_32 = 1;
        distance_32 = 8'd8;
        in_32 = 32'hAABBCCDD;
        expected_32 = 32'hBBCCDDAA;
        #5
        $display ("32-bit rotate left: %h -> %h, expected %h", in_32, out_32, expected_32);
        if (expected_32 !== out_32) begin
            $display ("ERROR: 32-bit rotate left test failed!");
            err = 1'b1;
        end
        
        // Edge case: rotate by 0
        direction_32 = 0;
        distance_32 = 8'd0;
        in_32 = 32'hDECAFBAD;
        expected_32 = 32'hDECAFBAD;
        #5
        $display ("32-bit rotate by 0: %h -> %h, expected %h", in_32, out_32, expected_32);
        if (expected_32 !== out_32) begin
            $display ("ERROR: 32-bit rotate by 0 test failed!");
            err = 1'b1;
        end
        
        // Rotate by full width (32)
        direction_32 = 1;
        distance_32 = 8'd32;
        in_32 = 32'h12345678;
        expected_32 = 32'h12345678;
        #5
        $display ("32-bit rotate by 32: %h -> %h, expected %h", in_32, out_32, expected_32);
        if (expected_32 !== out_32) begin
            $display ("ERROR: 32-bit rotate by 32 test failed!");
            err = 1'b1;
        end
        
        if (err == 1'b0) begin
            $display ("All tests in test bench passed successfully!");
        end
    end

endmodule