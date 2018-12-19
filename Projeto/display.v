module display(clock, milhar, centena, dezena, unidade, enable, func, setm, setc, setd, setu, m, c, d, u, stop);

	input [3:0]milhar;//do contador
	input [3:0]centena;
	input [3:0]dezena;
	input [3:0]unidade;
	
	input func;
	input enable;
	input clock;
	input stop;
	reg [3:0] state;
	
	input [3:0]m;//da membrana
	input [3:0]c;
	input [3:0]d;
	input [3:0]u;
	
	output reg [6:0]setm;
	output reg [6:0]setc;
	output reg [6:0]setd;
	output reg [6:0]setu;
	
	reg [3:0]numb;
	
	reg[12:0] numberi;
	reg[12:0] numberf;
	
	always@( posedge clock) begin
		case(state)
			4'b0111: state<=4'b1011;
			4'b1011: state<=4'b1101;
		    4'b1101: state<=4'b1110;
			4'b1110: state<=4'b0111;
			default: state<=4'b0111;
		endcase
		
		if(stop) begin
				if(enable) begin
					if(func) begin
						case (state)
							4'b0111:numb = milhar;
							4'b1011:numb = centena;
							4'b1101:numb = dezena;
							4'b1110:numb = unidade;
							
						endcase
					end
					
					else begin
						 numberi = 1000*milhar + 100*centena + 10*dezena + unidade;
						 numberf = 1000*m + 100*c + 10*d + u;
						 
						 case (state)
							4'b0111:numb = ( numberf - numberi)/1000;
							4'b1011:numb = ( numberf - numberi)/100 -(( numberf - numberi)/1000)*10;
							4'b1101:numb = (( numberf - numberi)%100 -(( numberf - numberi)%10))/10;
							4'b1110:numb = ( numberf - numberi)%10;
							
						endcase
					end
				end
				else begin
					case (state)
							4'b0111:numb = m;
							4'b1011:numb = c;
							4'b1101:numb = d;
							4'b1110:numb = u;
					endcase
					
					
				end
			
			if(state==4'b0111)begin
				case (numb)
					0: setm <= 7'b0000001;
					1: setm <= 7'b1001111;
					2: setm <= 7'b0010010;
					3: setm <= 7'b0000110;
					4: setm <= 7'b1001100;
					5: setm <= 7'b0100100;				
					6: setm <= 7'b0100000;						
					7: setm <= 7'b0001111;						
					8: setm <= 7'b0000000;		
					9: setm <= 7'b0000100;
				endcase
			end
			else if(state==4'b1011)begin
				case (numb)
					0: setc <= 7'b0000001;
					1: setc <= 7'b1001111;
					2: setc <= 7'b0010010;
					3: setc <= 7'b0000110;
					4: setc <= 7'b1001100;
					5: setc <= 7'b0100100;				
					6: setc <= 7'b0100000;						
					7: setc <= 7'b0001111;						
					8: setc <= 7'b0000000;		
					9: setc <= 7'b0000100;
				endcase
			end
			else if(state==4'b1101)begin
				case (numb)
					0: setd <= 7'b0000001;
					1: setd <= 7'b1001111;
					2: setd <= 7'b0010010;
					3: setd <= 7'b0000110;
					4: setd <= 7'b1001100;
					5: setd <= 7'b0100100;				
					6: setd <= 7'b0100000;						
					7: setd <= 7'b0001111;						
					8: setd <= 7'b0000000;		
					9: setd <= 7'b0000100;
				endcase
			end
			else if(state==4'b1110)begin
				case (numb)
					0: setu <= 7'b0000001;
					1: setu <= 7'b1001111;
					2: setu <= 7'b0010010;
					3: setu <= 7'b0000110;
					4: setu <= 7'b1001100;
					5: setu <= 7'b0100100;				
					6: setu <= 7'b0100000;						
					7: setu <= 7'b0001111;						
					8: setu <= 7'b0000000;		
					9: setu <= 7'b0000100;
				endcase
			end
			
		end
		
		
		
	end

endmodule