`timescale 1ns / 1ps

module mux4 (
    input [31:0] dmem,alu,pc_4,
    input [1:0] WBsel,
    output reg [31:0] wb
);
    always @(*) begin
       if (WBsel == 0) wb = dmem;
       else if (WBsel == 1) wb = alu;
       else if (WBsel == 2) wb = pc_4;
       else wb = 32'bx;
    end
    
endmodule
