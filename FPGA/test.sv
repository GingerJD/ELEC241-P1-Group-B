module test(output logic [11:0] a, output logic [11:0] b, output logic [11:0] acwDiff, output logic [11:0] cwDiff, output logic direction);
initial begin

logic [7:0] pwmDT;
logic [7:0] pwmPeriod;
logic [11:0] atuAngle;
logic [11:0] desiredAngle;
int x = 1006;
int y = 296;

a = x/y;

b = x-(a*y);
if(b >= (y/2))begin
	a = a+1;
end
//desiredAngle = 978;
//atuAngle = 28;
//
//
//a = desiredAngle - atuAngle;
//if(a[11] == 0)begin
//	$display("cw");
//	cwDiff = a;
//	acwDiff = 1006-a;
//end
//if(a[11] == 1)begin
//	$display("acw");
//	acwDiff = -a;
//	cwDiff = 1006+a;
//end
//if(cwDiff<=acwDiff)
//	direction = 1;
//else if(acwDiff < cwDiff)
//	direction =0;
end
endmodule
