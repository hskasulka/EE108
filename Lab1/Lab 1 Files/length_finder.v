module length_finder (
    input wire [63:0] string,
    output wire [3:0] length
);
   
   wire [7:0] is_character_null;
   
   assign is_character_null[0] = ~(|string[7:0]);
   assign is_character_null[1] = ~(|string[15:8]);
   assign is_character_null[2] = ~(|string[23:16]);
   assign is_character_null[3] = ~(|string[31:24]);
   assign is_character_null[4] = ~(|string[39:32]);
   assign is_character_null[5] = ~(|string[47:40]);
   assign is_character_null[6] = ~(|string[55:48]);
   assign is_character_null[7] = ~(|string[63:56]);
	
	arbiter arbiterlf(
	   .in (is_character_null),
	   .out (first_null)
	);
	
	encoder encoderlf(
	   .in(first_null),
	   .out(length[2:0])
	);
	
	assign length[3] = ~(|first_null);
  
endmodule
