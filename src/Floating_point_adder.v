module nayanesh_reddy_FP_add(io_in, io_out);
  input [7:0] io_in;
  output [7:0] io_out;
  
  wire clk = io_in[0];
  wire rst_n = io_in[1];
  wire [5:0] fp = io_in[7:2];
  wire [5:0] out;
  
  reg [5:0] fp1, fp2;
  
  always @(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
        begin
          fp1 <= 0;
          fp2 <= 0;
        end
      else
        begin
          fp1 <= fp;
          fp2 <= fp1;
        end
    end
  
  FP_addition FP_add(fp1, fp2, out);
  
  assign io_out[7:2] = out;
  assign io_out[0] = (&out[4:2]) & ~(|out[1:0]);
  assign io_out[1] = (&out[4:2]) & (|out[1:0]);
  
endmodule

module FP_addition(fp1, fp2, fp_out);
  
  parameter EXPONENT = 3,
  			MANTISSA = 2;
  
  input  [EXPONENT+MANTISSA : 0] fp1, fp2;
  output [EXPONENT+MANTISSA : 0] fp_out;
  
  wire S1, S2, carry, So, c_out, n1, n2;
  wire [EXPONENT-1 : 0] E1, E2, sub, sr, Ei, Eo;
  wire [MANTISSA-1 : 0] M1, M2, Mo;
  wire [MANTISSA : 0] ma, mb, sum;
  
  assign S1 = fp1[EXPONENT+MANTISSA];
  assign S2 = fp2[EXPONENT+MANTISSA];
  
  assign E1 = fp1[EXPONENT+MANTISSA : MANTISSA];
  assign E2 = fp2[EXPONENT+MANTISSA : MANTISSA];
  
  assign M1 = fp1[MANTISSA-1 : 0];
  assign M2 = fp2[MANTISSA-1 : 0];

  assign {carry, sub} = E1 - E2;
  
  assign sr = (carry) ? (~sub + 1) : sub;
  assign Ei = (carry) ? E2 : E1;
  assign So = (carry) ? S2 : S1;
  
  assign n1 = |E1;
  assign n2 = |E2;
  
  assign ma = ((carry) ? {n1, M1} : {n2, M2}) >> sr;
  assign mb = (carry) ? {n2, M2} : {n1, M1};
  
  assign {c_out, sum} = ma + mb;
  
  assign Eo = ( c_out | (~n1 & ~n2 & sum[MANTISSA]) ) ? (Ei + 1) : Ei;
  
  assign Mo = (c_out) ? sum[MANTISSA : 1] : sum[MANTISSA-1 : 0];
  
  assign fp_out = {So, Eo, Mo};
  
endmodule

