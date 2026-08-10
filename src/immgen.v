module immgen (
    input  wire [31:0] instruction,
    output reg  [31:0] imm
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011, 7'b0000011: begin
                // I-type (addi, lw): imm[11:0] = instruction[31:20]
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0100011: begin
                // S-type (sw): imm[11:5]=instruction[31:25], imm[4:0]=instruction[11:7]
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            7'b1100011: begin
                // B-type (beq, blt): imm[12|10:5|4:1|11], scaled by 2 (branch offsets are even)
                imm = {{19{instruction[31]}}, instruction[31], instruction[7],
                       instruction[30:25], instruction[11:8], 1'b0};
            end
            7'b1101111: begin
                // J-type (jal): imm[20|10:1|11|19:12], scaled by 2
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                       instruction[20], instruction[30:21], 1'b0};
            end
            default: imm = 32'd0;
        endcase
    end

endmodule


