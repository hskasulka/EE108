module encoder (
    input wire [7:0] in,
    output reg [2:0] out
);
    always @(*) begin
        case (in)
            8'b00000001: out = 3'b000; //0
            8'b00000010: out = 3'b001; // 1
            8'b00000100: out = 3'b010; // 2
            8'b00001000: out = 3'b011; // 3
            8'b00010000: out = 3'b100; // 4
            8'b00100000: out = 3'b101; // 5
            8'b01000000: out = 3'b110; // 6
            8'b10000000: out = 3'b111; // 7
            default: out = 3'b000; // default
        endcase
    end
endmodule
