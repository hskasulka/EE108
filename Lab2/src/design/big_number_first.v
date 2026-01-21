module big_number_first (
    input wire [7:0] aIn,
    input wire [7:0] bIn,
    output wire [7:0] aOut,
    output wire [7:0] bOut
);

wire [2:0] aExp = aIn[7:5];
wire [2:0] bExp = bIn[7:5];

wire larger = aExp > bExp;

assign aOut = larger ? aIn : bIn;
assign bOut = larger ? bIn : aIn;

endmodule