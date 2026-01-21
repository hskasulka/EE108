`timescale 1ns/1ps
module big_number_first_tb;

    reg  [7:0] aIn, bIn;
    wire [7:0] aOut, bOut;

    reg  [7:0] exp_aOut, exp_bOut;
    reg  err;

    big_number_first dut (
        .aIn(aIn),
        .bIn(bIn),
        .aOut(aOut),
        .bOut(bOut)
    );

    task check;
        input [7:0] aa, bb;
        input [7:0] ea, eb;
        begin
            aIn = aa;
            bIn = bb;
            exp_aOut = ea;
            exp_bOut = eb;
            #5;

            if (aOut !== exp_aOut || bOut !== exp_bOut) begin
                $display("FAIL: aIn=%b (exp=%0d) bIn=%b (exp=%0d) | aOut=%b bOut=%b (exp aOut=%b bOut=%b)",
                         aIn, aIn[7:5], bIn, bIn[7:5], aOut, bOut, exp_aOut, exp_bOut);
                err = 1'b1;
            end
        end
    endtask

    initial begin
        err = 1'b0;

        // Exponent field is [7:5]; only that determines ordering

        // 1) aExp > bExp  -> keep order
        check(8'b101_00011, 8'b011_11100,  8'b101_00011, 8'b011_11100);

        // 2) aExp < bExp  -> swap
        check(8'b001_10101, 8'b110_01010,  8'b110_01010, 8'b001_10101);

        // 3) aExp == bExp -> larger=0, module swaps (b becomes aOut)
        check(8'b010_00001, 8'b010_11110,  8'b010_11110, 8'b010_00001);

        // 4) boundary: aExp=000, bExp=111 -> swap
        check(8'b000_11011, 8'b111_00000,  8'b111_00000, 8'b000_11011);

        // 5) boundary: aExp=111, bExp=000 -> keep
        check(8'b111_10101, 8'b000_01010,  8'b111_10101, 8'b000_01010);

        // 6) adjacent exponents: 3 vs 4 -> swap
        check(8'b011_00110, 8'b100_00110,  8'b100_00110, 8'b011_00110);

        // 7) adjacent exponents: 5 vs 4 -> keep
        check(8'b101_11111, 8'b100_00001,  8'b101_11111, 8'b100_00001);

        // 8) equal exponents with very different mantissas -> still swaps
        check(8'b001_00000, 8'b001_11111,  8'b001_11111, 8'b001_00000);

        // 9) random: 6 vs 2 -> keep
        check(8'b110_01001, 8'b010_10110,  8'b110_01001, 8'b010_10110);

        // 10) random: 2 vs 6 -> swap
        check(8'b010_10110, 8'b110_01001,  8'b110_01001, 8'b010_10110);

        if (!err) $display("ALL BIG_NUMBER_FIRST TESTS PASSED");
        else      $display("ONE OR MORE BIG_NUMBER_FIRST TESTS FAILED");

        $finish;
    end

endmodule
