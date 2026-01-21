`timescale 1ns/1ps
module float_add_tb;

    reg  [7:0] aIn, bIn;
    wire [7:0] result;

    reg  [7:0] exp_result;
    reg  err;

    // DUT
    float_add dut (
        .aIn(aIn),
        .bIn(bIn),
        .result(result)
    );

    // -------------------------
    // Golden reference model per lab spec
    // - format: [7:5]=exp, [4:0]=mant
    // - align exponents by shifting smaller mantissa RIGHT by diff
    // - add mantissas
    // - if mantissa overflow: exponent++, mantissa = sum[5:1] (drop LSB)
    // - saturate to 111_11111 if exponent would exceed 7
    // -------------------------
    function automatic [7:0] model_add(input [7:0] a, input [7:0] b);
        reg [2:0] ea, eb, e_big, e_small;
        reg [4:0] ma, mb, m_big, m_small;
        reg [3:0] diff;
        reg [4:0] m_small_shifted;
        reg [5:0] m_sum6;
        reg [2:0] e_out;
        reg [4:0] m_out;
        begin
            ea = a[7:5]; ma = a[4:0];
            eb = b[7:5]; mb = b[4:0];

            // Put bigger exponent in (e_big, m_big)
            if (ea >= eb) begin
                e_big = ea; m_big = ma;
                e_small = eb; m_small = mb;
            end else begin
                e_big = eb; m_big = mb;
                e_small = ea; m_small = ma;
            end

            diff = e_big - e_small;

            // Align mantissas: shift smaller mantissa right by diff
            // If diff >= 5, everything shifts out -> 0
            if (diff >= 5) m_small_shifted = 5'b00000;
            else           m_small_shifted = (m_small >> diff);

            // Add mantissas
            m_sum6 = {1'b0, m_big} + {1'b0, m_small_shifted};

            e_out = e_big;
            m_out = m_sum6[4:0];

            // Handle mantissa overflow: keep 5 MSBs of 6-bit sum (drop LSB), exponent++
            if (m_sum6[5] == 1'b1) begin
                // exponent bump might saturate
                if (e_out == 3'b111) begin
                    model_add = 8'b111_11111; // saturate
                end else begin
                    e_out = e_out + 3'b001;
                    m_out = m_sum6[5:1];      // keep top 5 bits, drop LSB
                    model_add = {e_out, m_out};
                end
            end else begin
                model_add = {e_out, m_out};
            end
        end
    endfunction

    // Pretty-printer helpers
    function automatic [2:0] exp_of(input [7:0] x); exp_of = x[7:5]; endfunction
    function automatic [4:0] man_of(input [7:0] x); man_of = x[4:0]; endfunction

    task automatic check(input [7:0] a, input [7:0] b, input [255:0] name);
        begin
            aIn = a;
            bIn = b;
            exp_result = model_add(a, b);
            #5;

            if (result !== exp_result) begin
                $display("FAIL %-12s  a=%b (E=%0d M=%0d)  b=%b (E=%0d M=%0d)  -> got=%b (E=%0d M=%0d)  exp=%b (E=%0d M=%0d)",
                         name,
                         aIn, exp_of(aIn), man_of(aIn),
                         bIn, exp_of(bIn), man_of(bIn),
                         result, exp_of(result), man_of(result),
                         exp_result, exp_of(exp_result), man_of(exp_result));
                err = 1'b1;
            end else begin
                $display("PASS %-12s  a=%b  b=%b  -> %b", name, aIn, bIn, result);
            end
        end
    endtask

    integer i;
    reg [7:0] ra, rb;

    initial begin
        err = 1'b0;

        // -------------------------
        // 15 directed tests
        // -------------------------

        // 1) zero + zero
        check(8'b000_00000, 8'b000_00000, "zero+zero");

        // 2) zero + nonzero (no saturation)
        check(8'b000_00000, 8'b010_10000, "zero+X");

        // 3) commutativity partner of (2)
        check(8'b010_10000, 8'b000_00000, "X+zero");

        // 4) equal exponents, no shift needed
        check(8'b011_10001, 8'b011_00011, "eqExp");

        // 5) exponent diff=1 (small shift)
        check(8'b100_10000, 8'b011_11111, "diff1");

        // 6) exponent diff=2 (more truncation)
        check(8'b101_10000, 8'b011_11111, "diff2");

        // 7) exponent diff>=5 -> smaller mantissa shifts to 0
        check(8'b111_00001, 8'b000_11111, "diff>=5");

        // 8) mantissa overflow causes exponent increment, drop LSB
        // pick same exponent, high mantissas
        check(8'b010_11111, 8'b010_11111, "mantOVF");

        // 9) mantissa overflow when exponent already 111 -> SATURATE
        check(8'b111_11111, 8'b111_11111, "sat+sat");

        // 10) near-saturation: max + something -> saturate
        check(8'b111_11111, 8'b000_10000, "max+small");

        // 11) test from lab doc style (aligned add; you can replace with exact examples you used in writeup)
        check(8'b000_01000, 8'b000_00011, "docLike1");

        // 12) another truncation-heavy: big exponent + small exponent
        check(8'b110_10000, 8'b001_11111, "truncBig");

        // 13) random-ish, no overflow
        check(8'b001_10001, 8'b011_00110, "rand1");

        // 14) random-ish, potential overflow
        check(8'b011_11000, 8'b011_11000, "rand2OVF");

        // 15) commutativity sanity check (swapped operands of 14)
        check(8'b011_11000, 8'b011_11000, "commSame");

        // -------------------------
        // Optional: small random stress (uncomment if you want)
        // -------------------------
        /*
        for (i = 0; i < 50; i = i + 1) begin
            ra = $random;
            rb = $random;

            // Keep them "reasonable": mask to 8-bit, and you can optionally force normalized mantissas.
            ra = ra[7:0];
            rb = rb[7:0];

            check(ra, rb, "random");
        end
        */

        if (!err) $display("ALL FLOAT_ADD TESTS PASSED");
        else      $display("ONE OR MORE FLOAT_ADD TESTS FAILED");

        $finish;
    end

endmodule
