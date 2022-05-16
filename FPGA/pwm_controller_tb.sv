//////////////////////////////////////////////////////////////////
// Design unit	: pwm_controller_tb
// 		:
// File name	: pwm_controller_tb.sv
//		:
// Description	: Test bench for the PMWC to test the following:
//		: > TEST 1 - Test that pwm is correctly working
//		: > TEST 2 - Test that pwm is correctly working at 
//		:   different duty cycle and period after change
//		: > TEST 3 - Test that the pwm controller can run 
//		:   anti-clockwise
//		: > TEST 4 - Test to see reset functions correctly 
//		:   correctly, regardless of clock
//		: > TEST 5 - test that the pwm outputs can be 
//		:   toggled on and off
//		:
// Limitations	: None
// 		:
// Author	: James Davis
//		: School of Engineering, Computing & Mathematics
//		: University of Plymouth
//		: Drake Circus, Plymouth PL4 8AA
//		: james.davis-11@students.plymouth.ac.uk
//		:
// Revision	: Version 1.9 15/05/22
//////////////////////////////////////////////////////////////////

module pwm_controller_tb;

//Set initial variables for pwm_controller.sv
logic [7:0] period;
logic [7:0] dutyCycle;
logic brake, direction, clk_50, motor_1, motor_2, pwmOutEnable;

//Initialize pwm_controller.sv
pwmc u1(motor_1, motor_2, clk_50, direction,pwmOutEnable, brake, dutyCycle, period);

//Simulates clock input
initial
begin
	clk_50 = 1;		
	repeat(300) begin
		#100;	//for testing purposes using picoseconds instead of nanoseconds
		clk_50 = ~clk_50;
	end
end

initial
begin
/////////////////////////////////////////////////////////////////////////////////////////
	//SET INITIAL VARIABLE VALUES
	//set direction to clockwise 
	#50 direction = 1;
	
	//set brake to 0
	brake = 0;

	//enable pmw outputs
	pwmOutEnable = 1;
/////////////////////////////////////////////////////////////////////////////////////////
	//TEST 1 - test that pwm is correctly working
	//Period = 160ns / Duty cycle = 100ns
	period = 8'b00001000;
	dutyCycle = 8'b00000101;
	//As direction is clockwise only motor 2 should be active
	$display("----------------------------------------------------------------------------------");
	$display("TEST 1 - Test that the pwm is correctly working");
	$display("-----------------------------------------------");
	#151 assert((motor_2 == 1)&&(motor_1 == 0)) $display("PASS - Motor enabled correctly - Direction is correct"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	#999 assert((motor_2 == 1)&&(motor_1 == 0)) $display("PASS - Duty cycle is correct"); else $error("FAIL - Duty cycle is incorrect");
	#1 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - Motor disabled correctly"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	#599 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - Period is correct"); else $error("FAIL - Period is incorrect");
	#1 assert((motor_2 == 1)&&(motor_1 == 0)) $display("PASS - Motor re-enabled correctly - Direction is correct"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	
/////////////////////////////////////////////////////////////////////////////////////////
	//TEST 2 - test that pwm is correctly working at different duty cycle and period
	$display("----------------------------------------------------------------------------------");
	$display("TEST 2 - Test that the pwm is correctly working at different period and duty cycle");
	$display("The duty cycle must only update when it has finished the previously input period");
	$display("----------------------------------------------------------------------------------");
	//Period = 100ns / Duty cycle = 60ns
	#250 period = 8'b00000101;
	dutyCycle = 8'b00000011;
	$display("New duty cycle and period have been input");
	//Testing that previous period finishes before updating period and duty cycle
	#749 assert((motor_2 == 1)&&(motor_1 == 0)) $display("PASS - Previously input duty cycle is correct"); else $error("FAIL - Previously input duty cycle is incorrect");
	#1 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - Motor disabled correctly"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	#599 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - Previously input period is correct"); else $error("FAIL - Previously input period is incorrect");
	#1 assert((motor_2 == 1)&&(motor_1 == 0)) $display("PASS - Motor re-enabled correctly - Direction is correct"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	//Testing udated duty cycle and period
	$display(" "); //gap to make testbench output clearer
	#599 assert((motor_2 == 1)&&(motor_1 == 0)) $display("PASS - New input duty cycle is correct"); else $error("FAIL - Previously input duty cycle is incorrect");
	#1 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - Motor disabled correctly"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	#399 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - New input period is correct"); else $error("FAIL - Previously input period is incorrect");
	////////////////////////////////////////////////////////////////////////////////////////////
	//TEST 3 - test that the pwm controller can run anti-clockwise
	$display("----------------------------------------------------------------------------------");
	$display("TEST 3 - Test that the pwm controller can run anti-clockwise");
	$display("----------------------------------------------------------------------------------");
	//Set direction to anti-clockwise
	direction = 0; //Changing direction for TEST 3
	#1 assert((motor_2 == 0)&&(motor_1 == 1)) $display("PASS - Motor changed direction correctly"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
/////////////////////////////////////////////////////////////////////////////////////////
	//TEST 4 - test that the brake function works correctly
	$display("----------------------------------------------------------------------------------");
	$display("TEST 4 - Test that the brake function works correctly");
	$display("----------------------------------------------------------------------------------");
	#50 brake = 1;
	#150 assert((motor_2 == 1)&&(motor_1 == 1)) $display("PASS - Motor braked correctly"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	#10 brake = 0;
/////////////////////////////////////////////////////////////////////////////////////////
	//TEST 5 - test that the pwm outputs can be toggled on and off
	$display("----------------------------------------------------------------------------------");
	$display("TEST 5 - Test that the pwm outputs can be toggled on and off");
	$display("----------------------------------------------------------------------------------");
	#100 pwmOutEnable = 0;
	#90 assert((motor_2 == 0)&&(motor_1 == 0)) $display("PASS - All PWM outputs were pulled low"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
/////////////////////////////////////////////////////////////////////////////////////////
	//TEST 6 - test that brake overrides the PWM output being toggled low
	$display("----------------------------------------------------------------------------------");
	$display("TEST 6 - Test that brake overrides the PWM output being toggled low");
	$display("----------------------------------------------------------------------------------");
	#1 brake = 1;
	#199 assert((motor_2 == 1)&&(motor_1 == 1)) $display("PASS - Motor braked correctly"); else $error("FAIL - motor_1 = %b - motor_2 = %b",motor_1, motor_2);
	$display("----------------------------------------------------------------------------------");
	$display("END OF TESTING");
end
endmodule
