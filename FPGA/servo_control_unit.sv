/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Design unit	: scu
// 				:
// File name	: servo_control_unit.sv
//					:
// Description	: A unit used to communicate with the ATU and PWMC in real time
//					: 
//					:
// Limitations	: None
// 				:
// Author		: James Davis
//					: School of Engineering, Computing & Mathematics
//					: University of Plymouth
//					: Drake Circus, Plymouth PL4 8AA
//					: james.davis-11@students.plymouth.ac.uk
//					:
// Revision	: Version 1.6 15/04/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////



module scu(
output logic Direction, brake,resetOut,
output logic [7:0] pwmDT,
output logic [7:0] pwmPeriod,
output logic [31:0] statusR, 
input logic [31:0] inputR,
input logic [11:0] atuAngle);

//Internal Variables
reg [11:0] desiredAngle;
reg [1:0] controlMode;
reg [1:0] command;
int pwmPower;

//Direction Selector Variables
reg [11:0] clockDiff;
reg [11:0] antiClockDiff;

//Proportional Controller Variables
reg [11:0] error;
reg [11:0] dutyCyclePercentage;

//INPUT REGISTER
always_comb begin
	desiredAngle[11:0] = inputR [11:0];
	pwmPeriod[7:0] = inputR [19:12];
	controlMode[1:0] = inputR [28:27];
	command[1:0] = inputR[30:29];
	pwmPower = inputR[31];
end

//STATUS REGISTER
always_comb begin
	statusR [11:0] = atuAngle;
	statusR [31:12] = 0;
end

always_latch begin
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	//decode angle from atu
//	decodedCurrentAngle = 0;
//	decodedDesiredAngle = 0;
//	for (real idx = 256, n = 11; idx >= 0.125; n=n-1, idx = idx/2)begin
//		decodedCurrentAngle = decodedCurrentAngle + (idx*atuAngle[n]);
//		decodedDesiredAngle = decodedDesiredAngle + (idx*desiredAngle[n]);
//	end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if(command == 1)
		resetOut = 1;
	else if((command == 2)||(command == 3))//No command Defaults to brake
		brake = 1;
	else if(command ==0)begin
		//Clear previous commands
		resetOut = 0;
		brake = 0;
		//Direction Selector
		if(desiredAngle < atuAngle)begin
			clockDiff = 1006 - atuAngle + desiredAngle;
			antiClockDiff = atuAngle - desiredAngle;
		end
		else if(desiredAngle > atuAngle)begin
			clockDiff = desiredAngle - atuAngle;
			antiClockDiff = atuAngle + 1006 - desiredAngle;
		end
		
		if (clockDiff <= antiClockDiff)begin
			Direction = 1;
			error = clockDiff;
		end
		else if(antiClockDiff < clockDiff)begin
			Direction = 0;
			error = antiClockDiff;
		end
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Bang bang control
		if (controlMode == 0)begin
			if (desiredAngle != atuAngle)begin		//MOTOR ON WHEN ANGLE IS NOT CORRECT
				pwmDT = pwmPeriod;
			end
			else if (desiredAngle == atuAngle)begin	//MOTOR OFF WHEN ANGLE IS CORRECT
				pwmDT = 8'b00000000;
			end
		end
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//proportional control
		if (controlMode == 1)begin
		dutyCyclePercentage = 1006/error;
		pwmDT = pwmPeriod / dutyCyclePercentage;//rounded to nearest 20ns for clock_50
		end
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end
end
endmodule 