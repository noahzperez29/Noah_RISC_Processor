module regfile (
    input wire clk,
    input wire rst,
    input wire reg_write,
    input wire [4:0] read_reg1,
    input wire [4:0] read_reg2,
    input wire [4:0] write_reg,
    input wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

reg [31:0] registers [32];

assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 : registers[read_reg1];
assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 : registers[read_reg2];

integer i;

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'd0;
        end
    end else if (reg_write && write_reg != 5'd0) begin
        registers[write_reg] <= write_data;
    end
end

endmodule
