module adder (
    input [4:0] a,
    input [4:0] b,
    output [4:0] sum,
    output cout
);
    wire [5:0] couts;

full_adder a0 (
    .a(a[0]),
    .b(b[0]),
    .cin(1'b0),
    .cout(couts[0]),
    .sum(sum[0])
);

full_adder a1 (
    .a(a[1]),
    .b(b[1]),
    .cin(couts[0]),
    .cout(couts[1]),
    .sum(sum[1])
);

full_adder a2 (
    .a(a[2]),
    .b(b[2]),
    .cin(couts[1]),
    .cout(couts[2]),
    .sum(sum[2])
);

full_adder a3 (
    .a(a[3]),
    .b(b[3]),
    .cin(couts[2]),
    .cout(couts[3]),
    .sum(sum[3])
);

full_adder a4 (
    .a(a[4]),
    .b(b[4]),
    .cin(couts[3]),
    .cout(couts[4]),
    .sum(sum[4])
);

assign cout = couts[4];

endmodule