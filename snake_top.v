`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:52 05/07/2017 
// Design Name: 
// Module Name:    snake_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module snake_top(	input wire clk,
						input wire reset,
						input wire [2:0] speed,
						input wire wall,
						input wire btnu,
						input wire btnd,
						input wire btnl,
						input wire btnr,
						input wire btnp,
						output wire hsync, vsync,
						output wire [2:0] red, green,blue
    );
	 
	 
	wire [9:0] pixel_x;
	wire [9:0] pixel_y;
	wire video_on;
	wire pixel_tick;
	
	integer i;
	
	wire clk_in;
	wire btn_up;
	wire btn_down;
	wire btn_left;
	wire btn_right;
	wire btn_pause;
	reg B,R,G;
	 
	reg wall1, wall2, wall3, wall4;
	 
	 
reg move_clk;
reg d_up, d_down, d_left, d_right;
wire snakehead;
reg [24:0]snakesegment;
reg [15:0] score;
reg [10:0] foodx, foody; 
reg [15:0] foodxcount, foodycount;
reg [3:0] state,next_state;
reg [10:0] x, y, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9, 
x10, y10, x11, y11, x12, y12, x13, y13, x14, y14, x15, y15, x16, y16, x17, y17, x18, y18,
x19, y19, x20, y20, x21, y21, x22, y22, x23, y23, x24, y24, x25, y25;
reg lose; 

parameter S_STOP = 0; // 0000
parameter S_UP = 1; // 0001 
parameter S_DOWN = 2; // 0010 
parameter S_LEFT = 4; // 0100 
parameter S_RIGHT = 8; // 1000
	
	dclk divisor(
		.clk(clk),
		.reset(reset),
		 .SCLKclk(clk_in)
	);
				  
  	Debouncer btnU(
        .Clock(clk),
        .btn_in(btnu),
        .btn_out(btn_up)
    );
	 
	 Debouncer btnD(
        .Clock(clk),
        .btn_in(btnd),
        .btn_out(btn_down)
    );
	 Debouncer btnL(
        .Clock(clk),
        .btn_in(btnl),
        .btn_out(btn_left)
    );
	 Debouncer btnR(
        .Clock(clk),
        .btn_in(btnr),
        .btn_out(btn_right)
    );	 
	 Debouncer btnP(
        .Clock(clk),
        .btn_in(btnp),
        .btn_out(btn_pause)
    );
	  
	 
initial begin
	lose=1'b0;
	score=16'b0;
	foodx = 9'd400; 
	foody = 8'd400; 
	foodxcount = 9'd400;
	foodycount = 8'd400;	


	x = 11'd100; y = 11'd100;
	x1 = 11'd80; y1 = 11'd100;
	x2 = 11'd60; y2 = 11'd100;
	x3 = 11'd40; y3 = 11'd100;
	x4 = 11'd20; y4 = 11'd100;
	x5 = 11'd0; y5 = 11'd100;
	x6 = 11'd0; y6 = 11'd80;
	x7 = 11'd0; y7 = 11'd60;
	x8 = 11'd0; y8 = 11'd40;
	x9 = 11'd0; y9 = 11'd20;
	x10 = 11'd0; y10 = 11'd0;
	x11 = 11'd20; y11 = 11'd0;
	x12 = 11'd40; y12 = 11'd0;
	x13 = 11'd60; y13 = 11'd0;
	x14 = 11'd80; y14 = 11'd0;
	x15 = 11'd100; y15 = 11'd0;
	x16 = 11'd120; y16 = 11'd0;
	x17 = 11'd140; y17 = 11'd0;
	x18 = 11'd160; y18 = 11'd0;
	x19 = 11'd180; y19 = 11'd0;
	x20 = 11'd200; y20 = 11'd0;
	x21 = 11'd220; y21 = 11'd0;
	x22 = 11'd240; y22 = 11'd0;
	x23 = 11'd260; y23 = 11'd0;
	x24 = 11'd280; y24 = 11'd0;
	x25 = 11'd300; y25 = 11'd0;

	d_up =0; d_down=0; d_left=0; d_right =0;
	end


	always @ (posedge clk)begin

	if (reset == 1'b1) begin 
		d_up =0; d_down=0; d_left=0; d_right =0;
		foodx = foodxcount;
		foody = foodycount;
		score = 1'b0;
		lose=1'b0;
		state = S_STOP;
	end

	
	else if (lose==1'b1)begin
		state = S_STOP;
	end

	else begin

	
		foodxcount = (foodxcount + 5'd20)%10'd600;
		foodycount = (foodycount + 5'd20)%9'd420;

		if (btn_up==1'b1 && d_down == 1'b0) begin
			d_up =1; d_down=0; d_left=0; d_right =0; 
				state ={d_right , d_left, d_down, d_up};
		end
		else if (btn_down==1'b1 && d_up== 1'b0) begin
			d_up =0; d_down=1; d_left=0; d_right =0;
				state ={d_right , d_left, d_down, d_up};
		end
		else if (btn_left==1'b1 && d_right==1'b0) begin
			d_up =0; d_down=0; d_left=1; d_right =0;
				state ={d_right , d_left, d_down, d_up};
		end
		else if (btn_right==1'b1 && d_left==1'b0) begin
			d_up =0; d_down=0; d_left=0; d_right =1;
				state = {d_right , d_left, d_down, d_up};
		end
			else if(btn_pause)begin
				d_up =0; d_down=0; d_left=0; d_right =0;
				state = S_STOP;
			end
			else state=state;
	end

	if (score > 1'b0)
		snakesegment[0] = video_on & (pixel_x >=x1+1 & pixel_x <= x1 + 19 &pixel_y >= y1+1 & pixel_y <= y1+19);
	if (score > 1'b1)
		snakesegment[1] = video_on & (pixel_x >=x2+1 & pixel_x <= x2 + 19 &pixel_y >= y2+1 & pixel_y <= y2+19);
	if (score > 2'b10)
		snakesegment[2] = video_on & (pixel_x >=x3+1 & pixel_x <= x3 + 19 &pixel_y >= y3+1 & pixel_y <= y3+19);
	if (score > 2'b11)
		snakesegment[3] = video_on & (pixel_x >=x4+1 & pixel_x <= x4 + 19 &pixel_y >= y4+1 & pixel_y <= y4+19);
	if (score > 3'b100)
		snakesegment[4] = video_on & (pixel_x >=x5+1 & pixel_x <= x5 + 19 &pixel_y >= y5+1 & pixel_y <= y5+19);
	if (score > 3'b101)
		snakesegment[5] = video_on & (pixel_x >=x6+1 & pixel_x <= x6 + 19 &pixel_y >= y6+1 & pixel_y <= y6+19);
	if (score > 3'b110)
		snakesegment[6] = video_on & (pixel_x >=x7+1 & pixel_x <= x7 + 19 &pixel_y >= y7+1 & pixel_y <= y7+19);
	if (score > 3'b111)
		snakesegment[7] = video_on & (pixel_x >=x8+1 & pixel_x <= x8 + 19 &pixel_y >= y8+1 & pixel_y <= y8+19);
	if (score > 4'b1000)
		snakesegment[8] = video_on & (pixel_x >=x9+1 & pixel_x <= x9 + 19 &pixel_y >= y9+1 & pixel_y <= y9+19);
	if (score > 4'b1001)
		snakesegment[9] = video_on & (pixel_x >=x10+1 & pixel_x <= x10 + 19 &pixel_y >= y10+1 & pixel_y <= y10+19);
	if (score > 4'b1010)
		snakesegment[10] = video_on & (pixel_x >=x11+1 & pixel_x <= x11 + 19 &pixel_y >= y11+1 & pixel_y <= y11+19);
	if (score > 4'b1011)
		snakesegment[11] = video_on & (pixel_x >=x12+1 & pixel_x <= x12 + 19 &pixel_y >= y12+1 & pixel_y <= y12+19);
	if (score > 4'b1100)
		snakesegment[12] = video_on & (pixel_x >=x13+1 & pixel_x <= x13 + 19 &pixel_y >= y13+1 & pixel_y <= y13+19);
	if (score > 4'b1101)
		snakesegment[13] = video_on & (pixel_x >=x14+1 & pixel_x <= x14 + 19 &pixel_y >= y14+1 & pixel_y <= y14+19);
	if (score > 4'b1110)
		snakesegment[14] = video_on & (pixel_x >=x15+1 & pixel_x <= x15 + 19 &pixel_y >= y15+1 & pixel_y <= y15+19);
	if (score > 4'b1111)
		snakesegment[15] = video_on & (pixel_x >=x16+1 & pixel_x <= x16 + 19 &pixel_y >= y16+1 & pixel_y <= y16+19);
	if (score > 5'b10000)
		snakesegment[16] = video_on & (pixel_x >=x17+1 & pixel_x <= x17 + 19 &pixel_y >= y17+1 & pixel_y <= y17+19);
	if (score > 5'b10001)
		snakesegment[17] = video_on & (pixel_x >=x18+1 & pixel_x <= x18 + 19 &pixel_y >= y18+1 & pixel_y <= y18+19);
	if (score > 5'b10010)
		snakesegment[18] = video_on & (pixel_x >=x19+1 & pixel_x <= x19 + 19 &pixel_y >= y19+1 & pixel_y <= y19+19);
	if (score > 5'b10011)
		snakesegment[19] = video_on & (pixel_x >=x20+1 & pixel_x <= x20 + 19 &pixel_y >= y20+1 & pixel_y <= y20+19);
	if (score > 5'b10100)
		snakesegment[20] = video_on & (pixel_x >=x21+1 & pixel_x <= x21 + 19 &pixel_y >= y21+1 & pixel_y <= y21+19);
	if (score > 5'b10101)
		snakesegment[21] = video_on & (pixel_x >=x22+1 & pixel_x <= x22 + 19 &pixel_y >= y22+1 & pixel_y <= y22+19);
	if (score > 5'b10110)
		snakesegment[22] = video_on & (pixel_x >=x23+1 & pixel_x <= x23 + 19 &pixel_y >= y23+1 & pixel_y <= y23+19);
	if (score > 5'b10111)
		snakesegment[23] = video_on & (pixel_x >=x24+1 & pixel_x <= x24 + 19 &pixel_y >= y24+1 & pixel_y <= y24+19);
	if (score > 5'b11000)
		snakesegment[24] = video_on & (pixel_x >=x25+1 & pixel_x <= x25 + 19 &pixel_y >= y25+1 & pixel_y <= y25+19);
		
		
		
		if ((food && wall1) || (food && wall2) || (food && wall3) || (food && wall4))begin
			foodx = foodxcount;
			foody = foodycount;
		end 

		if ((snakehead && snakesegment[2]) || (snakehead && snakesegment[3]) || (snakehead && snakesegment[4]) ||
				(snakehead && snakesegment[5]) || (snakehead && snakesegment[6]) || (snakehead && snakesegment[7]) || 
				(snakehead && snakesegment[8]) || (snakehead && snakesegment[9]) || (snakehead && snakesegment[10]) ||
				(snakehead && snakesegment[11]) || (snakehead && snakesegment[12]) || (snakehead && snakesegment[13]) ||
				(snakehead && snakesegment[14]) || (snakehead && snakesegment[15]) || (snakehead && snakesegment[16]) || 
				(snakehead && snakesegment[17]) || (snakehead && snakesegment[18]) || (snakehead && snakesegment[19]) || 
				(snakehead && snakesegment[20]) || (snakehead && snakesegment[21]) || (snakehead && snakesegment[22]) || 
				(snakehead && snakesegment[23]) || (snakehead && snakesegment[24]) || (snakehead && snakesegment[0])||
				(snakehead && wall1) || (snakehead && wall2) || (snakehead && wall3) || (snakehead && wall4))begin
			lose=1'b1;
		end 
		
		
			if (snakehead && food) begin
				score=score+1'd1;
				foodx = foodxcount;
				foody = foodycount;
			end
	////////////////////////////////////////////////////////////////////////////////////////////////////////
   ////// CAMBIAR COLORES
   ////////////////////////////////////////////////////////////////////////////////////////////////////////	
	if (lose==1'b1)begin
		R=1'd1;
		G=0;
		B=0;
	end
	else begin
		if (food) begin	
				G = 1'b1;
				end
		else begin
				G = 0;
				end
			if (wall1 || wall2|| wall3|| wall4 ||snakehead ||snakesegment[0]|| snakesegment[1]|| snakesegment[2]||
			snakesegment[3]|| snakesegment[4]|| snakesegment[5]||
			snakesegment[6]|| snakesegment[7]|| snakesegment[8]|| snakesegment[9]|| snakesegment[10]|| 
			snakesegment[11]|| snakesegment[12]|| snakesegment[13]||snakesegment[14]||
			snakesegment[15]||snakesegment[16]||snakesegment[17]||snakesegment[18]||snakesegment[19]||
			snakesegment[20]|| snakesegment[21]||snakesegment[22]||snakesegment[23]||snakesegment[24]) begin
				R = 1'b1;
			end
			else begin
				R = 0;
			end
			
				B=0;
		end
	end 
	
////////////////////////////////////////////////////////////

reg [25:0] move_cont;

always @ (posedge clk) begin
move_cont = move_cont + 1'b1;
	case(speed)
			3'b001:move_clk = move_cont[23];
			3'b010:move_clk = move_cont[22];
			3'b100:move_clk = move_cont[21];	
			default:move_clk = move_cont[24];
	endcase
end


always @ (posedge clk) begin
	if (wall==1'b1)begin
		wall1= video_on & (pixel_x >= 1 & pixel_x <= 639 & pixel_y >= 1 & pixel_y <= 19);
		wall2= video_on & (pixel_x >= 1 & pixel_x <= 639 & pixel_y >= 461 & pixel_y <= 479);
		wall3= video_on & (pixel_x >= 1 & pixel_x <= 19 & pixel_y >= 1 & pixel_y <= 479);
		wall4= video_on & (pixel_x >= 621 & pixel_x <= 639 & pixel_y >= 1 & pixel_y <= 479);
	end 
end
	
////////////////////////////////////////////////////////////	
	

always @(posedge move_clk) begin

	if (reset == 1'b1) begin 
		x25 = 300; y25 = 0; x24 = 280; y24 = 0; x23 = 260; y23 = 0; x22 = 240; y22 = 0; x21 = 220;
		y21 = 0; x20 = 200; y20 = 0; x19 = 180; y19 = 0; x18 = 160; y18 = 0; x17 = 140; y17 = 0; 
		x16 = 120; y16 = 0; x15 = 100; y15 = 0; x14 = 80; y14 = 0; x13 = 60; y13 = 0; x12 = 40;
		y12 = 0; x11 = 20; y11 = 0; x10 = 0; y10 = 0; x9 = 0; y9 = 20; x8 = 0; y8 = 40; x7 = 0;
		y7 = 60; x6 = 00; y6 = 80; x5 = 00; y5 = 100; x4 = 20; y4 = 100; x3 = 40; y3 = 100; x2 = 60;
		y2 = 100; x1 = 80; y1 = 100; x = 100; y = 100;
	end

	case (x)  
		10'd640:begin x = 5'd00000; 
		end
		-10'd20:begin x = 10'd640; 
		end
	endcase

	case (y) 
		10'd460: begin y= 5'd0; 
		end
		-10'd20: begin y=10'd460; 
		end
	endcase

	case (state) 
		S_STOP: begin 
		end 
		S_UP: begin

		x25 = x24; y25 = y24; x24 = x23; y24 = y23; x23 = x22; y23 = y22; x22 = x21; y22 = y21; x21 = x20; 
		y21 = y20; x20 = x19; y20 = y19; x19 = x18; y19 = y18; x18 = x17; y18 = y17; x17 = x16; y17 = y16;
		x16 = x15; y16 = y15; x15 = x14; y15 = y14; x14 = x13; y14 = y13; x13 = x12; y13 = y12; x12 = x11;
		y12 = y11; x11 = x10; y11 = y10; x10 = x9; y10 = y9; x9 = x8; y9 = y8; x8 = x7; y8 = y7; x7 = x6; 
		y7 = y6; x6 = x5; y6 = y5; x5 = x4; y5 = y4; x4 = x3; y4 = y3; x3 = x2; y3 = y2; x2 = x1; y2 = y1; 
		x1 = x; y1 = y;
		y = y - 11'd20;
		end
		S_DOWN: begin
	
		x25 = x24; y25 = y24; x24 = x23; y24 = y23; x23 = x22; y23 = y22; x22 = x21; y22 = y21; x21 = x20; 
		y21 = y20; x20 = x19; y20 = y19; x19 = x18; y19 = y18; x18 = x17; y18 = y17; x17 = x16; y17 = y16;
		x16 = x15; y16 = y15; x15 = x14; y15 = y14; x14 = x13; y14 = y13; x13 = x12; y13 = y12; x12 = x11;
		y12 = y11; x11 = x10; y11 = y10; x10 = x9; y10 = y9; x9 = x8; y9 = y8; x8 = x7; y8 = y7; x7 = x6; 
		y7 = y6; x6 = x5; y6 = y5; x5 = x4; y5 = y4; x4 = x3; y4 = y3; x3 = x2; y3 = y2; x2 = x1; y2 = y1; 
		x1 = x; y1 = y;
		y = y + 11'd20;
		end
		S_LEFT: begin
		x25 = x24; y25 = y24; x24 = x23; y24 = y23; x23 = x22; y23 = y22; x22 = x21; y22 = y21; x21 = x20; 
		y21 = y20; x20 = x19; y20 = y19; x19 = x18; y19 = y18; x18 = x17; y18 = y17; x17 = x16; y17 = y16;
		x16 = x15; y16 = y15; x15 = x14; y15 = y14; x14 = x13; y14 = y13; x13 = x12; y13 = y12; x12 = x11;
		y12 = y11; x11 = x10; y11 = y10; x10 = x9; y10 = y9; x9 = x8; y9 = y8; x8 = x7; y8 = y7; x7 = x6; 
		y7 = y6; x6 = x5; y6 = y5; x5 = x4; y5 = y4; x4 = x3; y4 = y3; x3 = x2; y3 = y2; x2 = x1; y2 = y1; 
		x1 = x; y1 = y;
		x = x - 11'd20; 
		end
		S_RIGHT: begin
		x25 = x24; y25 = y24; x24 = x23; y24 = y23; x23 = x22; y23 = y22; x22 = x21; y22 = y21; x21 = x20; 
		y21 = y20; x20 = x19; y20 = y19; x19 = x18; y19 = y18; x18 = x17; y18 = y17; x17 = x16; y17 = y16;
		x16 = x15; y16 = y15; x15 = x14; y15 = y14; x14 = x13; y14 = y13; x13 = x12; y13 = y12; x12 = x11;
		y12 = y11; x11 = x10; y11 = y10; x10 = x9; y10 = y9; x9 = x8; y9 = y8; x8 = x7; y8 = y7; x7 = x6; 
		y7 = y6; x6 = x5; y6 = y5; x5 = x4; y5 = y4; x4 = x3; y4 = y3; x3 = x2; y3 = y2; x2 = x1; y2 = y1; 
		x1 = x; y1 = y;
		x = x + 11'd20; 
		end
		endcase

		
end
	 

	 
  vga_sync vsync_unit
     (.clk_in(clk_in), .reset(reset), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
		 
		 
		 
		
	assign snakehead = video_on & (pixel_x >= x & pixel_x <= x+20 & pixel_y >= y & pixel_y <= y+20);
	assign food= video_on & (pixel_x >=foodx + 5 & pixel_x <= foodx + 15 &pixel_y >= foody + 5 & pixel_y <= foody + 15);		 


   
   assign red = (video_on && R == 1'b1) ? 3'b111 : 3'b000;
	assign green = (video_on && G == 1'b1) ? 3'b111 : 3'b000;
	assign blue = (video_on && B == 1'b1) ? 3'b111 : 3'b00;



endmodule
