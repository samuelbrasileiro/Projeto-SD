module main(clock, enable, func, reset, setm, setc, setd, setu, stop, in, out,cd);

input clock;
input enable;
input func;
input stop;
input reset;
input [3:0] in;
output [3:0] out;
output wire [6:0]setm;
output wire [6:0]setc;
output wire [6:0]setd;
output wire [6:0]setu;

wire [3:0] milhar;
wire [3:0] centena;
wire [3:0] dezena;
wire [3:0] unidade;

wire [3:0] nu;
wire [3:0] nd;
wire [3:0] nc;
wire [3:0] nm;

wire [3:0] m;
wire [3:0] c;
wire [3:0] d;
wire [3:0] u;

output wire cd;

membrana Memb (cd, clock, enable, in, out, m, c, d, u, nm, nc, nd, nu);

counter Count(clock, func, reset, enable, stop, milhar, centena, dezena, unidade, m, c, d, u);

display Dispm(clock, milhar, centena, dezena, unidade, enable, func, setm, setc, setd, setu, m, c, d, u, stop);

endmodule