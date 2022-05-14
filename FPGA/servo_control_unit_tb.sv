module servo_control_unit_tb;

//Set initial variables for servo_control_unit.sv
logic Direction;
logic brake;
logic resetOut;
logic [7:0] pwmDT;
logic [7:0] pwmPeriod;
logic [31:0] statusR;
logic [31:0] inputR;
logic [11:0] atuAngle;

//Initialize servo_control_unit.sv

scu u1(Direction, brake, resetOut, pwmDT,pwmPeriod,statusR,inputR,atuAngle);
initial begin
//Initial Setup for tests
atuAngle = 0;	

//////////////////////////////////////////////////////////////////////////////
//TEST 1 - statusR is written correctly
$display("------------------------------------------------------");
$display("TEST 1 - Test to see if status register is output correctly");
atuAngle = 503;
#1 assert(statusR == 32'b00000000000000000000111110111) $display("PASS - Status register was output correctly"); else $error("FAIL - Desired status register: 00000000000000000000111110111 // Actual status register: %b",statusR);
atuAngle = 124;
#1 assert(statusR == 32'b00000000000000000000001111100) $display("PASS - Status register was output correctly"); else $error("FAIL - Desired status register: 00000000000000000000001111100 // Actual status register: %b",statusR);
//////////////////////////////////////////////////////////////////////////////
//TEST 2 - Possile to set desired angle - clockwise - bang bang control
$display("------------------------------------------------------");
$display("TEST 2 - Test to see if you can set desired angle with bang bang control");
#100 inputR = 32'b10000000000011001000000011111100;
#1 assert(Direction==1) $display("PASS - Direction is correct"); else $error("FAIL - Desired direction: 1 // Actual direction: %b",Direction);
assert(pwmDT==pwmPeriod) $display("PASS - Duty cycle is correct"); else $error("FAIL - Desired duty cycle: %b // Actual duty cycle: %b",pwmPeriod, pwmDT);
//Simulate motor moving
repeat(128)begin 
	#50
	atuAngle++;
end
#1 assert(pwmDT==0) $display("PASS - Motor has stopped at correct angle"); else $error("FAIL - Motor failed to stop at correct angle");
//TEST 2 - Part 2 - Test for anticlockwise direction after motor has stopped
$display("New disired angle has been entered");
inputR = 32'b10000000000011001000000010101000;
#1 assert(Direction==0) $display("PASS - Direction is correct"); else $error("FAIL - Desired direction: 0 // Actual direction: %b",Direction);
assert(pwmDT==pwmPeriod) $display("PASS - Duty cycle is correct"); else $error("FAIL - Desired duty cycle: %b // Actual duty cycle: %b",pwmPeriod, pwmDT);
//simulate motor moving
repeat(84)begin 
	#50
	atuAngle--;
end
#1 assert(pwmDT==0) $display("PASS - Motor has stopped at correct angle"); else $error("FAIL - Motor failed to stop at correct angle");

