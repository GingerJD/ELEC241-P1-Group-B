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

//////////////////////////////////////////////////////////////////////////////
//TEST 6 - Current angle is output for DC 

//////////////////////////////////////////////////////////////////////////////
//TEST 8 - RESET COMMAND TEST

//////////////////////////////////////////////////////////////////////////////
//TEST 9 - NC COMMAND TEST

//////////////////////////////////////////////////////////////////////////////
//TEST 10 - BRAKE COMMAND TEST - NEEDS TO OVERRIDE PWM POWER











end
endmodule


