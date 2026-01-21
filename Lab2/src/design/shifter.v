module shifter #(parameter WIDTH = 8, parameter WRAP  = 0) (
    input wire [WIDTH-1:0] in,
    input wire [3:0] dist,
    input wire dir,
    output wire [WIDTH-1:0]out
);
    // Use only as many bits as needed to represent WIDTH-1
    localparam integer DBITS = (WIDTH <= 2) ? 1 :
                               (WIDTH <= 4) ? 2 :
                               (WIDTH <= 8) ? 3 :
                               (WIDTH <= 16)? 4 :
                               (WIDTH <= 32)? 5 :
                               (WIDTH <= 64)? 6 : 7;

    wire [DBITS-1:0] d = dist[DBITS-1:0];

    // Rotator Construction and Candidates
    wire [WIDTH*2-1:0] double_in;
    assign double_in = {2{in}};

    wire [WIDTH*2-1:0] double_rot_l = double_in << d;
    wire [WIDTH*2-1:0] double_rot_r = double_in >> d;
    wire [WIDTH-1:0]   rot_l        = double_rot_l[WIDTH*2-1:WIDTH];
    wire [WIDTH-1:0]   rot_r        = double_rot_r[WIDTH-1:0];

    // Bitshift Candidates
    wire [WIDTH-1:0] shift_l = in << d;
    wire [WIDTH-1:0] shift_r = in >> d;

    // Select Rotate vs Shift
    wire [WIDTH-1:0] left_val  = (WRAP != 0) ? rot_l   : shift_l;
    wire [WIDTH-1:0] right_val = (WRAP != 0) ? rot_r   : shift_r;

    // Output Mux
    assign out = dir ? right_val : left_val;

endmodule