//////////////////////////////////////////////////////////////////////////////
//TEST 3 - Possile to set desired angle - clockwise - proportional control
$display("------------------------------------------------------");
$display("TEST 3 - Test to see if you can set desired angle with proportional control");
#100 inputR = 32'b10001000000011001000000111110111;
#1 assert(pwmDT==8'b01000011) $display("PASS - Initial dutyCycle is correct"); else $error("FAIL - Desired duty cycle: // Actual duty cycle: %b",pwmDT);
assert(Direction==1) $display("PASS - Direction is correct"); else $error("FAIL - Desired direction: 1 // Actual direction: %b",Direction);
//simulate motor moving
repeat(335)begin 
	#50
	atuAngle++;
	if(atuAngle == 217)
		assert(pwmDT == 8'b00110010) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00110010 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 281)
		assert(pwmDT == 8'b00101000) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00101000 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 399)
		assert(pwmDT == 8'b00010100) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00010100 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 462)
		assert(pwmDT == 8'b00001000) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00001000 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 502)
		assert(pwmDT == 8'b00000001) $display("PASS - Motor has not stopped early"); else $error("FAIL - Desired duty cycle: 00000001 // Actual duty cycle: %b",pwmDT);

end
#1 assert(pwmDT == 8'b00000000) $display("PASS - Motor has stopped at correct angle"); else $error("FAIL - Desired angle to stop motor: 00001000 // Actual duty cycle: %b",pwmDT);
$display("New disired angle has been entered");
inputR = 32'b10001000000011001000000101001111;
#1 assert(pwmDT==8'b00100001) $display("PASS - Initial dutyCycle is correct"); else $error("FAIL - Desired duty cycle: 00100001// Actual duty cycle: %b",pwmDT);
assert(Direction==0) $display("PASS - Direction is correct"); else $error("FAIL - Desired direction: 0 // Actual direction: %b",Direction);
//simulate motor moving
repeat(168)begin 
	#50
	atuAngle--;
	if(atuAngle == 488)
		assert(pwmDT == 8'b00011101) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00011101 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 468)
		assert(pwmDT == 8'b00011001) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00011001 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 414)
		assert(pwmDT == 8'b00001111) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00001111 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 376)
		assert(pwmDT == 8'b00001000) $display("PASS - Duty cycle is decreasing proportionally"); else $error("FAIL - Desired duty cycle: 00001000 // Actual duty cycle: %b",pwmDT);
	if(atuAngle == 336)
		assert(pwmDT == 8'b00000001) $display("PASS - Motor has not stopped early"); else $error("FAIL - Desired duty cycle: 00000001 // Actual duty cycle: %b",pwmDT);
end
#1 assert(pwmDT == 8'b00000000) $display("PASS - Motor has stopped at correct angle"); else $error("FAIL - Desired angle to stop motor: 00001000 // Actual duty cycle: %b",pwmDT);
//////////////////////////////////////////////////////////////////////////////
//TEST 4 - NC COMMAND TEST
$display("------------------------------------------------------");
$display("TEST 4 - Test to see the no command defaults to brake");
inputR = 32'b11001000000011001000000101001111;
#1 assert(brake == 1) $display("PASS - SCU defaulted to brake"); else $error("FAIL - SCU did not default to brake");
#1 inputR = 32'b10001000000011001000000101001111; //Set command back to continuous mode for next test
#1 assert(brake == 0) $display("PASS - Correctly disabled brake on new command"); else $error("FAIL - SCU did not disable brake on new command");
#100;

//////////////////////////////////////////////////////////////////////////////
//TEST 5 - RESET COMMAND TEST
$display("------------------------------------------------------");
$display("TEST 5 - Test to see the reset command functions");
inputR = 32'b10101000000011001000000101001111;
#1 assert(resetOut == 1) $display("PASS - SCU has correctly output resetOut for other modules"); else $error("FAIL - SCU has not output resetOut for other modules");
#1 inputR = 32'b10001000000011001000000101001111; //Set command back to continuous mode for next test
#1 assert(resetOut == 0) $display("PASS - SCU has correctly pulled resetOut low on new command"); else $error("FAIL - SCU has not pulled resetOut low on new command");
#100;

//////////////////////////////////////////////////////////////////////////////
//TEST 6 - BRAKE COMMAND TEST - NEEDS TO OVERRIDE PWM POWER
$display("------------------------------------------------------");
$display("TEST 6 - Test to see the brake command functions");
inputR = 32'b11101000000011001000000101001111;
#1 assert(brake == 1) $display("PASS - SCU has correctly output brake"); else $error("FAIL - SCU has not output brake");
#1 inputR = 32'b10001000000011001000000101001111; 
#1 assert(brake == 0) $display("PASS - Correctly disabled brake on new command"); else $error("FAIL - SCU did not disable brake on new command");
#100;










end
endmodule


