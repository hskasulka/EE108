module verifier ( input wire [63:0] password,
                  input wire [63:0] username,
                  output wire valid
);

	// FINISH HIM
	
	// Declare intermediary wires
    wire [3:0] password_len;
    wire [3:0] username_len;
    wire [31:0] hashed_password;
    wire [31:0] stored_hash;
    wire [2:0] user_addr;
    wire username_valid;

    // find password length
    length_finder pass_len (	
        .string(password),
        .length(password_len)
    );
    
    // hash the input password
    hasher hash (
        .data(password),
        .data_len(password_len),
        .hash(hashed_password)
    );
    
    // find the username length
    length_finder user_len (	
        .string(username),
        .length(username_len)
    );
    
    // check username valid with CAM lookup
    cam user_cam (
        .data(username),
        .data_len(username_len),
        .addr(user_addr),
        .valid(username_valid)
    );
    
    // get password hash from ROM based on CAM lookup
    hash_rom pass_rom (
        .addr(user_addr),
        .data(stored_hash)
    );
    
    assign valid = username_valid & (hashed_password == stored_hash);

endmodule