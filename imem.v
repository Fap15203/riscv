`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 01:54:35 AM
// Design Name: 
// Module Name: imem
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

module imem(
    input [31:0] address,
    output  [31:0] RD
);
    reg [31:0] A [0:63];
    assign  RD = A[address>>2]  ;

    initial begin
        $readmemh ("hexfile.mem", A);
    end
    
endmodule 
