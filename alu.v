`timescale 1ns / 1ps

module alu(
    input [31:0] A,
    input [31:0] B,
    input  [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);
    parameter   add     =   4'b0000;
    parameter   sub     =   4'b0001;
    parameter   orr     =   4'b0010;
    parameter   andd    =   4'b0011;
    parameter   xorr    =   4'b0100;
    parameter   slt     =   4'b0101;
    parameter   sll     =   4'b0110;
    parameter   srl     =   4'b0111;
    parameter   sra     =   4'b1000;
    parameter   sltu    =   4'b1001;
    parameter   lui     =   4'b1111;

    
    always @(*) begin
        case (alu_control)
            add : alu_result = A + B;
            sub : alu_result = A - B;
            orr : alu_result = A | B;
            andd: alu_result = A & B;
            xorr: alu_result = A ^ B;
            slt : alu_result = (A < B) ? 1 : 0;
            sll : alu_result = A << B;
            srl : alu_result = A >> B[4:0];
            sra : alu_result = A >>> B[4:0];
            sltu: alu_result = ((A<0? -A:A) < (B<0 ? -B:B)) ? 1 : 0;
            lui : alu_result = B;
            default : alu_result = 32'bx;
        endcase
    end
    assign zero =  (alu_result == 0) ? 1:0;
endmodule
