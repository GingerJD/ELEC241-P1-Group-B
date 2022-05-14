module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic clk,
   input logic busyF,
   input logic [11:0] angle);

//Internal Variables
reg [11:0] updateAngle;
reg [24:0] refreshCount = 0;
reg [11:0] degrees;

//BCD CONVERSION
reg [11:0] BCD;
//ASCII CONVERSION
reg [23:0] asciiConversion;

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
	if(busyF == 0)begin
		//clear LCD
		rs = 0;
		rw = 0;
		data = 8'b0000001;
		e = 1;
		wait(refreshCount == 2500)
			e = 0;//wait 50us to toggle e
		wait(refreshCount == 102500); // wait 2ms
	end
	//Write to lcd
	rs = 0;
	rw = 0;
	if(busyF == 0)begin
		rs = 1;
		rw = 0;
		data = asciiConversion [23:16];
		e = 1;
		wait(refreshCount == 105000)
			e = 0;//wait 50us to toggle e
		wait(refreshCount == 107500); //wait 50us
	end
	rs = 0;
	rw = 0;
	if(busyF == 0)begin
		rs = 1;
		rw = 0;
		data = asciiConversion [15:8];
		e = 1;
		wait(refreshCount == 110000)
			e = 0;//wait 50us to toggle e
		wait(refreshCount == 112500); //wait 50us
	end
	rs = 0;
	rw = 0;
	if(busyF == 0)begin
		rs = 1;
		rw = 0;
		data = asciiConversion [7:0];
		e = 1;
		wait(refreshCount == 115000)
			e = 0;//wait 50us to toggle e
		wait(refreshCount == 117500); //wait 50us
	end
end



always_comb begin
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
	asciiConversion [23:16] = BCD [11:8] + 48;
	asciiConversion [15:8] = BCD [7:4] + 48;
	asciiConversion [7:0] = BCD [3:0] + 48;
	
end   
endmodule
   
