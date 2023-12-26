`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 08:36:40 AM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0] instr,
    input imm_sel,
    output reg [31:0] imm_out
    );
    parameter I_R_type      = 7'b0010011;
    parameter Load_type     = 7'b0000011;
    parameter S_type        = 7'b0100011;
    parameter B_type        = 7'b1100011;
    parameter JAL_type      = 7'b1101111;
    parameter LUI           = 7'b0110111;
    parameter AUIPC         = 7'b0010111;
    
    wire [6:0] opcode;
    assign opcode = instr[6:0];
    always @ (*) begin
        if (imm_sel) begin
        case (opcode)
                I_R_type    :   imm_out = {{20{instr[31]}}, instr[30:20]};
                Load_type   :   imm_out = {{20{instr[31]}}, instr[30:20]};
                S_type      :   imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                B_type      :   imm_out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8],1'b0};
                JAL_type    :   imm_out = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21],1'b0};
                LUI         :   imm_out = {instr[31:12], 12'b0};
                AUIPC       :   imm_out = {instr[31:12], 12'b0};
                default     :   imm_out = 32'bx;
            endcase
        end
        else imm_out = 32'b0;
    end
endmodule
