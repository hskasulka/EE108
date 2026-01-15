module hash_round #(parameter ROUND=0)(
    input wire [7:0] in_byte,
    input wire [31:0] in_state,
    output wire [31:0] out_state
);
   
	// Declarations
	wire [7:0] a;
	wire [7:0] b;
	wire [7:0] c;
	wire [7:0] d;
	assign {d,c,b,a} = in_state;
	reg [7:0] mix;
	wire [7:0] mixed_a;
	wire[7:0] rotated_mixed_a;
	// State splitting
	
	// Mix function
	always @(*) begin
	   case(ROUND)
	       0, 1, 2: mix = (c&b)|((~b)&d);
	       3, 4: mix = (c&b)|(b&d)|(c&d);
	       5, 6, 7: mix = (b^c^d);
	       default: mix = (c&b)|((~b)&d);
	   endcase
	end
	
	assign mixed_a = (mix+a)+in_byte;
	
	// Rotator
	rotator #(.WIDTH(8)) rotate (
        .in(mixed_a),
        .out(rotated_mixed_a),
        .distance(ROUND),
        .direction(1'b1)
    );
	// Output state assignment
    assign out_state = {c,b,rotated_mixed_a,d};
endmodule
