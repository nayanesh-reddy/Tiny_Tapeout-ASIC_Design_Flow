module MAC_wrapper(io_in, io_out);
  input [7:0] io_in;
  output [7:0] io_out;
  
  MAC MAC_unit(io_in[4:2], io_in[7:5], io_out, io_in[1], io_in[0]);
  
endmodule

module MAC(x, w, out, rst, clk);

  input [2:0] x, w;
  input clk, rst;

  output reg [7:0] out;

  always @(posedge clk or posedge rst)
    begin
      if(rst)
        out <= 0;
      else
        out <= out + (x*w);
    end

endmodule
