module hasher (
   input wire [63:0] data,
   input wire [3:0] data_len,
   output wire [31:0] hash
);

    wire [7:0] byte_seven,byte_six,byte_five,byte_four,
    byte_three,byte_two,byte_one,byte_zero;
    
    assign{byte_seven,byte_six,byte_five,byte_four,
    byte_three,byte_two,byte_one,byte_zero} = data;
    
    wire [31:0] out_seven, out_six, out_five, out_four,
    out_three, out_two, out_one, out_zero;
    
    wire [31:0] final_state;
	// DO IT GORDON
	
	hash_round #(.ROUND(0)) r0 (
	.in_byte(byte_zero),
	.in_state(32'h55555555),
	.out_state(out_zero));
	
	hash_round #(.ROUND(1)) r1 (
	.in_byte(byte_one),
	.in_state(32'hAAAAAAAA),
	.out_state(out_one));
	
	hash_round #(.ROUND(2)) r2 (
	.in_byte(byte_two),
	.in_state(out_zero),
	.out_state(out_two));
	
	hash_round #(.ROUND(3)) r3 (
	.in_byte(byte_three),
	.in_state(out_one),
	.out_state(out_three));
	
	hash_round #(.ROUND(4)) r4 (
	.in_byte(byte_four),
	.in_state(out_two),
	.out_state(out_four));
	
	hash_round #(.ROUND(5)) r5 (
	.in_byte(byte_five),
	.in_state(out_three),
	.out_state(out_five));
	
	hash_round #(.ROUND(6)) r6 (
	.in_byte(byte_six),
	.in_state(out_four),
	.out_state(out_six));
	
	hash_round #(.ROUND(7)) r7 (
	.in_byte(byte_seven),
	.in_state(out_five),
	.out_state(out_seven));
	
	assign final_state = out_six^out_seven;
	
	rotator #(.WIDTH(32), .DISTANCE(5)) rotateHash (
        .in(final_state),
        .out(hash), //hash
        .distance(final_state[4:0]),
        .direction(^data_len)
    );
endmodule
