`timescale 1ns/100ps
/*
Filename      : tb_TT.v
Author        : Liam Crowley
Created       : Fri Nov  3 13:52:03 2023
INPUTS        : 
OUTPUTS       : 
PARAMETERS    : 

Description   : Testbench for entire module
*/
module tb_TT (/*AUTOARG*/) ;
   reg [7:0] ui_in, uio_in;
   reg [7:0] uio_oe;
   reg	     ena,clk,rst_n;
   wire [7:0] uo_out, uio_out;

   tt_um_electronicstinkerer_dds_collab
     #(.FOO(0),.tuneW(16),.waveW(12),.phaseW(14))
   TT(
     .ui_in(ui_in),
     .uio_in(uio_in),
     .uio_oe(uio_oe),
     .clk(clk),
     .ena(ena),
     .rst_n(rst_n),
     .uo_out(uo_out),
     .uio_out(uio_out));
   
   
   initial begin
      {ui_in,uio_in} = 16'hffff;
      uio_oe = 8'b01000000;
      clk=0;
      ena = 0;
      rst_n=0;
      /* verilator lint_off STMTDLY*/
      forever #10 clk=~clk;
      /* verilator lint_on STMTDLY*/
   end
   
  // always #10 clk=~clk;
   /* verilator lint_on STMTDLY*/
endmodule // tb_TT
