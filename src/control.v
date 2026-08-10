module control (
    input wire [31:0] instruction,
    output reg [3:0] alu_control,
    output reg reg_write,
    output reg mem_write,
    output reg mem_read,
    output reg mem_to_reg,
    output reg alu_src,
    output reg branch,
    output reg jump
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];

always @(*) begin
    case (opcode)
        7'b0110011: begin
            reg_write = 1'b1;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            alu_src = 1'b0;
            branch = 1'b0;
            jump = 1'b0;

            case ({funct7, funct3})
                10'b0000000000: alu_control = 4'b0000; // add
                10'b0100000000: alu_control = 4'b0001; // sub
                10'b0000000111: alu_control = 4'b0010; // and
                10'b0000000110: alu_control = 4'b0011; // or
                10'b0000000100: alu_control = 4'b0100; // xor
                10'b0000000001: alu_control = 4'b0101; // sll
                10'b0000000101: alu_control = 4'b0110; // srl
                10'b0100000101: alu_control = 4'b0111; // sra
                10'b0000000010: alu_control = 4'b1000; // slt
                default: alu_control = 4'b0000;
            endcase
        end
        7'b0010011: begin
            reg_write = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            alu_src = 1'b1;
            alu_control = 4'b0000;
            branch = 1'b0;
            jump = 1'b0;
        end
        7'b0000011: begin
            reg_write = 1'b1;
            mem_read  = 1'b1;
            mem_write = 1'b0;
            mem_to_reg = 1'b1;
            alu_src = 1'b1;
            alu_control = 4'b0000;
            branch = 1'b0;
            jump = 1'b0;
        end
        7'b0100011: begin
            reg_write = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b1;
            mem_to_reg = 1'b0;
            alu_src = 1'b1;
            alu_control = 4'b0000;
            branch = 1'b0;
            jump = 1'b0;
        end
        7'b1100011: begin
            reg_write  = 1'b0;
            mem_read   = 1'b0;
            mem_write  = 1'b0;
            mem_to_reg = 1'b0;
            alu_src    = 1'b0;
            branch     = 1'b1;
            jump       = 1'b0;

            case (funct3)
                3'b000: alu_control = 4'b0001;
                3'b100: alu_control = 4'b1000;
                default: alu_control = 4'b0000;
            endcase
        end
        7'b1101111: begin
            reg_write   = 1'b1;
            mem_read    = 1'b0;
            mem_write   = 1'b0;
            mem_to_reg  = 1'b0;
            alu_src     = 1'b0;
            alu_control = 4'b0000;
            branch      = 1'b0;
            jump        = 1'b1;
        end
        default: begin
            reg_write   = 1'b0;
            mem_read    = 1'b0;
            mem_write   = 1'b0;
            mem_to_reg  = 1'b0;
            alu_src     = 1'b0;
            alu_control = 4'b0000;
            branch      = 1'b0;
            jump        = 1'b0;
        end
    endcase
end

endmodule
