module dmem (
    input  wire        clk,
    input  wire        mem_write,
    input  wire        mem_read,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] memory [8];
    assign read_data = memory[addr[4:2]];
    always @(posedge clk) begin
        if (mem_write) begin
            memory[addr[4:2]] <= write_data;
        end
    end
endmodule
