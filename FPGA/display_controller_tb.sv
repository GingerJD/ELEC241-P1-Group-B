//////////////////////////////////////////////////////////////////
// Design unit	: display_controller_tb
// 		:
// File name	: display_controller_tb.sv
//		:
// Description	: Test bench for display_controller.sv
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
// Revision	: Version 1.5 14/05/22
//////////////////////////////////////////////////////////////////
module display_controller_tb;

//Set initial variables for display_controller.sv
logic [7:0] data;
logic rs;
logic rw;
logic e;
logic clk;
logic busyF;
logic [11:0] angle;

//Initialize display_controller.sv
display_controller u1(data, rs, rw, e, clk, busyF, angle);


//Simulates clock input
initial
begin
	clk = 1;	
	repeat(66896668) begin
		#10;		//clock has a period of 20ps to allow for easy navigation of waveform
		clk = ~clk;

	end
end

initial begin
angle = 503;
busyF = 0;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TEST 1 - Test to see that the angle is being read at fixed rate
$display("WARNING - Due to the DC being very timing dependant this testbench requires 668,966,680ps of simulation");
$display("This can take a while to run on modelsim");
$display("----------------------------------------------------------------------------------");
$display("TEST 1 - Test to see that the angle is being read at fixed rate");
#333333321 assert((rs == 0)&&(rw == 0)) $display("PASS - Angle is being read at a fixed rate of 60Hz "); else $error("FAIL - Angle is not being read at correct rate");
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TEST 2 - Test to see that the LCD has been cleared
$display("----------------------------------------------------------------------------------");
$display("TEST 2 - Test to see that the LCD has been cleared");
assert((rs == 0)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=0 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00000001) $display("PASS - Correct data output "); else $error("FAIL - Desired data output: 00000001 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TEST 3 - Test to see that data is being written correctly
$display("----------------------------------------------------------------------------------");
$display("TEST 3 - Test to see that data is being written correctly");
//TESTING ASCII CHARACTER 1
#2000000 assert((rs == 1)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=1 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00110001) $display("PASS - Correct data output for 1st ASCII character"); else $error("FAIL - Desired data output: 00110001 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
//TESTING ASCII CHARACTER 2
$display(" ");	//Gaps in output to make easier to read
#50000 assert((rs == 1)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=1 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00111000) $display("PASS - Correct data output for 2nd ASCII character "); else $error("FAIL - Desired data output: 00111000 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
//TESTING ASCII CHARACTER 3
$display(" ");	//Gaps in output to make easier to read
#50000 assert((rs == 1)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=1 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00110000) $display("PASS - Correct data output for 3rd ASCII character "); else $error("FAIL - Desired data output: 00110000 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TEST 4 - Second test to see that the angle is being read at fixed rate
$display("----------------------------------------------------------------------------------");
$display("TEST 4 - Second test to see that the angle is being read at fixed rate");
$display("New angle has been input");
angle = 771;
#331033340 assert((rs == 0)&&(rw == 0)) $display("PASS - Angle is being read at a fixed rate of 60Hz "); else $error("FAIL - Angle is not being read at correct rate");
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TEST 5 - Test to see that the LCD has been cleared
$display("----------------------------------------------------------------------------------");
$display("TEST 5 - Test to see that the LCD has been cleared");
assert((rs == 0)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=0 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00000001) $display("PASS - Correct data output "); else $error("FAIL - Desired data output: 00000001 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TEST 6 - Test to see that data is being written correctly
$display("----------------------------------------------------------------------------------");
$display("TEST 6 - Test to see that data is being written correctly");
//TESTING ASCII CHARACTER 1
#2000000 assert((rs == 1)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=1 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00110010) $display("PASS - Correct data output for 1st ASCII character"); else $error("FAIL - Desired data output: 00110010 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
//TESTING ASCII CHARACTER 2
$display(" ");	//Gaps in output to make easier to read
#50000 assert((rs == 1)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=1 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00110111) $display("PASS - Correct data output for 2nd ASCII character "); else $error("FAIL - Desired data output: 00110111 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
//TESTING ASCII CHARACTER 3
$display(" ");	//Gaps in output to make easier to read
#50000 assert((rs == 1)&&(rw == 0)) $display("PASS - RS and RW are at correct values "); else $error("FAIL - Desired values: RS=1 RW =0 // Actual values:RS=%b RW=%b",rs,rw);
assert(data == 8'b00110110) $display("PASS - Correct data output for 3rd ASCII character "); else $error("FAIL - Desired data output: 00110110 // Actual data output: %b",data);
assert(e == 1) $display("PASS - Enable pin correctly toggled on "); else $error("FAIL - Enable pin was not toggled on");
#49999 assert(e == 1) $display("PASS - Enable pin remained high for correct duration"); else $error("FAIL - Enable pin  did not remain high for correct duration");
#1 assert(e == 0) $display("PASS - Enable pin correctly toggled off "); else $error("FAIL - Enable pin was not toggled off");
$display("END OF TESTING");
end




















endmodule
