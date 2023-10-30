`timescale 1ns/100ps
/**
 * Test bench for the SPI Main device (sends data out)
 * 
 * Authors:
 * * Zach Baldwin 2023-10-29
 */
module tb_spi_main ();

   parameter WW = 16;

   reg       sys_clk, load;
   reg [WW-1:0] data;
   reg [1:0]    power_state;
   wire         sclk, mosi, csb;

   // Module instantiation
   // spi_main
   spi_main_x2
     #(
       .WORD_WIDTH(WW)
       )
   UUT
     (
      .sys_clk(sys_clk),
      .load(load),
      .parallel_in(data),
      .power_state(power_state),
      .sclk(sclk), 
      .mosi(mosi),
      .csb(csb)
      );

   // Set up clock
   initial begin
      sys_clk = 1'b0;
      forever #10 sys_clk = ~sys_clk;
   end

   // Stimulus
   initial begin
      load = 1'b0;
      data = 16'ha5a5;
      power_state = 2'b11;
      @(posedge sys_clk)
        load = 1'b1;
      @(posedge sys_clk)
        data = 16'h04d8;
      power_state = 2'b01;
      @(posedge csb) /* empty */;
      @(posedge csb) load = 1'b0;
      #50 $stop();
   end

endmodule // tb_spi_main
