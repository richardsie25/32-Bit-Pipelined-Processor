`timescale 1ns / 1ps


module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    
    
// write your code here
    wire [9:0] branch_output;
    wire [9:0] pc_next;
    wire [9:0] temp_pc_plus4;
    reg [9:0] pc;
    
    
    always @ (posedge clk or posedge reset)
    begin
        if(reset)
            pc <= 10'b0;
        else if(en)
            pc <= pc_next;
    end
    
    assign temp_pc_plus4 = pc + 10'b0000000100;
    assign pc_plus4 = temp_pc_plus4;
    
    mux2 #(.mux_width(10)) branch_mux
    (   .a(temp_pc_plus4),
        .b(branch_address),
        .sel(branch_taken),
        .y(branch_output));
     
    mux2 #(.mux_width(10)) jump_mux
    (   .a(branch_output),
        .b(jump_address),
        .sel(jump),
        .y(pc_next));
    
    instruction_mem inst_mem (
        .read_addr(pc),
        .data(instr));
           
endmodule
