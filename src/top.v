`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10/29/2023 06:49:21 PM
Top wrapper file for the DDS algorithm
INPUTS: 50/19MHz clk
OUTPUTS: Waveform post mux

*/

module top
    #(
    parameter n = 14,
    parameter m = 12,
    parameter tune = 16
    )
    (
    input wire		  clk,
    input wire [tune-1:0] tuningW,
    input wire [2:0]	  sel,
    output wire [m-1:0]	  OUT,
    input wire		  CE,
    input wire [m-1:0]	  mod	  
    );
//    (
//    input wire [7:0]  ui_in, // Dedicated inputs - connected to the input switches
//    output wire [7:0] uo_out, // Dedicated outputs - connected to the 7 segment display
//    input wire [7:0]  uio_in, // IOs: Bidirectional Input path
//    output wire [7:0] uio_out, // IOs: Bidirectional Output path
//    output wire [7:0] uio_oe, // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
//    input wire        ena, // will go high when the design is enabled
//    input wire        clk, // clock
//    input wire        rst_n     // reset_n - low to reset
//    );
//    wire cDiv18;
    wire [n-1:0] phase;
    wire [m-1:0]	triang;
    wire [m-1:0]	pulse;
    wire [m-1:0]	saw;
    wire [m-1:0]	sine;
    wire [m-1:0]	lfsr;
    wire [m-1:0]	pwm;
   //assign tuningW = {ui_in,uio_in};
    //assign {uo_out,uio_out[7:4]} = OUT;
   /*
    * 
    div #(
    ) DIV
    (.clkI(clk),
    .clkO(cDiv18)
    );
    */
    
    PhaseAccumulator
    #(
    .n(23),
    .m(n),
    .tune(tune)
    )
    PA
    (
    .ce(CE),
    .clk(clk),
    .tuning(tuningW),
    .phaseReg(phase)
    );
    
    Tri
    #(
    .n(n),
    .m(m)
    )
    TRI (
    .phase(phase),
    .triang(triang)
    );
    
    Pulse
    #(
    .n(n),
    .m(m)
    )
    PUL
    (
    .phase(phase),
    .pulse(pulse)
    );
    
    Saw
    #(
    .n(n)
    )
    SAW
    (
    .phase(phase),
    .saw(saw)
    );
    
    Sine
    #(
    .n(n),
    .m(m)
    )
    SINE
    (
    .phase(phase),
    .sine(sine)
    );
    
    Lfsr
    #(
    .n(n),
    .m(m)
    )
    LFSR
    (
    .clk(clk),
    .lfsr(lfsr)
    );

    Pwm
    #(
    .n(n),
    .m(m))
    PWM
    (
    .phase(phase),
    .mod(mod),
    .pwm(pwm)
    );

   
    
    mux
    #(
    .m(m)
    )
    MUX
    (
    .sine(sine),
    .saw(saw),
    .pulse(pulse),
    .traing(triang),
    .noi(lfsr),
    .pwm(pwm),
    .sel(sel),
    .wave(OUT)
    );
endmodule
