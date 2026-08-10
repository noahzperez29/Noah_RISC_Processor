module risc_core (
    input wire clk,
    input wire rst,
    output wire [31:0] debug_pc
);

assign debug_pc = pc;

    reg [31:0] pc;

    wire [31:0] instruction;
    imem imem_inst (
        .addr(pc),
        .instruction(instruction)
    );

    wire [3:0] alu_control;
    wire reg_write, mem_write, mem_read, mem_to_reg, alu_src, branch, jump;
    wire [31:0] imm;

    control control_inst (
        .instruction(instruction),
        .alu_control(alu_control),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump)
    );

    immgen immgen_inst (
        .instruction(instruction),
        .imm(imm)
    );

    wire [4:0] rs1, rs2, rd;
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    wire [31:0] read_data1, read_data2;
    wire [31:0] write_back_data;

    regfile regfile_inst (
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    wire [31:0] alu_operand_b;
    assign alu_operand_b = alu_src ? imm : read_data2;

    wire [31:0] alu_result;
    wire zero_flag;

    alu alu_inst (
        .operand_a(read_data1),
        .operand_b(alu_operand_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero_flag(zero_flag)
    );

    wire [31:0] mem_read_data;

    dmem dmem_inst (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(alu_result),
        .write_data(read_data2),
        .read_data(mem_read_data)
    );

    assign write_back_data = jump ? (pc + 32'd4) : (mem_to_reg ? mem_read_data : alu_result);

    wire branch_taken;
    assign branch_taken = branch & zero_flag;

    always @(posedge clk) begin
        if (rst)
            pc <= 32'd0;
        else if (jump)
            pc <= pc + imm;
        else if (branch_taken)
            pc <= pc + imm;
        else
            pc <= pc + 32'd4;
    end

endmodule
