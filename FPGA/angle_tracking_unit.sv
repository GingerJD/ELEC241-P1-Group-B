/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Design unit	: atu
// 				:
// File name	: angle_tracking_unit.sv
//					:
// Description	: A unit used to track the angle of the motor shaft by monitoring 2-wire hall-effect inputs
//					: DIRECTION = 1 	- CLOCKWISE
//					: DIRECTION = 0 	- ANTICLOCKWISE
//					: PM = 1				- PULSE MONITORING ON
//					: PM = 0 			- PULSE MONITORING OFF
//					: Q					- Output angle
//					: angle = decimal value of Q * (360/1006)
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
// Revision		: Version 1.7 12/05/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////
module atu(output logic  [11:0] Q, 
input logic RESET, PM,DIRECTION,OPTOA,OPTOB);


/////////////////////////////////////////////////////////////////////////////////////////////////////////
//NEEDS WORK
//DEBOUNCE OPTOA//
//always @(posedge OPTOA)begin
	//GET current_time_a
	//if((current_time_a - prev_time_a)>bounce_delay)begin
	//	A = OPTOA;
	//	prev_time_a = current_time_a;
	//CHANGE ALL OPTOA TO A
//end
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//NEEDS WORK
//DEBOUNCE OPTOB
//always @(posedge OPTOB)begin
	//GET current_time_b
	//if((current_time_b - prev_time_b)>bounce_delay)begin
	//	B = OPTBA;
	//	prev_time_b = current_time_b;
	//CHANGE ALL OPTOB TO B
//end

always_latch begin
	//RESET FUCNTION
	if(RESET == 1) //Pulse monitoring will stop when RESET is pulled high only start when RESET is pulled low
		Q = 0;
	//PULSE MONITORING TOGGLE
	else if(PM == 1)begin
		//DIRECTION FUNCTION AND ANGLE TRACKING 
		if ((DIRECTION == 1'b1)&&(OPTOA == 1)&&(OPTOB == 0))begin //If direction is clockwise on pulse increase pulse count
				Q++;
				if (Q == 1006)		//Prevents angle being greater than 360
					Q = 0;			//If angle is 360 then set it to 0
			end
			else if ((DIRECTION == 0)&&(OPTOA == 0)&&(OPTOB == 1))begin //If direction is anticlockwise on pulse decrease pulse count
				Q--;
				if (Q == 4095)		//Prevents angle from being negative
					Q = 1005;		//loops angle back to 359.64
			end
	end
end


endmodule



