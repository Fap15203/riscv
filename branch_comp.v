`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 01:00:56 PM
// Design Name: 
// Module Name: branch_comp
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


module branch_comp (
    input [31:0] A,B,
    input brUn,
    output reg eq,lt
);
    always @(*) begin
        if (!brUn) begin
            eq = ($signed(A) == $signed(B)) ? 1:0; //($signed(A) == $signed(B))
            lt = ($signed(A) < $signed(B)) ? 1:0;  //($signed(A) < $signed(B))
        end
        else begin
            eq = (A == B) ? 1: 0;
            lt = (A < B) ? 1 : 0;
        end
    end

endmodule
