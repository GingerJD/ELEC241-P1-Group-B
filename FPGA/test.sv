module TEST(output logic [11:0]x);
initial begin
x = 12'b000000000000;
#100 x++;
#50 x--;
#50 x--;







end


endmodule
