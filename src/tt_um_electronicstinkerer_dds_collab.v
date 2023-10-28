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
   assign uio_oe = 8'b0;
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

     Sine
     #(
     .n(14),
     .m(12)
     )
     SINE
     (
     .phase({uio_in[7:0],ui_in[7:2]}),
     .sine({uo_out[7:0],uio_out[7:4]})
     );
      

endmodule // tt_um_electronicstinkerer_dds_collab
