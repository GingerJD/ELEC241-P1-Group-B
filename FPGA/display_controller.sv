module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic [7:0] ascii_data,
   input logic write,
   input logic clk,
   input logic [11:0] angle);

//Internal Variables
reg [11:0] updateAngle;
reg [24:0] refreshCount;
reg [11:0] degrees;
//BCD CONVERSION
reg [11:0] BCD;
//ASCII CONVERSION
reg [24:0] asciiConversion;

always @(posedge clk)begin
	refreshCount++;
	if (refreshCount == 16666667)begin	//Read angle at 60Hz
		updateAngle = angle;
		refreshCount = 0;
	end
end

always_latch begin
////////////////////////////////////////////////////////////////////////////////
//CONVERT ANGLES TO DEGREES
degrees = (updateAngle * 360)/1006;
if(((updateAngle * 360)-(degrees*1006))>503)	//Round to nearest degree
		degrees = degrees +1;

////////////////////////////////////////////////////////////////////////////////
//CONVERT DEGREES TO BCD
BCD [11:8] = degrees / 100;
BCD [7:4] = (degrees-(BCD [11:8] * 100))/10;
BCD [3:0] = (degrees-(BCD [11:8] * 100)-(BCD [7:4]*10));

////////////////////////////////////////////////////////////////////////////////
//CONVERT BCD TO ASCII
asciiConversion [24:17] = BCD [11:8] + 48;
asciiConversion [16:8] = BCD [7:4] + 48;
asciiConversion [7:0] = BCD [3:0] + 48;

////////////////////////////////////////////////////////////////////////////////
//DISLAY ASCII ON LCD


end

   
endmodule
   
