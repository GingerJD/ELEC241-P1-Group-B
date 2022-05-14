module test(output logic [11:0] a, output logic [11:0] atuAngle,output logic [11:0] BCD, output logic [3:0] hundreds, output logic [3:0] tens,output logic [3:0] ones,output logic [11:0] degrees, output logic direction);
initial begin

logic [7:0] pwmDT;
logic [7:0] pwmPeriod;
//logic [11:0] atuAngle;
logic [11:0] desiredAngle;
int x = 1006;
int y = 296;



atuAngle = 995;
degrees = (atuAngle * 360)/1006;
if(((atuAngle * 360)-(degrees*1006))>503)
		degrees = degrees +1;
#100
$display("T1");
hundreds = (degrees / 100);
tens = (degrees-(hundreds * 100))/10;
ones = (degrees-(hundreds * 100)-(tens*10));
$display("T2");

BCD [11:8] = degrees / 100;
BCD [7:4] = (degrees-(BCD [11:8] * 100))/10;
BCD [3:0] = (degrees-(BCD [11:8] * 100)-(BCD [7:4]*10));






//
//b = x-(a*y);
//if(b >= (y/2))begin
//	a = a+1;
//end
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
