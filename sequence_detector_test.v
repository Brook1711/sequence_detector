module sequence_detector_test(clk, X, Y);
input clk, X;
output Y;
sequence_detector u_sequence_detector(.clk(clk), .X(X), .Y(Y));

endmodule

module sequence_detector(clk, X, Y);
input clk;
input X;
output Y;

wire [1:0] Q_temp;
wire [1:0] Q_temp_;

JK_flip_flop u_JK_0(.clk(clk), .J(X), .K(~X), .SD(1), .RD(1), .Q(Q_temp[0]), .Q_(Q_temp_[0]) );
JK_flip_flop u_JK_1(.clk(clk), .J(Q_temp[0] & X), .K(~X), .SD(1), .RD(1), .Q(Q_temp[1]), .Q_(Q_temp_[1]) );

assign Y = Q_temp[1] & (~X);
endmodule

module JK_flip_flop(clk, J, K, SD, RD, Q, Q_);
input clk, J, K, SD, RD;
output Q, Q_;

reg Q1;

wire clr;

assign clr = SD & RD;
assign judgez = SD|RD;
assign Q_ = ~Q1;

assign Q = Q1;

//assign Q_ = (SD^RD==1)? SD : ((SD == 1)? ~Q1:1'bz);

//assign Q = (SD^RD==1)? RD : ((SD == 1)? Q1:1'bz);


initial 
begin
	Q1=0;
end
always @(posedge clk or negedge clr or negedge judgez) begin
if (judgez==0) begin
	Q1<=1'bz;
end
else if (clr==0) begin
	Q1<=RD;
end

else begin
	if (J == 0 & K == 0) begin
			Q1<=Q1;
	end
	else if (J == 0 & K == 1) begin
			Q1<=0;
	end
	else if (J == 1 & K == 0) begin
			Q1<=1;
	end
	else if (J == 1 & K == 1) begin
			Q1<=!Q1;
	end
	else begin
			Q1<=Q1;
	end
end

end

endmodule