module float_add (
    input wire [7:0] aIn,
    input wire [7:0] bIn,
    output wire [7:0] result
);

// Wire Declarations
wire [7:0] aI, bI, float_sum, float_overflow, out;
wire [2:0] aExp, bExp, distance, expUp;
wire [4:0] aMan, bMan, bShift, sum, sum_overflow;
wire cout;

// Set aI to have larger exponent
big_number_first bnf (
    .aIn(aIn),
    .bIn(bIn),
    .aOut(aI),
    .bOut(bI)
);

// Split a and b into Exponent and Mantissa
assign aExp = aI[7:5];
assign bExp = bI[7:5];
assign aMan = aI[4:0];
assign bMan = bI[4:0];

// Shift B Mantissa
assign distance = aExp - bExp;
shifter #(.WIDTH(5), .WRAP(0)) shift (
    .in(bMan),
    .dist(distance),
    .dir(1'b1),
    .out(bShift)
);

// Add Mantissas
adder add (
    .a(aMan),
    .b(bShift),
    .sum(sum),
    .cout(cout)
);
assign float_sum = {aExp, sum};

// Compute Overflow Sum
assign expUp = aExp + 3'b001;
assign sum_overflow = {1'b1,sum[4:1]};
assign float_overflow = {expUp,sum_overflow};

// Output Multiplexer
assign out = cout ? float_overflow : float_sum;
assign result = (expUp==3'b000&cout) ? 8'b111_11111 : out;

endmodule