module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic [7:0] ascii_data,
   input logic write,
   input logic clk,
   input logic busyF,
   input logic [11:0] angle);

//Internal Variables
reg [11:0] updateAngle;
reg [21:0] refreshCount;
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



always @(updateAngle)begin
	//DISLAY ASCII ON LCD
	//Read busy flag
	rs = 0;
	rw = 1;
	@(negedge busyF)begin
		//clear LCD
		e = 0;
		rs = 0;
		rw = 0;
		data = 7'b0000001;
		e = 1;
	end
	rs = 0;
	rw = 1;
	@(negedge busyF)begin
		//write hundreds
		e = 0;
		rs = 1;
		rw = 0;
		data = asciiConversion [20:14];
		e = 1;
	end
	rs = 0;
	rw = 1;
	@(negedge busyF)begin
		//write tens
		e = 0;
		rs = 1;
		rw = 0;
		data = asciiConversion [13:7];
		e = 1;
	end
	rs = 0;
	rw = 1;
	@(negedge busyF)begin
		//write ones
		e = 0;
		rs = 1;
		rw = 0;
		data = asciiConversion [6:0];
		e = 1;
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
	asciiConversion [20:14] = BCD [11:8] + 48;
	asciiConversion [13:7] = BCD [7:4] + 48;
	asciiConversion [6:0] = BCD [3:0] + 48;
	
end   
endmodule
   
