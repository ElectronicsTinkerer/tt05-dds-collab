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
    parameter phaseW = 14,//phase from phase accumulator width
    parameter packetWidth = 24, // Number of bits for the input SPI control word
    parameter ctlDataWidth = packetWidth-8 // Number of bits in the data portion of the SPI control word
    )
   (
    input wire [7:0]  ui_in, // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out, // Dedicated outputs - connected to the 7 segment display
    input wire [7:0]  uio_in, // IOs: Bidirectional Input path
    output wire [7:0] uio_out, // IOs: Bidirectional Output path
    input wire [7:0]  uio_oe, // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
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
   
   
   wire [2:0]       osc0_wave_sel, osc1_wave_sel;
   wire [1:0]       mod_sel;
   wire [tuneW-1:0] osc0_tune, osc1_tune;
   wire [waveW-1:0] osc0_wave_out, osc1_wave_out; //Wave out from voices
   wire             cDiv;
   wire [waveW-1:0] osc0_pulse_width,     // Modulation inputs for pwm
                    osc1_pulse_width,
                    osc1_ext_pulse_width;
   wire             E0, E1, Psel; //enable and select internal external pwm for voice 0
   wire [16-1:0]    OUT;
   wire             spi_sclk_in, spi_mosi, spi_csb;
   wire             spi_cmd_valid;
   wire [7:0]       spi_cmd_word;
   wire [ctlDataWidth-1:0] spi_data_word;
   //wire		      Osel;
   //assign uio_oe[7] = 0;
   
   assign Psel = uio_oe[6];
   //assign Osel = uio_oe[6];
   assign sel0 = uio_oe[5:3];
   assign sel1 = uio_oe[2:0];
   //assign {uo_out,uio_out[7:4]} = OUT;
   assign Io0 = {ui_in,uio_in};
   assign Io1 = {ui_in,uio_in};
  // assign uio_out[3:0] = 0;
   assign ext0 = 12'hfff;
   assign ext1 = 12'hfff;
   
   ///////////////////////////
   // INPUT SPI SHIFTER
   ///////////////////////////
   spi_in 
     #(
       .PACKET_WIDTH(packetWidth),
       .DATA_WIDTH(ctlDataWidth)
     ) SPI_SR_IN (
       .sys_clk(clk),
       .sclk(spi_sclk_in),
       .mosi(spi_mosi),
       .csb(spi_csb),
       .cmd_word(spi_cmd_word),
       .data_word(spi_data_word),
       .cmd_valid(spi_cmd_valid)
     );

   ///////////////////////////
   // INPUT SPI COMMAND AND DATA DECODE
   ///////////////////////////
   cmd_decoder
     #(
       .DATAWORD_WIDTH(ctlDataWidth),
       .TUNING_WIDTH(tuneW),
       .WAVE_SEL_WIDTH(3),
       .PULSEWIDTH_WIDTH(waveW),
       .MODE_SEL_WIDTH(2)
     ) CMD_DECODE (
       .sys_clk(clk),
       .cmd_word(spi_cmd_word),
       .data_word(spi_data_word),
       .cmd_valid(spi_cmd_valid),
       .osc0_en(E0),
       .osc1_en(E1),
       .osc0_tune(osc0_tune),
       .osc0_wave(osc0_wave_sel),
       .osc1_tune(osc1_tune),
       .osc1_wave(osc1_wave_sel),
       .osc1_pw(osc1_pulse_width),
       .mode_sel(mod_sel)
     );

   ///////////////////////////
   // Master Clock Divider
   ///////////////////////////
   div DIV
     (
      .clkI(clk),
      .clkO(cDiv)
     );
   
   ///////////////////////////
   // OSCILLATOR VOICES
   ///////////////////////////
   Osc
     #(
       .n(phaseW),
       .m(waveW),
       .tune(tuneW)
     ) VOICE0 (
       .CE(E0),
       .clk(cDiv),
       .OUT(osc0_wave_out),
       .sel(osc0_wave_sel),
       .tuningW(osc0_tune),
       .mod(osc0_puslse_width)
     );
   
   Osc
     #(
       .n(phaseW),
       .m(waveW),
       .tune(tuneW)
     ) VOICE1 (
       .CE(E1),
       .clk(cDiv),
       .OUT(osc1_wave_out),
       .sel(osc1_wave_sel),
       .tuningW(osc1_tune),
       .mod(osc1_pulse_width)
     );

   mux_2 #( .m(waveW) ) PULS_MUX
     (
      .in0(osc1_wave_out),
      .in1(osc1_ext_pulse_width),
      .sel(Psel),
      .out(osc0_pulse_width)
     );
   
   Mod
     #(
       .m(waveW),
       .o(16)
     ) MOD (
        .clk(clk),
        .OSC0(Oi0),
        .OSC1(Oi1),
        .modSel(sel1[1:0]),
        .modOut(OUT)
     );
   
/* -----\/----- EXCLUDED -----\/-----
   mux_2
     #(.m(waveW))
   OUTMUX
     (.sel(Osel),
      .in0(Oi0),
      .in1(Oi1),
      .out(OUT));
 -----/\----- EXCLUDED -----/\----- */

   spi_main_x2
     #(.WORD_WIDTH(16))
   SPIO
     (
      .sys_clk(clk),
      .parallel_in(OUT),
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
