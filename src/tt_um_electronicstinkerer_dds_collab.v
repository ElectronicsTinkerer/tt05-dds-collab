`timescale 1ns / 100ps
/**
 * Tiny DDS Collab top-level module
 * 
 * Authors:
 * * Zach Baldwin 2023-10-26
 * * Liam Crowley 2023-10-26
 * 
 */

//PRESENTLY INSTATIATES DIFFERENT SINE LUTS//

`default_nettype none

module tt_um_electronicstinkerer_dds_collab 
  #(
    parameter FOO = 0,
    parameter tuneW = 16, //tuning word width
    parameter waveW = 12, //waveform width
    parameter phaseW = 14 //phase from phase accumulator width
    )
   (
    input wire [7:0]  ui_in, // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out, // Dedicated outputs - connected to the 7 segment display
    input wire [7:0]  uio_in, // IOs: Bidirectional Input path
    output wire [7:0] uio_out, // IOs: Bidirectional Output path
    input wire [7:0] uio_oe, // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input wire        ena, // will go high when the design is enabled
    input wire        clk, // clock
    input wire        rst_n     // reset_n - low to reset 
   );

   // assign uio_out[3:0] = 0;
   // assign uio_out[3:0] = 0;
   // assign uo_out[7:6] = 2'b0;
   // assign uio_oe = 8'b0;
   assign uo_out[4:0] = 0;
   assign uio_out = 0;
   
   
   wire [2:0]       sel0, sel1;// sel2, sel3;
   wire [tuneW-1:0] Io0, Io1;// Io2, Io3; //Freq input to voices
   wire [waveW-1:0] Oi0, Oi1;// Oi2, Oi3; //Wave out from voices
   wire		    cDiv;
   wire [waveW-1:0] mod0, mod1, ext0, ext1;//modulation inputs for pwm
   wire		    E0, E1, Psel; //enable and select internal external pwm for voice 0
   wire [waveW-1:0] OUT;
   wire		      Osel;
   assign Psel = uio_oe[7];
   assign Osel = uio_oe[6];
   assign sel0 = uio_oe[5:3];
   assign sel1 = uio_oe[2:0];
   //assign {uo_out,uio_out[7:4]} = OUT;
   assign Io0 = {ui_in,uio_in};
   assign Io1 = {ui_in,uio_in};
  // assign uio_out[3:0] = 0;
   assign E1 = 0;
   assign E0 = 0;
   assign ext0 = 12'hfff;
   assign ext1 = 12'hfff;
   
   

   div DIV
     (.clkI(clk),
      .clkO(cDiv));
   
   top
     #(.n(phaseW),.m(waveW),.tune(tuneW))
   VOICE0
     (.CE(E0),
      .clk(cDiv),
      .OUT(Oi0),
      .sel(sel0),
      .tuningW(Io0),
      .mod(mod0));
   
   mux_2
     #(.m(waveW))
   PULS_MUX
     (.in0(Oi1),
      .in1(ext0),
      .sel(Psel),
      .out(mod0));

   assign mod1 = ext1;
   top
     #(.n(phaseW),.m(waveW),.tune(tuneW))
   VOICE1
     (.CE(E1),
      .clk(cDiv),
      .OUT(Oi1),
      .sel(sel1),
      .tuningW(Io1),
      .mod(mod1));

   mux_2
     #(.m(waveW))
   OUTMUX
     (.sel(Osel),
      .in0(Oi0),
      .in1(Oi1),
      .out(OUT));

   spi_main_x2
     #(.WORD_WIDTH(16))
   SPIO
     (
      .sys_clk(clk),
      .parallel_in({OUT,4'b1111}),
      .power_state(2'b11),
      .load(cDiv),
      .sclk(uo_out[7]),
      .mosi(uo_out[6]),
      .csb(uo_out[5])
      );
   
   
endmodule // tt_um_electronicstinkerer_dds_collab


/*
   top
     #(.n(14),.m(12),.tune(16))
   VOICE1
     (.clk(clk),
      .OUT(Oi1),
      .sel(sel1),
      .tuningW(Io1));
   *
    * top
     #(.n(14),.m(12),.tune(16))
   VOICE2
     (.clk(clk),
      .OUT(Oi2),
      .sel(sel2),
      .tuningW(Io2));
    */
   
   /*
    * top
     #(.n(14),.m(12),.tune(16))
   VOICE3
     (.clk(clk),
      .OUT(Oi3),
      .sel(sel3),
      .tuningW(Io3));
    */
   

   
       /*
	* top
     #(.n(14),.m(12),.tune(16))
   DDStop
     (.clk(clk),
      .OUT({uo_out,uio_out[7:4]}),
      .sel(sel),
      .tuningW(Io0);
   
	*/
   

   //assign sel1 = uio_oe[2:0];
   /*
    * assign sel2 = uio_oe[5:3];
   assign sel3 = uio_oe[2:0];
   assign Oi3 = 0;
   assign Oi2 = 0;
    */
   
   
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
     );
   I_mux
     #(.m(16))
   I_MUX
     (.in({ui_in,uio_in}),
      .sel(uio_oe[7:6]),
      .out0(Io0),
      .out1(Io1)
      
       * .out2(Io2),
      .out3(Io3)
       
);

   
    * O_mux
      #(.m(12))
   O_MUX
      (.in0(Oi0),
       .in1(Oi1),
       /*
       .in2(Oi2),
       .in3(Oi3),
       .sel(uio_oe[7:6]),
       .out({uo_out,uio_out[7:4]}));
   */
