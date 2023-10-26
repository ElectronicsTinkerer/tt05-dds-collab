`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10/21/2023 06:13:43 PM
Mux for DDS Algorith
INPUTS: Differnt Waveforms 
OUTPUTS: Selected output


*/

module mux(
    input [11:0] sine,
    input [11:0] saw,
    input [11:0] pulse,
    input [11:0] traing,
    input [11:0] noi,
    input [2:0] sel,
    output reg [11:0] wave
    );
    always @(*)
    begin
        case(sel)
            3'b000:wave<=sine;
            3'b001:wave<=saw;
            3'b010:wave<=pulse;
            3'b011:wave<=traing;
            3'b100:wave<=noi;
            default:wave<=sine;
        endcase
    end
    
endmodule
