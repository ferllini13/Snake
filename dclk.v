`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:17:12 04/26/2017 
// Design Name: 
// Module Name:    dclk 
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
module dclk(
			clk,
		   reset,
			SCLKclk

    );
	 
	 input wire clk, reset;
	   output reg SCLKclk;
	   
	   
       reg cuenta_sclk;  
       always @(posedge clk)   
	   begin
	      if(reset)
		  begin
		  cuenta_sclk<=1'd0;   
		  SCLKclk <=1'd0;  
		  end
	   else
		  begin	
			if(cuenta_sclk == 1'd0)
						     		 
				begin 
				cuenta_sclk<= 2'd00;  
				SCLKclk <= ~SCLKclk;
				end
	 		else
				cuenta_sclk <= cuenta_sclk + 1'b1;
		  end
end


endmodule
