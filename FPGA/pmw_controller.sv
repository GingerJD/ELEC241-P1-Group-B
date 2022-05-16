//////////////////////////////////////////////////////////////////
// Design unit	: pwmc
// 		:
// File name	: pwm_controller.sv
//		:
// Description	: This module is used to control the angle of a DC
//		: motor shaft, accurate to 1 degree
//		:
// Limitations	: None
// 		:
// Author	: James Davis
//		: School of Engineering, Computing & Mathematics
//		: University of Plymouth
//		: Drake Circus, Plymouth PL4 8AA
//		: james.davis-11@students.plymouth.ac.uk
//		:
// Revision	: Version 1.8 15/05/22
//////////////////////////////////////////////////////////////////

module pwmc(output logic motor_1, motor_2,
 input logic clk_50, direction, pwmOutEnable, brake,
 input logic [7:0] dutyCycle,
 input logic [7:0] period);

//internal variables
int counter;
logic [7:0] dutyCycleUpdate;	//Current duty cycle being used
logic [7:0] periodUpdate;	//Current period being used

always @(posedge clk_50)begin
	//BRAKE FUCNTION
	if(brake == 1)begin	//when brake is set high initiate brake
		motor_1 = 1;
		motor_2 = 1;
	end
	//PWM OUTPUT TOGGLE
	else if((pwmOutEnable == 0)&&(brake == 0)) begin	//when pulse width monitoring outputs are disabled pull outputs low
		motor_1 = 0;
		motor_2 = 0;
	end
	//COUNTER TO DETERMINE WHEN PULSE SHOULD BE HIGH
	else if ((pwmOutEnable == 1)&&(brake == 0))begin
		if ((counter < periodUpdate-1)&&(pwmOutEnable == 1))begin
			if((counter == 0)&&((motor_1 == 1)||(motor_2 == 1)))
				counter = counter +1;
			else if(counter != 0)
				counter = counter + 1;
		end
		else
			counter = 0;
	
		//MOTOR DIRECTION = CLOCKWISE
		if (direction == 1)begin
			motor_2 = (counter < dutyCycleUpdate) ? 1:0;	//Activate motor_2 for duration of duty cycle
			motor_1 = 0;
		end
		//MOTOR DIRECTION = ANTICLOCKWISE
		else if (direction == 0)begin
			motor_2 = 0;
			motor_1 = (counter < dutyCycleUpdate) ? 1:0;	//Activate motor_1 for duration of duty cycle
		end
	end
end


always_latch begin
	//WAIT FOR PERIOD TO END BEFORE UPDATE
	if(counter == 0)begin	//Wait for period to end before updating duty cycle and period
		dutyCycleUpdate = dutyCycle;
		periodUpdate = period;
	end
end
endmodule

