`timescale 1ns / 1ps

/**
Author: Liam Crowley
Date: 10/21/2023 08:16:45 PM
PWM Output for DDS Algorith
INPUTS: Waveform
OUTPUTS: PWM of waveform
PARAMETERS: Input waveform width

Takes waveform input, increments counter till it hits waveform value, then turns off output
*/

module pwm
    #( parameter m=12
    )
    (
    input clk,
    input [m-1:0] modu,
    output reg wave = 0
    );
    reg [3:0] i=0;
    always @(posedge clk)
    begin
        if(i>modu[m-1:m-4])
            wave = 0;
        else wave = 1;
        i = i+1;
    end
endmodule
//module pwm
//#(
//parameter m = 12
//    )
//    (
//    input clk,
//    input [m-1:0] modu,
//    output reg wave = 0
//    );
//    reg cState = 0, nState=0;
//    reg [3:0] cnt=0;
//    localparam s1 = 1'b0, s2 = 1'b1;
//    always @(posedge clk)
//    begin
//        case(cState)
//            s1: if (cnt==0) nState = s2;
//                else begin 
//                    cnt = cnt - 1;
//                    nState = cState;
//                    wave = 0;
//                end
//            s2: if (cnt==modu[m-1:m-4]) nState = s1;
//                else begin
//                    cnt = cnt+1;
//                    nState = cState;
//                    wave = 1;
//                end
//            default:begin
//                nState = cState;
//                wave = 0;
//                end
//            endcase
//    end
//endmodule
//module pwm
//    #(
//    parameter m =12
//    )
//    (
//    input clk,
//    input [m-1:0] modu,
//    output reg wave
//    );
//    reg [m-1:0] i = 0;
//    always @(posedge clk)
//    begin
//        //if(i==0) i =1;
//        if (i<modu) wave = 1;
//        else wave = 0;
//        i=i+4'b1000;
//    end
    
//endmodule
///REWRITE AS STATE MACHINE///
//module pwm
//    #(
//    parameter m = 12
//    )
//    (
//    input [m-1:0] modu,
//    input clk,
//    output reg wave = 0
//    );
//    localparam s1 = 1'b0, s2 = 1'b1;//,si=2'b10;
//    reg cState = 0, nState = 0;
//    reg [m-1:0] cnt = 0;
//    always @(posedge clk)
//    begin
//        cState<=nState;
//        cnt = cnt +1;
//    end
    
//    always @(*)
//    begin
        
//    end
////    always @(*)
////    begin
////        nState = cState;
////        case(cState)
////            s1:begin
////                if(cnt==modu) nState = s2;
////                else 
////                begin 
////                    cnt = cnt+1;
////                    wave = 1;
////                end
////            end
////            s2:begin
////                if(cnt==0) nState = s1;
////                else
////                begin
////                    cnt = cnt-1;
////                    wave = 0;
////                end
////            end
////        endcase
////    end
//endmodule
//module pwm(
//    input [11:0] modu,
//    input clk,
//    output reg wave = 0
//    );
//    reg [11:0] i=8'h00;
//    always @(posedge clk)
//    begin
//        i=i+1;
//        if (i<modu)
//            wave = 1;
//        else
//            wave = 0;
//    end
//endmodule
//module pwm
//    (
//    input clk,
//    input [11:0] modu,
//    output reg wave = 0
//    );
//    reg [11:0] i=1;
//    always @(posedge clk)
//    begin
//        if(i<modu) wave = 1;
//        else wave = 0;
//        i=i<<1;
//    end
//endmodule
