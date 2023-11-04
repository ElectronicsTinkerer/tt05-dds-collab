`timescale 1ns/1ns
/**
 * Test bench for the ENTIRE PROJECT (!)
 * 
 * Authors:
 * * Zach Baldwin 2023-11-04
 */
module tb_tt ();

   parameter PW = 24,
             DW = 16;

   reg       sclk, mosi, csb;
   reg       sys_clk;
   reg [DW-1:0] data, out_sr;
   reg          osc0_pw_sel;
   reg          dac_speed_sel;
   reg [7:0]    osc0_ext_pw;
   wire         dac_sclk, dac_mosi, dac_csb;
   wire [4:0]   out_dummy;
   reg          rst_n, ena;

   // Module instantiation
   tt_um_electronicstinkerer_dds_collab #() tt05
   (
    .ui_in({
            osc0_pw_sel,
            dac_speed_sel,
            3'b0,
            csb,
            mosi,
            sclk
            }),
    .uo_out({
             dac_sclk,
             dac_mosi,
             dac_csb,
             out_dummy
             }),
    .uio_in(osc0_ext_pw),
    .uio_out(),
    .uio_oe(),
    .ena(ena),
    .clk(sys_clk),
    .rst_n(rst_n)
    );
                                             

   // Reset & enable
   initial begin
      rst_n = 1'b0;
      ena = 1'b1;
      #40 rst_n = 1'b1;
   end

   
   // Set up clock
   initial begin
      sys_clk = 1'b0;
      forever #10 sys_clk = ~sys_clk;
   end

   initial begin
      sclk = 1'b0;
      forever #30 sclk = ~sclk;
   end


   // Stimulus
   integer ii = PW-1;
   reg [PW-1:0] v = 24'h0b0023;
   initial begin
      osc0_pw_sel = 1'b0;
      osc0_ext_pw = 8'h50;
      dac_speed_sel = 1'b1;
      csb = 1'b1;
      #40 csb = 1'b0;
      repeat (PW) begin
         @(posedge sclk) begin
            mosi = v[ii];
            ii = ii - 1;
         end
      end
      @(posedge sclk) csb = 1'b1;
        
      #500000 $stop();
   end // initial begin

   // OUTPUT SR
   always @(negedge dac_sclk or posedge dac_csb) begin
      if (!dac_csb) begin
         out_sr <= {out_sr[DW-2:0], mosi};
      end
      else begin
         data <= out_sr;
      end
   end

endmodule // tb_spi_main
