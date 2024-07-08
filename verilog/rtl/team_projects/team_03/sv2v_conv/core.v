module core (
	clock,
	reset,
	en,
	CPU_DAT_O,
	BUSY_O,
	CPU_DAT_I,
	ADR_I,
	SEL_I,
	WRITE_I,
	READ_I
);
	input wire clock;
	input wire reset;
	input wire en;
	input wire [31:0] CPU_DAT_O;
	input wire BUSY_O;
	output wire [31:0] CPU_DAT_I;
	output wire [31:0] ADR_I;
	output wire [3:0] SEL_I;
	output wire WRITE_I;
	output wire READ_I;
	wire [2:0] i_type;
	wire [16:0] instruction;
	wire [3:0] alu_op;
	wire [2:0] branch_type;
	wire reg_write_en;
	wire alu_mux_en;
	wire store_byte;
	wire mem_to_reg;
	wire pc_add_write_value;
	wire load_byte;
	wire read_next_pc;
	wire write_mem;
	wire read_mem;
	wire [31:0] inst;
	wire [31:0] imm_gen;
	wire [4:0] regA;
	wire [4:0] regB;
	wire [4:0] rd;
	wire [31:0] register_write_data;
	wire [31:0] regA_data;
	wire [31:0] regB_data;
	wire [31:0] program_counter;
	wire [31:0] program_counter_out;
	wire branch_choice;
	wire [31:0] result;
	wire Z;
	wire N;
	wire C;
	wire V;
	wire b_out;
	wire [31:0] data_to_write;
	wire [31:0] data_read;
	wire pc_en;
	wire slt;
	wire u;
	wire i_ready;
	wire d_ready;
	request_unit ru(
		.en(en),
		.clk(clock),
		.nRST(reset),
		.D_fetch(read_mem),
		.D_write(write_mem),
		.I_fetch(1'b1),
		.data_adr(result),
		.instr_adr(program_counter),
		.writedata(data_to_write),
		.i_done(i_ready),
		.d_done(d_ready),
		.instr(inst),
		.data(data_read),
		.busy_o(BUSY_O),
		.cpu_dat_o(CPU_DAT_O),
		.write_i(WRITE_I),
		.read_i(READ_I),
		.adr_i(ADR_I),
		.cpu_dat_i(CPU_DAT_I),
		.sel_i(SEL_I)
	);
	wire cpu_clock;
	decoder decoder(
		.inst(inst),
		.rs1(regA),
		.rs2(regB),
		.rd(rd),
		.type_out(i_type),
		.control_out(instruction)
	);
	control_logic_unit control_logic(
		.i_type(i_type),
		.instruction(instruction),
		.alu_op(alu_op),
		.branch_type(branch_type),
		.reg_write_en(reg_write_en),
		.alu_mux_en(alu_mux_en),
		.store_byte(store_byte),
		.mem_to_reg(mem_to_reg),
		.pc_add_write_value(pc_add_write_value),
		.load_byte(load_byte),
		.read_next_pc(read_next_pc),
		.write_mem(write_mem),
		.read_mem(read_mem),
		.slt(slt),
		.u(u)
	);
	branch_logic branch_logic(
		.branch_type(branch_type),
		.ALU_neg_flag(N),
		.ALU_overflow_flag(V),
		.ALU_zero_flag(Z),
		.b_out(branch_choice)
	);
	pc pc(
		.en(en),
		.pc_out(program_counter),
		.pc_add_out(program_counter_out),
		.generated_immediate(imm_gen),
		.branch_decision(branch_choice),
		.pc_write_value(regA_data),
		.pc_add_write_value(pc_add_write_value),
		.in_en(pc_en),
		.auipc_in(alu_mux_en),
		.clock(clock),
		.reset(reset)
	);
	register_file register_file(
		.en(en),
		.clk(clock),
		.rst(reset),
		.regA_address(regA),
		.regB_address(regB),
		.rd_address(rd),
		.register_write_en(reg_write_en),
		.register_write_data(register_write_data),
		.regA_data(regA_data),
		.regB_data(regB_data)
	);
	writeback writeback(
		.memory_value(data_read),
		.ALU_value(result),
		.pc_4_value(program_counter_out),
		.mem_to_reg(mem_to_reg),
		.load_byte(load_byte),
		.read_pc_4(1'b0),
		.register_write(register_write_data),
		.slt(slt),
		.ALU_neg_flag(N),
		.ALU_overflow_flag(V)
	);
	byte_demux byte_demux(
		.reg_b(regB_data),
		.store_byte_en(store_byte),
		.b_out(data_to_write)
	);
	ALU ALU(
		.srda(regA_data),
		.fop(alu_op),
		.result(result),
		.Z(Z),
		.N(N),
		.V(V),
		.imm_gen(imm_gen),
		.srdb(regB_data),
		.alu_mux_en(alu_mux_en),
		.rda_u(regA_data),
		.rdb_u(regB_data),
		.u(u)
	);
	imm_generator imm_generator(
		.inst(inst),
		.type_i(i_type),
		.imm_gen(imm_gen)
	);
endmodule
