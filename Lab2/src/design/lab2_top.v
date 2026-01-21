//=============================================================================
// EE108 Lab 2
//
// Top level module. Integrates the various system components.
//=============================================================================

module lab2_top (	 
    // System Clock (125MHz)
    input sysclk,

    // HDMI outputs
    output TMDS_Clk_n,
    output TMDS_Clk_p,
    output [2:0] TMDS_Data_n,
    output [2:0] TMDS_Data_p,

    // User inputs
    // TODO: fix switches
    input [7:0] sw,
    input [2:0] btn,

    // LEDs to show life
    output [3:0] leds
);
//    wire [7:0] sw; // TODO
//    assign sw = 8'b10101010;
  
  
    wire reset, ain_btn, bin_btn;
    assign {reset, ain_btn, bin_btn} = btn;
  
    // Clock converter
    wire clk_100, display_clk, serial_clk;
    wire LED0;      // TODO: assign this to a real LED
 
    clk_wiz_0 U2 (
        .clk_out1(clk_100),     // 100 MHz
        .clk_out2(display_clk),	// 30 MHz
        .clk_out3(serial_clk),	// 150 Mhz
        .reset(reset),
        .locked(LED0),
        .clk_in1(sysclk)
    );
  
    //==========================================================================
    // The floating point addder itself
    //==========================================================================
    wire [7:0] aIn, bIn, result;
    wire [7:0] result_q;
 
    // Instantiate the floating point adder module
    float_add fpa(
        .aIn(aIn),
        .bIn(bIn),
        .result(result)
    );
 
    // Register the outputs so we break up the long critical path through the
    // VGA.  Since this is used by humans we don't care if we delay the result
    // by 10ns.
    dff #(.WIDTH(8)) result_reg (
        .clk (clk_100), 
        .d (result), 
        .q (result_q)
    );

    //=============================================================================
    // Input controls
    //============================================================================= 
    // Storage for the values.
    dffre #(.WIDTH(8)) ain_reg (
        .clk (clk_100),
        .r   (reset),
        .en  (ain_btn),
        .d   (sw),
        .q   (aIn)
    );
    dffre #(.WIDTH(8)) bin_reg (
        .clk (clk_100),
        .r   (reset),
        .en  (bin_btn),
        .d   (sw),
        .q   (bIn)
    );

    //==========================================================================
    // Display management -> do not touch!
    //==========================================================================
    /* blinking leds to show life */
    wire [26:0] led_counter;

    dff #(.WIDTH (27)) led_div (
        .clk (clk_100),
        .d (led_counter + 27'd1),
        .q (led_counter)
    );
    assign leds = led_counter[26:23];

    // These signals come from and go to the modules for generating the 
    // VGA timing (sync) signals
    wire [10:0] x;  // [0..1279]
    wire [10:0] y;  // [0..1023]     
    wire [10:0] x_q;
    wire [10:0] y_q;	 
	 
    // Composite RGB signal
    wire [5:0] vga_rgb;
    wire [5:0] rgb_q;
         
    // VGA Colors
    wire [3:0] r = {2{rgb_q [5:4]}};
    wire [3:0] g = {2{rgb_q [3:2]}};
    wire [3:0] b = {2{rgb_q [1:0]}};

    wire [31:0] pix_data = {
        8'b0,
        r[3], r[3], r[2], r[2], r[1], r[1], r[0], r[0],
        g[3], g[3], g[2], g[2], g[1], g[1], g[0], g[0],
        b[3], b[3], b[2], b[2], b[1], b[1], b[0], b[0]
    };
    
    
    
    wire vde, hsync, vsync;
    hdmi_tx_0 U3 (
        .pix_clk(display_clk),
        .pix_clkx5(serial_clk),
        .pix_clk_locked(LED0),
        .rst(reset),
        .pix_data(pix_data),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        .TMDS_CLK_P(TMDS_Clk_p),
        .TMDS_CLK_N(TMDS_Clk_n),
        .TMDS_DATA_P(TMDS_Data_p),
        .TMDS_DATA_N(TMDS_Data_n)
    );
    
    
    wire blank;
    vga_controller_800x480_60 vga_control (
        .pixel_clk(display_clk),
        .rst(reset),
        .HS(hsync),
        .VS(vsync),
        .VDE(vde),
        .hcount(x),
        .vcount(y),
        .blank(blank)
    );
	

  // HDMI Controller 
  // TODO  
    
    
  
	 /*zedboard_hdmi hdmi (
			 .clk_100 (clk_100),
			 .hdmi_clk (hdmi_clock), 
			 .hdmi_hsync (hdmi_hsync),
	       .hdmi_vsync (hdmi_vsync), 
	       .hdmi_d (hdmi_d), 
	       .hdmi_de (hdmi_de),  
	       .hdmi_int (hdmi_int), 
	       .hdmi_scl (hdmi_scl), 
          .hdmi_sda (hdmi_sda),
			 .xpos (x),
			 .ypos (y),
			 .ycbcr (converted) 
    );	*/		 
    
	dff #(.WIDTH (11)) x_dff (
        .clk (clk_100),
        .d (x),
        .q (x_q)
    );
 
	dff #(.WIDTH (11)) y_dff (
        .clk (clk_100),
        .d (y),
        .q (y_q)
    );
	
    
    // Display Driver
    fpa_vga_driver fpa_vga (
        .clk     (clk_100),
        .XPos    (x_q),
        .YPos    (y_q),

        .aIn     (aIn),
        .bIn     (bIn),
        .result  (result_q),

        //.Valid   (vde),
        .Valid   (1'b1),

        .vga_rgb (vga_rgb)
    );
 
    dff #(.WIDTH (6)) rgb_dff (
        .clk (clk_100),
        .d (vga_rgb),
        .q (rgb_q)
    );


endmodule





//wire [20:0] yeblah;
//    wire [20:0] cbblah; 
//	wire [20:0] crblah; 
	 
//	wire [20:0] yeblah_q;
//	wire [20:0] cbblah_q; 
//	wire [20:0] crblah_q; 
	 
//    assign yeblah = 63*b + 629*g + 187*r + 16384; //multiply by 1024 
//    assign cbblah = 450*b - 347*g - 103*r + 131072;	 
//	assign crblah = -41*b -409*g +450*r + 131072; 
	 
//	dff #(.WIDTH (21)) ye_dff (
//        .clk (clk_100),
//        .d (yeblah),
//        .q (yeblah_q)	 
//    );
		  
//    dff #(.WIDTH (21)) cb_dff (
//        .clk (clk_100),
//        .d (cbblah),
//        .q (cbblah_q)
//    );
		  
//	 dff #(.WIDTH (21)) cr_dff (
//        .clk (clk_100),
//        .d (crblah),
//        .q (crblah_q)
//	 );

//	 reg [7:0] ye;
//	 reg [7:0] cb; 
//	 reg [7:0] cr; 
	 
//	 always @ (posedge clk_100) begin  
//		  ye [7:0] = (yeblah_q[20]) ? 0 : ( (yeblah_q >= 20'hFFFFF)? 10'h3FF: yeblah_q[19:10] );
//		  cb [7:0] = (cbblah_q[20]) ? 0 : ( (cbblah_q >= 20'hFFFFF)? 10'h3FF: cbblah_q[19:10] );
//		  cr [7:0] = (crblah_q[20]) ? 0 : ( (cbblah_q >= 20'hFFFFF)? 10'h3FF: crblah_q[19:10] );
//		  converted = {ye,cb,cr};
//	 end 
	
//	 reg [23:0] converted;
