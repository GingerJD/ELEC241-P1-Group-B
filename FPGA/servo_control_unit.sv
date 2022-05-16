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
reg [11:0] clockDiff;		//Difference between desired angle and current angle in clockwise direction
reg [11:0] antiClockDiff;	//Difference between desired angle and current angle in anticlockwise direction
reg [11:0] angleDiff;		//Signed difference between desired angle and current angle

//Proportional Controller Variables
reg [11:0] error;		//Difference between current angle and desired angle
reg [11:0] dutyCyclePercentage;	//Duty cycle % of period

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
	//COMMANDS
	//RESET COMMAND
	if(command == 1)			
		resetOut = 1;
	//BRAKE COMMAND AND NO COMMAND
	else if((command == 2)||(command == 3))//No command Defaults to brake
		brake = 1;
	//CONTINUOUS COMMAND
	else if(command ==0)begin
		//Clear previous commands
		resetOut = 0;
		brake = 0;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//DIRECTION SELECTOR
		//calculates difference between current angle and desired angle for both clockwise and anticlockwise directions
		angleDiff = desiredAngle - atuAngle;
		if(angleDiff[11] == 0)begin
			clockDiff = angleDiff;
			antiClockDiff = 1006-angleDiff;
		end
		else if(angleDiff[11] == 1)begin
			antiClockDiff = -angleDiff;
			clockDiff = 1006+angleDiff;
		end
		//sets direction accordingly
		if(clockDiff<=antiClockDiff)begin
			Direction = 1;
			error = clockDiff;	//error is set for proportional control mode
		end
		else if(antiClockDiff < clockDiff)begin
			Direction =0;
			error = antiClockDiff;	//error is set for proportional control mode
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//BANG BANG CONTROL
		if (controlMode == 0)begin
			if(desiredAngle == atuAngle)begin //MOTOR OFF WHEN ANGLE IS CORRECT TO 1 DEGREE ACURACY
				pwmDT = 8'b00000000;
			end
			else if (desiredAngle != atuAngle)begin	//MOTOR ON WHEN ANGLE IS NOT CORRECT
				pwmDT = pwmPeriod;
			end
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//PROPORTIONAL CONTROL
		if (controlMode == 1)begin
			if (atuAngle == desiredAngle)						//Stop motor when motor angle is correct
				pwmDT = 0;
			else begin
				dutyCyclePercentage = 1006/error;
				if((1006-(dutyCyclePercentage*error)) >= (error/2))		//Rounded division
					dutyCyclePercentage = dutyCyclePercentage+1;
	
				pwmDT = pwmPeriod/dutyCyclePercentage;				//pwmDT rounded to nearest 20ns
				if((pwmPeriod-(pwmDT*dutyCyclePercentage))>=(dutyCyclePercentage/2))
					pwmDT = pwmDT + 1;
				if(pwmDT == 0)	//stops the motor from stopping before it reaches the desired angle
					pwmDT = 8'b00000001;
			end
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end
end
endmodule 