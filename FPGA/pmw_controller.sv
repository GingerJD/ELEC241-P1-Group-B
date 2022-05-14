//////////////////////////////////////////////////////////////////
// Design unit	: pwmc
// 		:
// File name	: pwm_controller.sv
//		:
// Description	: 
//
//		:
// Limitations	: None
// 		:
// Author	: James Davis
//		: School of Engineering, Computing & Mathematics
//		: University of Plymouth
//		: Drake Circus, Plymouth PL4 8AA
//		: james.davis-11@students.plymouth.ac.uk
//		:
// Revision	: Version 1.3 09/03/22
//////////////////////////////////////////////////////////////////

module pwmc(output logic motor_1, motor_2,
 input logic clk_50, direction, pwmOutEnable, brake,
 input logic [7:0] dutyCycle,
 input logic [7:0] period);

//internal variables
int counter;
int updateWait = 0;
logic [7:0] dutyCycleUpdate;
logic [7:0] periodUpdate;


//COUNTER TO DETERMINE WHEN PULSE SHOULD BE HIGH
always @(posedge clk_50)begin
	if (updateWait == 1)
		counter = 0;
	if ((counter < periodUpdate-1)&&(pwmOutEnable == 1))
		counter = counter +1;
	else
		counter = 0;
	if(counter == 0)begin	//Wait for period to end before updating duty cycle and period
		dutyCycleUpdate = dutyCycle;
		periodUpdate = period;
	end
end

//IF PERIOD OR DUTY CYCLE UPDATED RESTART COUNTER
always @(periodUpdate, dutyCycleUpdate)begin
		updateWait = 1;	//if Period or duty cycle are updated wait until next posedge of clock to begin pwm
		@(posedge clk_50)begin
			updateWait = 0;
		end
end

//ASSIGN IF MOTORS ARE HIGH OR LOW
always_latch begin
	//BRAKE FUNCTION
	if((brake == 1)&&(pwmOutEnable == 1))begin
		motor_1 = 1;
		motor_2 = 1;
	end
	else if((brake == 0)&&(pwmOutEnable == 1))begin
		if (updateWait == 1)begin
			motor_1 = 0;
			motor_2 = 0;
		end
	
		else if((pwmOutEnable == 1)&&(brake != 1))begin
			//motor direction = clockwise
			if (direction == 1)begin
				motor_2 = (counter < dutyCycleUpdate) ? 1:0;
				motor_1 = 0;
			end
			//motor direction = anticlockwise
			else if (direction == 0)begin
				motor_2 = 0;
				motor_1 = (counter < dutyCycleUpdate) ? 1:0;
			end
		end
		//Pulls motors low when pwm outputs are disabled
		else if (pwmOutEnable == 0)begin
			motor_1 = 0;
			motor_2 = 0;
		end
	end
	else begin
		motor_1 = 0;
		motor_2 = 0;
	end
end
endmodule
