`timescale 1ns/1ps
module adder_tb;

    reg  [4:0] a;
    reg  [4:0] b;
    wire [4:0] sum;
    wire       cout;

    reg  [4:0] exp_sum;
    reg        exp_cout;

    reg err;

    adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        err = 1'b0;

        // -------------------------
        // 5-bit ADDER TESTS (15 cases)
        // sum is lower 5 bits, cout is carry-out bit
        // -------------------------

        // 1) 0 + 0 = 0
        a = 5'd0;  b = 5'd0;  exp_sum = 5'd0;  exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 2) 1 + 0 = 1
        a = 5'd1;  b = 5'd0;  exp_sum = 5'd1;  exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 3) 0 + 1 = 1
        a = 5'd0;  b = 5'd1;  exp_sum = 5'd1;  exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 4) 1 + 1 = 2
        a = 5'd1;  b = 5'd1;  exp_sum = 5'd2;  exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 5) 15 + 1 = 16
        a = 5'd15; b = 5'd1;  exp_sum = 5'd16; exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 6) 16 + 1 = 17
        a = 5'd16; b = 5'd1;  exp_sum = 5'd17; exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 7) 31 + 0 = 31
        a = 5'd31; b = 5'd0;  exp_sum = 5'd31; exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 8) 31 + 1 = 32 -> sum wraps to 0, cout=1
        a = 5'd31; b = 5'd1;  exp_sum = 5'd0;  exp_cout = 1'b1; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 9) 31 + 31 = 62 -> sum=30, cout=1
        a = 5'd31; b = 5'd31; exp_sum = 5'd30; exp_cout = 1'b1; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 10) alternating bits: 21 + 10 = 31
        a = 5'd21; b = 5'd10; exp_sum = 5'd31; exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 11) carry chain check: 7 + 1 = 8
        a = 5'd7;  b = 5'd1;  exp_sum = 5'd8;  exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 12) carry chain check: 15 + 17 = 32 -> sum=0, cout=1
        a = 5'd15; b = 5'd17; exp_sum = 5'd0;  exp_cout = 1'b1; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 13) random-ish: 18 + 9 = 27
        a = 5'd18; b = 5'd9;  exp_sum = 5'd27; exp_cout = 1'b0; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 14) random-ish overflow: 28 + 7 = 35 -> sum=3, cout=1
        a = 5'd28; b = 5'd7;  exp_sum = 5'd3;  exp_cout = 1'b1; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end

        // 15) extreme overflow: 30 + 30 = 60 -> sum=28, cout=1
        a = 5'd30; b = 5'd30; exp_sum = 5'd28; exp_cout = 1'b1; #5;
        if (sum !== exp_sum || cout !== exp_cout) begin
            $display("ADD  %0d + %0d -> sum=%0d cout=%b  (exp sum=%0d cout=%b)", a,b,sum,cout,exp_sum,exp_cout);
            err = 1'b1;
        end


        if (!err) $display("ALL ADDER TESTS PASSED");
        else      $display("ONE OR MORE ADDER TESTS FAILED");

        $finish;
    end

endmodule
