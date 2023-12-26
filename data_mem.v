`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 03:34:40 PM
// Design Name: 
// Module Name: data_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_mem(
    input clk, rst,
    input [31:0] address, DataW,
    input MemRW,
    output [31:0] DataR
    );
    integer i;
    reg [31:0] mem  [0:63];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i=0;i<64;i=i+1) begin
                mem[i] = 32'b0;
            end
            // mem[20] = 15;
            // mem[16] = 65340;  
            // mem[24] = 243;
            mem[28] = 32'h3e820293;
        end
        else begin
            if (MemRW) mem[address] <= DataW;
        end
    end
    assign DataR = mem[address];
endmodule
