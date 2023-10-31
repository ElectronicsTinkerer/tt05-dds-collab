`timescale 1ns / 1ps
/**
 * Tiny DDS Collab top-level module
 * 
 * Authors:
 * * Zach Baldwin 2023-10-26
 * * Liam Crowley 2023-10-26
 * 
 */

`default_nettype none

module tt_um_electronicstinkerer_dds_collab 
  #(
    parameter FOO = 0
    )
   (
    input wire [7:0]  ui_in, // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out, // Dedicated outputs - connected to the 7 segment display
    input wire [7:0]  uio_in, // IOs: Bidirectional Input path
    output wire [7:0] uio_out, // IOs: Bidirectional Output path
    output wire [7:0] uio_oe, // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input wire        ena, // will go high when the design is enabled
    input wire        clk, // clock
    input wire        rst_n     // reset_n - low to reset
    );

   // assign uio_out = 8'b0;
   assign uio_out[3:0] = 0;
   // assign uo_out[7:6] = 2'b0;
   //assign uio_oe = 8'b0;
   
   wire   [2:0] sel0, sel1, sel2, sel3;
   wire   [16-1:0] Io0, Io1, Io2, Io3;
   wire   [12-1:0] Oi0, Oi1, Oi2, Oi3;
   assign sel0 = uio_oe[5:3];
   assign sel1 = uio_oe[2:0];
   assign sel2 = uio_oe[5:3];
   assign sel3 = uio_oe[2:0];
   
//   assign sel = 3'b000;
   
   /*
   lut_rw 
     #(
       .WW(6),
       .DEPTH(16)
       )
   LUT_REPROG
     (
      .clk(clk),
      .we(uio_in[0]),
      .re(uio_in[1]),
      .ra(uio_in[5:2]),
      .wa({uio_in[7:6], ui_in[7:6]}),
      .wd(ui_in[5:0]),
      .rd(uo_out[5:0])
      );*/

    /* Sine
     #(
     .n(14),
     .m(12)
     )
     SINE
     (
     .phase({uio_in[7:0],ui_in[7:2]}),
     .sine({uo_out[7:0],uio_out[7:4]})
     );*/
   I_mux
     #(.m(16))
   I_MUX
     (.in({ui_in,uio_in}),
      .sel(uio_oe[7:6]),
      .out0(Io0),
      .out1(Io1),
      .out2(Io2),
      .out3(Io3));

   O_mux
      #(.m(12))
   O_MUX
      (.in0(Oi0),
       .in1(Oi1),
       .in2(Oi2),
       .in3(Oi3),
       .sel(uio_oe[7:6]),
       .out({uo_out,uio_out[7:4]}));

   top
     #(.n(14),.m(12),.tune(16))
   VOICE0
     (.clk(clk),
      .OUT(Oi0),
      .sel(sel0),
      .tuningW(Io0));
   
   top
     #(.n(14),.m(12),.tune(16))
   VOICE1
     (.clk(clk),
      .OUT(Oi1),
      .sel(sel1),
      .tuningW(Io1));
   
   top
     #(.n(14),.m(12),.tune(16))
   VOICE2
     (.clk(clk),
      .OUT(Oi2),
      .sel(sel2),
      .tuningW(Io2));
   
   top
     #(.n(14),.m(12),.tune(16))
   VOICE3
     (.clk(clk),
      .OUT(Oi3),
      .sel(sel3),
      .tuningW(Io3));
   

   
       /*
	* top
     #(.n(14),.m(12),.tune(16))
   DDStop
     (.clk(clk),
      .OUT({uo_out,uio_out[7:4]}),
      .sel(sel),
      .tuningW(Io0);
   
	*/

endmodule // tt_um_electronicstinkerer_dds_collab
