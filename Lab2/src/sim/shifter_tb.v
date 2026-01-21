`timescale 1ns/1ps
module shifter_tb (

);

    reg [2:0] dist;
    reg dir;

    reg [4:0] in_5;
    reg [4:0] exps_5;
    reg [4:0] expw_5;
    wire [4:0] outs_5;
    wire [4:0] outw_5;
    
    reg[7:0] in_8;
    reg [7:0] exps_8;
    reg [7:0] expw_8;
    wire [7:0] outs_8;
    wire [7:0] outw_8;

shifter #(.WIDTH(5), .WRAP(0)) shift_5 (
    .in(in_5),
    .dist(dist),
    .dir(dir),
    .out(outs_5)
);

shifter #(.WIDTH(5), .WRAP(1)) wrap_5 (
    .in(in_5),
    .dist(dist),
    .dir(dir),
    .out(outw_5)
);

shifter #(.WIDTH(8), .WRAP(0)) shift_8 (
    .in(in_8),
    .dist(dist),
    .dir(dir),
    .out(outs_8)
);

shifter #(.WIDTH(8), .WRAP(1)) wrap_8 (
    .in(in_8),
    .dist(dist),
    .dir(dir),
    .out(outw_8)
);

reg err;
initial begin
    err = 1'b0;
    
        // -------------------------
    // SHIFT ONLY TESTS (WRAP=0)
    // -------------------------

    // ===== 5-bit shifter =====
    in_5 = 5'b10101;

    // 5-bit SHIFT LEFT (dir=0)
    dir = 1'b0;

    dist = 3'd0; exps_5 = 5'b10101; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 L0  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd1; exps_5 = 5'b01010; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 L1  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd2; exps_5 = 5'b10100; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 L2  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd3; exps_5 = 5'b01000; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 L3  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd4; exps_5 = 5'b10000; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 L4  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end


    // 5-bit SHIFT RIGHT (dir=1)
    dir = 1'b1;

    dist = 3'd0; exps_5 = 5'b10101; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 R0  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd1; exps_5 = 5'b01010; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 R1  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd2; exps_5 = 5'b00101; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 R2  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd3; exps_5 = 5'b00010; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 R3  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end

    dist = 3'd4; exps_5 = 5'b00001; #5;
    if (exps_5 !== outs_5) begin $display("SHIFT5 R4  %b -> %b exp %b", in_5, outs_5, exps_5); err=1'b1; end


    // ===== 8-bit shifter =====
    in_8 = 8'b1010_1101;

    // 8-bit SHIFT LEFT (dir=0)
    dir = 1'b0;

    dist = 3'd0; exps_8 = 8'b1010_1101; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 L0  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd1; exps_8 = 8'b0101_1010; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 L1  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd2; exps_8 = 8'b1011_0100; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 L2  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd3; exps_8 = 8'b0110_1000; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 L3  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd4; exps_8 = 8'b1101_0000; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 L4  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end


    // 8-bit SHIFT RIGHT (dir=1)
    dir = 1'b1;

    dist = 3'd0; exps_8 = 8'b1010_1101; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 R0  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd1; exps_8 = 8'b0101_0110; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 R1  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd2; exps_8 = 8'b0010_1011; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 R2  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd3; exps_8 = 8'b0001_0101; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 R3  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

    dist = 3'd4; exps_8 = 8'b0000_1010; #5;
    if (exps_8 !== outs_8) begin $display("SHIFT8 R4  %b -> %b exp %b", in_8, outs_8, exps_8); err=1'b1; end

        // -------------------------
    // WRAP / ROTATE TESTS (WRAP=1)
    // -------------------------

    // ===== 5-bit wrapper =====
    in_5 = 5'b10101;

    // 5-bit WRAP LEFT (dir=0)
    dir = 1'b0;

    dist = 3'd0; expw_5 = 5'b10101; #5;
    if (expw_5 !== outw_5) begin $display("WRAP5 L0   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd1; expw_5 = 5'b01011; #5; // rotl1
    if (expw_5 !== outw_5) begin $display("WRAP5 L1   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd2; expw_5 = 5'b10110; #5; // rotl2
    if (expw_5 !== outw_5) begin $display("WRAP5 L2   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd3; expw_5 = 5'b01101; #5; // rotl3
    if (expw_5 !== outw_5) begin $display("WRAP5 L3   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd4; expw_5 = 5'b11010; #5; // rotl4
    if (expw_5 !== outw_5) begin $display("WRAP5 L4   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end


    // 5-bit WRAP RIGHT (dir=1)
    dir = 1'b1;

    dist = 3'd0; expw_5 = 5'b10101; #5;
    if (expw_5 !== outw_5) begin $display("WRAP5 R0   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd1; expw_5 = 5'b11010; #5; // rotr1
    if (expw_5 !== outw_5) begin $display("WRAP5 R1   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd2; expw_5 = 5'b01101; #5; // rotr2
    if (expw_5 !== outw_5) begin $display("WRAP5 R2   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd3; expw_5 = 5'b10110; #5; // rotr3
    if (expw_5 !== outw_5) begin $display("WRAP5 R3   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end

    dist = 3'd4; expw_5 = 5'b01011; #5; // rotr4
    if (expw_5 !== outw_5) begin $display("WRAP5 R4   %b -> %b exp %b", in_5, outw_5, expw_5); err=1'b1; end


    // ===== 8-bit wrapper =====
    in_8 = 8'b1010_1101;

    // 8-bit WRAP LEFT (dir=0)
    dir = 1'b0;

    dist = 3'd0; expw_8 = 8'b1010_1101; #5;
    if (expw_8 !== outw_8) begin $display("WRAP8 L0   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd1; expw_8 = 8'b0101_1011; #5; // rotl1
    if (expw_8 !== outw_8) begin $display("WRAP8 L1   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd2; expw_8 = 8'b1011_0110; #5; // rotl2
    if (expw_8 !== outw_8) begin $display("WRAP8 L2   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd3; expw_8 = 8'b0110_1101; #5; // rotl3
    if (expw_8 !== outw_8) begin $display("WRAP8 L3   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd4; expw_8 = 8'b1101_1010; #5; // rotl4
    if (expw_8 !== outw_8) begin $display("WRAP8 L4   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end


    // 8-bit WRAP RIGHT (dir=1)
    dir = 1'b1;

    dist = 3'd0; expw_8 = 8'b1010_1101; #5;
    if (expw_8 !== outw_8) begin $display("WRAP8 R0   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd1; expw_8 = 8'b1101_0110; #5; // rotr1
    if (expw_8 !== outw_8) begin $display("WRAP8 R1   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd2; expw_8 = 8'b0110_1011; #5; // rotr2
    if (expw_8 !== outw_8) begin $display("WRAP8 R2   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd3; expw_8 = 8'b1011_0101; #5; // rotr3
    if (expw_8 !== outw_8) begin $display("WRAP8 R3   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    dist = 3'd4; expw_8 = 8'b0101_1010; #5; // rotr4
    if (expw_8 !== outw_8) begin $display("WRAP8 R4   %b -> %b exp %b", in_8, outw_8, expw_8); err=1'b1; end

    
    end
endmodule