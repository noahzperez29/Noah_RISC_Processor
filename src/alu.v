module alu (
    input wire [31:0] operand_a,
    input wire [31:0] operand_b,
    input wire [3:0] alu_control,
    output wire zero_flag,
    output reg [31:0] result
);

// alu_control codes
// 4'b0000 = alu_add
// 4'b0001 = alu_sub
// 4'b0010 = alu_and
// 4'b0011 = alu_or
// 4'b0100 = alu_xor
// 4'b0101 = alu_logicleft
// 4'b0110 = alu_logicright
// 4'b0111 = alu_arithright
// 4'b1000 = alu_slt

always @(*) begin
    case (alu_control)
        4'b0000: result = operand_a + operand_b;
        4'b0001: result = operand_a - operand_b;
        4'b0010: result = operand_a & operand_b;
        4'b0011: result = operand_a | operand_b;
        4'b0100: result = operand_a ^ operand_b;
        4'b0101: result = operand_a << operand_b[4:0];
        4'b0110: result = operand_a >> operand_b[4:0];
        4'b0111: result = $signed(operand_a) >>> operand_b[4:0];
        4'b1000: result = $signed(operand_a) < $signed(operand_b) ? 32'd1 : 32'd0;
        default: result = 32'd0;
    endcase
end

assign zero_flag = (result == 0);

endmodule


