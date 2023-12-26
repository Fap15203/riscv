`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 10:08:55 AM
// Design Name: 
// Module Name: controller
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


module controller(
//    input [6:0] opcode, //instr[6:0]
//    input funct7, //instr[30]
//    input [2:0] funct3, //instr[14:12]
    input [31:0] instr,
    input BrEq, BrLt,
    output reg RegWEn, imm_sel, Bsel, Asel, BrUn, PCsel,
    output reg MemRW,
    output reg [1:0] WBsel,
    output reg [3:0] alu_control
    );
    
    //opcode
    parameter R_type        = 7'b0110011;
    parameter I_R_type      = 7'b0010011;
    parameter Load_type     = 7'b0000011;
    parameter Store_type    = 7'b0100011;
    parameter B_type        = 7'b1100011;
    parameter JAL_type      = 7'b1101111;
    parameter JALR_type     = 7'b1100111;
    parameter LUI           = 7'b0110111;
    parameter AUIPC         = 7'b0010111;
    
    //alu control
    parameter   add     = 4'b0000;
    parameter   sub     = 4'b0001;
    parameter   orr     = 4'b0010;
    parameter   andd    = 4'b0011;
    parameter   xorr    = 4'b0100;
    parameter   slt     = 4'b0101;
    parameter   sll     = 4'b0110;
    parameter   srl     = 4'b0111;
    parameter   sra     = 4'b1000;
    parameter   sltu    = 4'b1001;
    parameter   lui     = 4'b1111;
    
    //funct3
    parameter   ADD     =   3'b000;
    parameter   SUB     =   3'b000;
    parameter   ORR     =   3'b110;
    parameter   ANDD    =   3'b111;
    parameter   XORR    =   3'b100;
    parameter   SLT     =   3'b010;
    parameter   SLL     =   3'b001;
    parameter   SRL     =   3'b101;
    parameter   SRA     =   3'b101;
    parameter   SLTU    =   3'b011;
    
    //describe each element of instruction
    wire [6:0] opcode;
    wire funct7;
    wire funct3;
    assign opcode = instr[6:0];
    assign funct7 = instr[30];
    assign funct3 = instr[14:12];
    
    always @(*) begin
        $display("opcode: %h",opcode);
        case (opcode)
            R_type      :  begin
                if(funct7) begin
                    case (funct3)
                        SUB: alu_control  = sub;
                        SRA: alu_control  = sra;
                    default: alu_control  = sub;
                    endcase
                end
                else begin
                    case (funct3)
                        ADD : alu_control = add;
                        SLL : alu_control = sll;
                        SLT : alu_control = slt;
                        SLTU: alu_control = sltu;
                        XORR: alu_control = xorr;
                        SRL : alu_control = srl;
                        SRA : alu_control = sra;
                        ORR : alu_control = orr;
                        ANDD: alu_control = andd;
                    default : alu_control = add;
                    endcase
                end
                PCsel = 0;
                imm_sel = 0;
                RegWEn = 1;
                Bsel = 0;
                Asel = 0;
                WBsel = 1;
                MemRW = 0;
            end
            I_R_type    :  begin
                case (funct3)
                    ADD : alu_control = add;
                    SUB : alu_control = sub; 
                    ORR : alu_control = orr;
                    ANDD: alu_control = andd;
                    XORR: alu_control = xorr;
                    SLT : alu_control = slt;
                    SLTU: alu_control = sltu;
                    SLL : alu_control = sll;
                    SRL : alu_control = srl;
                    SRA : alu_control = sra;
                default : alu_control = add;
                endcase
                begin
                    PCsel = 0;
                    imm_sel = 1;
                    RegWEn = 1;
                    Bsel = 1;
                    Asel = 0;
                    WBsel = 1;
                    MemRW = 0;
                end

            end
            Load_type   :  begin
                imm_sel = 1;
                RegWEn = 1;
                Bsel = 1;
                WBsel = 0;
                MemRW = 0;
                alu_control = add;
            end
            Store_type  :   begin
                imm_sel = 1;
                RegWEn = 1;
                Bsel = 1;
                //WBsel = 0; //dont care
                MemRW = 1;
                alu_control = add;
            end
            B_type      :  begin
                case (funct3)
                    3'b000 : begin // BEQ
                        BrUn = 0;
                        if (BrEq) PCsel = 1;
                        else PCsel = 0;
                    end
                    3'b001 : begin // BNE
                        BrUn = 0;
                        if (!BrEq) PCsel = 1;
                        else PCsel = 0;
                    end
                    3'b100 : begin  //BLT
                        BrUn = 0;
                        if (BrLt) PCsel = 1;
                        else PCsel = 0;
                    end
                    3'b101 : begin  //BGE
                        BrUn = 0;
                        if (!BrLt) PCsel = 1;
                        else PCsel = 0 ;
                    end
                    3'B110 : begin  //BLTU
                        BrUn = 1;
                        if (BrLt) PCsel = 1;
                        else PCsel = 0;
                    end   
                    3'b111 : begin  //BGEU
                        BrUn = 1;
                        if (!BrLt) PCsel = 1;
                        else PCsel = 0 ;
                    end
                    default: PCsel = 0;
                endcase
                begin
                    imm_sel = 1;
                    RegWEn = 0;
                    Bsel = 1;
                    Asel = 1;
                    alu_control = add;
                    MemRW = 0;
                    //WBsel = 3; //dont care
                end
            end
         JAL_type       :   begin
                PCsel = 1;
                imm_sel = 1;
                RegWEn = 1;
                //branch dont care
                Bsel = 1;
                Asel = 1;
                alu_control = add;
                MemRW = 0;
                WBsel = 2;
            end
         JALR_type      :   begin
                PCsel = 1;
                imm_sel = 1;
                RegWEn = 1;
                //branch dont care
                Bsel = 1;
                Asel = 0;
                alu_control = add;
                MemRW = 0;
                WBsel = 2;
            end
         LUI            :   begin
                PCsel = 0;
                imm_sel = 1;
                RegWEn = 1;
                //branch dont care
                Bsel = 1;
                //Asel dont care
                alu_control = lui;
                MemRW = 0;
                WBsel = 1;
            end
         AUIPC         :   begin
                PCsel = 0;
                imm_sel = 1;
                RegWEn = 1;
                //branch dont care
                Bsel = 1;
                Asel = 1;
                alu_control = add;
                MemRW = 0;
                WBsel = 1;
            end 
         default        :   begin
                PCsel = 0;
                imm_sel = 0;
                RegWEn = 0;
                BrUn = 0;
                Bsel = 0;
                Asel = 0;
                WBsel = 1;
                MemRW = 0;
                alu_control = 0;
            end
         endcase
         
     end
endmodule
