//////////////////////////////////////////////////////////////////
// Design unit	: angle_tracking_unit_tb
// 		:
// File name	: angle_tracking_unit_tb.sv
//		:
// Description	: Test bench for the ATU to test the following:
//		: > TEST 1 - Test to see if atu tracks angle correctly
//		: > TEST 2 - Test to see if atu tracks new angle correctly 
//		: > TEST 3 - Test to see if atu tracks angle correctly when
//		:   in anti-clockwise mode 
//		: > TEST 4 - Test to see reset functions correctly 
//		: > TEST 5 - Test to see if pulse monitoring can be turned off
//		: > TEST 6 - Test to see if angle goes from 0 to 360 instead of negative angle
//		: > TEST 7 - Test to see if angle goes from 359 to 0 instead of >360
//		:
// Limitations	: None
// 		:
// Author	: James Davis
//		: School of Engineering, Computing & Mathematics
//		: University of Plymouth
//		: Drake Circus, Plymouth PL4 8AA
//		: james.davis-11@students.plymouth.ac.uk
//		:
// Revision	: Version 1.5 05/05/22
//////////////////////////////////////////////////////////////////

module angle_tracking_unit_tb;
//Set initial variables for angle_tracking_unit.sv
logic [11:0] Q;
logic RESET, PM, DIRECTION, OPTOA, OPTOB;

//Initialize angle_tracking_unit.sv
atu u1(Q,RESET, PM, DIRECTION, OPTOA, OPTOB);

/////////////////////////////////////////////////////////////////////////////////
initial begin
	//SIMULATED MOTOR FOR TEST 1 - Move motor to 43.3 degrees
	#50
	OPTOA = 1;	
	repeat(240) begin
		#100;	
		OPTOA = ~OPTOA;
	end

	//SIMULATED MOTOR FOR TEST 2 - Move motor from 43.3 to 287 degrees
	#50
//	OPTOA = 1;	
	repeat(1363) begin
		#100;	
		OPTOA = ~OPTOA;
	end

	//SIMULATED MOTOR FOR TEST 3,4,5,6 
	#50
	OPTOA = 0;	
	repeat(207) begin
		#100;	
		OPTOA = ~OPTOA;
		
	end
	//SIMULATED MOTOR FOR TEST 7
	#50
	OPTOA = 1;	
	repeat(2) begin
		#100;	
		OPTOA = ~OPTOA;
	end
end




initial begin
	//SIMULATED MOTOR FOR TEST 1 - Move motor to 43.3 degrees
	#50
	OPTOB = 0;
	#25 OPTOB = 1;	
	repeat(240) begin
		#100;
		OPTOB = ~OPTOB;
	end

	//SIMULATED MOTOR FOR TEST 2 - Move motor from 43.3 to 287 degrees
	#50
//	OPTOB = 0;	
	repeat(1363) begin
		#100;	
		OPTOB = ~OPTOB;
	end
	//SIMULATED MOTOR FOR TEST 3,4,5,6 
	#50
	OPTOB = 1;	
	repeat(207) begin
		#100;	
		OPTOB = ~OPTOB;
	end
		
	//SIMULATED MOTOR FOR TEST 7
	#50
	OPTOB = 0;	
	repeat(2) begin
		#100;	
		OPTOB = ~OPTOB;
	end
end
/////////////////////////////////////////////////////////////////////////////////

initial begin
	PM = 1;
	DIRECTION = 1;
	RESET = 0;

	//Initial reset toggle on startup
	#1 RESET = 1;
	#1 RESET = 0;
/////////////////////////////////////////////////////////////////////////////////
	//TEST 1: Test to see if atu tracks angle correctly 
	//Simulated motor moves to 43.3 degrees
	$display("----------------------------------------------------------");
	$display("TEST 1: Test to see if atu tracks angle correctly");	
	#24049 assert(Q == 12'b000001111001) $display("PASS - Angle was tracked correctly - direction is correct"); else $error("FAIL - desired Q = 000001111001, actual Q = %b",Q);
/////////////////////////////////////////////////////////////////////////////////
	//TEST 2: Test to see if atu tracks angle correctly 
	//Simulated motor moves to 287 degrees
	$display("----------------------------------------------------------");
	$display("TEST 2: Test to see if atu tracks new angle correctly ");
	#136250 assert(Q == 12'b001100100010) $display("PASS - Angle was tracked correctly - direction is correct"); else $error("FAIL - desired Q = 001100100010, actual Q = %b",Q);
/////////////////////////////////////////////////////////////////////////////////
	//TEST 3: Test to see if atu tracks angle correctly when in anti-clockwise mode
	//Simulated motor moves to 253.7 degrees
	$display("----------------------------------------------------------");
	$display("TEST 3: Test to see if atu tracks angle correctly when in anti-clockwise mode");
	#1 DIRECTION= 0;
	#18374 assert(Q == 12'b001011000101) $display("PASS - Angle was tracked correctly in anti-clockwise mode"); else $error("FAIL - desired Q = 001011000101, actual Q = %b",Q);
/////////////////////////////////////////////////////////////////////////////////
	//TEST 4: Test to see reset functions correctly
	$display("----------------------------------------------------------");
	$display("TEST 4: Test to see reset functions correctly");
	#100 RESET = 1;
	#1 RESET = 0;
	#1 assert(Q == 12'b000000000000) $display("PASS - Angle Tracking Unit reset successfully"); else $error("FAIL - desired Q = 000000000000, actual Q = %b",Q);
/////////////////////////////////////////////////////////////////////////////////
	//TEST 5: Test to see if pulse monitoring can be turned off
	$display("----------------------------------------------------------");
	$display("TEST 5: Test to see if pulse monitoring can be turned off");
	#10 PM = 0;
	#2000 assert(Q == 12'b000000000000) $display("PASS - Pulse monitoring was turned off"); else $error("FAIL - desired Q = 000000000000, actual Q = %b",Q);
	#1 PM = 1;
/////////////////////////////////////////////////////////////////////////////////
	//TEST 6: Test to see if angle goes from 0 to 360 instead of negative angle
	$display("----------------------------------------------------------");
	$display("TEST 6: Test to see if angle goes from 0 to 360 instead of negative angle");
	#87 assert(Q == 12'b001111101101) $display("PASS - Angle loop under was successful"); else $error("FAIL - desired Q = 001111101101, actual Q = %b",Q);
/////////////////////////////////////////////////////////////////////////////////
	//TEST 7: Test to see if angle goes from 359 to 0 instead of >360
	$display("----------------------------------------------------------");
	$display("TEST 7: Test to see if angle goes from 359 to 0 instead of >360");
	#50 DIRECTION = 1;
	#50 assert(Q == 12'b000000000000) $display("PASS - Angle loop over was successful"); else $error("FAIL - desired Q = 000000000000, actual Q = %b",Q);
end




endmodule
