module imem (
    input  wire [31:0] addr,
    output wire [31:0] instruction
);
    reg [31:0] memory [8];
    assign instruction = memory[addr[4:2]];
    initial begin
        $readmemh("../src/program.hex", memory);
    end
endmodule
