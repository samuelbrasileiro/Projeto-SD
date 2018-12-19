module membrana(g, clock, enable, in, out, m, c, d, u, nm, nc, nd, nu );
	output reg g;
	input clock;
	input enable;
	
	input  [3:0] in;
	output reg [3:0] out;

	output reg [3:0] m;
	output reg [3:0] c;
	output reg [3:0] d;
	output reg [3:0] u;
	
	
	reg [3:0] milhar;
	reg [3:0] centena;
	reg [3:0] dezena;
	reg [3:0] unidade;
	
	
	output reg [3:0] nu;
	output reg [3:0] nd;
	output reg [3:0] nc;
	output reg [3:0] nm;


	initial begin
		//12 significa que esta vazio
		milhar <= 12;
		centena<= 12;
		dezena <= 12;
		unidade<= 12;
		out<= 4'b0111;
		state <= mandar;
	end

	reg[19:0] debouncer;
	parameter [1:0] mandar = 2'b00, receber = 2'b01, debounce = 2'b10, esperar = 2'b11;
	reg[3:0] leitorIn; //servem para armazenar o in e o out
	reg[3:0] leitorOut;
	reg[3:0] state;

	reg[3:0] num;
	
	wire little;

	lilCount counter(clock,little);

	always @(posedge little)begin
	
        if(!enable) begin
		
			case(state)
				mandar:
				begin
					case(out)
						4'b1110: out <= 4'b1101;
						4'b1101: out <= 4'b1011;
						4'b1011: out <= 4'b0111;
						4'b0111: out <= 4'b1110;
					endcase
					g<=1;
					state <= receber;
				end
   				receber:
				begin
					g<=1;
					if(in!=4'b1111)
					begin
						leitorIn <= in;
						leitorOut <= out;
						state <= debounce;
						debouncer <= 0;						
					end

					else state <= mandar;

				end

				debounce:
				begin
					if(debouncer<12)
					begin
						g<=0;
						debouncer <= debouncer + 1;
						out <= leitorOut;
					end
						
					else if(in == leitorIn)//se o in continua sendo o in anterior mudo o estado
						state <= esperar;
					else
						state <= mandar;
				end

				esperar:
				begin
					if(enable)
						state<=mandar;
					if(in==4'b1111 || in != leitorIn)//soltou o botao
					begin
						if(leitorIn==4'b1110 && leitorOut==4'b1110)
							num <= 1;
						else if(leitorIn==4'b1110 && leitorOut==4'b1101)
							num <= 2;
						else if(leitorIn==4'b1110 && leitorOut==4'b1011)
							num <= 3;
						else if(leitorIn==4'b1101 && leitorOut==4'b1110)
							num <= 4;
						else if(leitorIn==4'b1101 && leitorOut==4'b1101)
							num <= 5;
						else if(leitorIn==4'b1101 && leitorOut==4'b1011)
							num <= 6;
						else if(leitorIn==4'b1011 && leitorOut==4'b1110)
							num <= 7;
						else if(leitorIn==4'b1011 && leitorOut==4'b1101)
							num <= 8;
						else if(leitorIn==4'b1011 && leitorOut==4'b1011)
							num <= 9;
						else if(leitorIn==4'b0111 && leitorOut==4'b1101)
							num <= 0;
						else if(leitorIn==4'b0111 && leitorOut==4'b1011)
							num <= 10;//hashtag
						else num <= 12;//nada




						if(num<10)
						begin
							if(unidade == 12)
								unidade <= num;
							else if(dezena == 12)
							begin
								dezena <= unidade;
								unidade<= num;
							end
							else if(centena == 12)
							begin
								centena<= dezena;
								dezena <= unidade;
								unidade<= num;
							end
							else if(milhar == 12)
							begin 
								milhar <= centena;
								centena<= dezena;
								dezena <= unidade;
								unidade<= num;
							end
						end
						
							if(milhar == 12)
								nm = 0;
							else
								nm = milhar;

							if(centena == 12)
								nc = 0;
							else
								nc = centena;

							if(dezena == 12)
								nd = 0;
							else
								nd = dezena;

							if(unidade == 12)
								nu = 0;
							else
								nu = unidade;
							
							if(num == 10) 
							begin
								m<=nm;
								c<=nc;
								d<=nd;
								u<=nu;
																
								milhar <= 12;
								centena<= 12;
								dezena <= 12;
								unidade<= 12;
							end
						

						state <= mandar;
					end // fecha if(in==4'b1111 || in != leitorIn)//soltou o botao

				end


			endcase //case do state
		end // if ! enable
	
		else begin
			milhar <= 12;
			centena<= 12;
			dezena <= 12;
			unidade<= 12;
			out<= 4'b0111;
			state <= mandar;
		end
	end // always


endmodule
