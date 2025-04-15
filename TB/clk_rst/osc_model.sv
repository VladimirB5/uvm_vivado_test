`timescale 1ps/1ps
module osc_model (
  input bit enable,
  // sys_clk
  output logic clk
  );


 initial begin
   clk = 1'b0;
   #(10ns)
   clk = 1'b1;
   forever begin
     if (enable == 1'b1) begin
       clk = ~clk;
       #(5ns);
     end else begin
       #(1ns);
     end
   end
 end


endmodule
