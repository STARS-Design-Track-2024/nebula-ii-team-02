// $Id: $
// File name:   team_02.sv
// Created:     07/03/2024
// Author:      Wayne Hsieh
// Description: <Module Description>

`default_nettype none

module team_02 (
    // HW
    input wire clk, nrst,
    
    input wire en, //This signal is an enable signal for your chip. Your design should disable if this is low.
    input wire [31:0] start_addr,

    // Logic Analyzer - Grant access to all 128 LA
    input wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input wire [127:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output wire [33:0] gpio_out, // Breakout Board Pins
    output wire [33:0] gpio_oeb, // Active Low Output Enable

    output wire [31:0] ADR_O,
    output wire [31:0] DAT_O,
    output wire [3:0]  SEL_O,
    output wire        WE_O,
    output wire        STB_O,
    output wire        CYC_O,
    input wire [31:0]  DAT_I,
    input wire         ACK_I

    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    assign gpio_out = 34'b0; //Inputs, but set low anyways
    assign gpio_oeb = '1;//All 1's inputs
    /*
    * Place code and sub-module instantiations here.
    cpu and wish bone manager
    */
    wire [31:0] ramstore, ramaddr, ramload;
    wire Ren, Wen, busy_o;

    t02_top top (.clk(clk), .nrst(nrst), .ramaddr(ramaddr), .ramstore(ramstore), .Ren(Ren), .Wen(Wen), .ramload(ramload), .busy_o(busy_o), .enable(en), .start_addr(start_addr));
    // add start_addr 
    // make sure all signals are connected
    t02_wishbone_manager wb(.CLK(clk), .nRST(nrst), 
    .CPU_DAT_I(ramstore), .ADR_I(ramaddr), .SEL_I(4'hF), .WRITE_I(Wen), .READ_I(Ren),
    .CPU_DAT_O(ramload), .BUSY_O(busy_o), 
    .ADR_O(ADR_O), .DAT_O(DAT_O), .SEL_O(SEL_O), .WE_O(WE_O), .STB_O(STB_O), .CYC_O(CYC_O),
    .DAT_I(DAT_I), .ACK_I(ACK_I));


// logic zero, negative, regWrite, aluSrc, d_ready, i_ready, memWrite, memRead;
//  logic [3:0] aluOP;
//  logic [4:0] regsel1, regsel2, w_reg;
//  logic [5:0] cuOP;
//  logic [19:0] imm;
//  logic [31:0] memload, aluIn, aluOut, immOut, pc, writeData, regData1, regData2, instruction;



//t02_mux aluMux(.in1(immOut), .in2(regData2), .en(aluSrc), .out(aluIn));

//t02_alu arith(.aluOP(aluOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

//t02_register_file DUT(.clk(clk), .nRST(nrst), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), 
//.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

//t02_control controller (.cuOP(cuOP), .instruction(instruction), 
//.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
//.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

//t02_pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut), .enable(enable), .start_addr(start_addr));

//t02_writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

//t02_signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));

//t02_request ru(.CLK(clk), .nRST(nrst), .imemload(instruction), .imemaddr(pc), .dmmaddr(aluOut), .dmmstore(regData2), .ramaddr(ramaddr), .ramload(ramload), .ramstore(ramstore), 
//.cuOP(cuOP), .Wen(Wen), .busy_o(busy_o), .dmmload(memload), .i_ready(i_ready), .d_ready(d_ready),.Ren(Ren), .en(enable));

// t02_edgeDetector edg2(.clk(clk), .nRst_i(nrst), .button_i(~keyStrobe), .button_p(enData));
// t02_keypad pad (.clk(clk), .rst(nrst), .receive_ready(keyStrobe), .data_received(halfData), .read_row(read_row), .scan_col(scan_col));
// t02_lcd1602 lcd (.clk(clk), .rst(nrst), .row_1(row1), .row_2(row2), .lcd_en(lcd_en), .lcd_rw(lcd_rw), .lcd_rs(lcd_rs), .lcd_data(lcd_data));

//ru_ram rram (.clk(clk), .nRst(nrst), .write_enable(write_enable), .addr(addr), .data_in(datain), .data_out(dataout), .busy(busy_o));
//ram ra(.clk(clk), .nRst(nrst), .write_enable(memWrite), .read_enable(1), .address_DM(aluOut[5:0]), .address_IM(pc[5:0]), .data_in(regData2), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready), .CUOp(cuOP));
//assign instruction_out = instruction;


endmodule