`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10/29/2023 06:49:21 PM
Top wrapper file for the DDS algorithm
INPUTS: 50MHz clk
OUTPUTS: waveform post mux

*/

module top
    #(
    parameter n = 14,
    parameter m = 12,
    parameter tune = 16
    )
    (
    input wire clk50,
    output wire [m-1:0] OUT
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
    wire cDiv18;
    wire [n-1:0] phase;
    wire [tune-1:0] tuningW;
    wire [m-1:0] triag;
    wire [m-1:0] pulse;
    wire [m-1:0] saw;
    wire [m-1:0] sine;
    wire [m-1:0] lfsr;
    //assign tuningW = {ui_in,uio_in};
    //assign {uo_out,uio_out[7:4]} = OUT;
        
    div14 #(
    ) DIV
    (.clkI(clk),
    .clkO(cDiv18)
    );
    
    PhaseAccumulator
    #(
    .tune(tune)
    )
    PA
    (
    .clk(cDiv18),
    .tuning(tuningW),
    .phaseReg(phase)
    );
    
    triang 
    #(
    .n(n),
    .m(m)
    )
    TRIA (
    .phase(phase),
    .triag(triag)
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
    
    saw
    #(
    .n(n),
    .m(m)
    )
    SAW
    (
    .phase(phase),
    .outp(saw)
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
    
    lfsr
    #(
    .n(n),
    .m(m)
    )
    LFSR
    (
    .clk(cDiv18),
    .oot(lfsr)
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
    .traing(triag),
    .noi(lfsr),
    .sel(sel),
    .wave(OUT)
    );
endmodule
