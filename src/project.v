/*
 * Copyright (c) 2026 Noah Perez
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_noahzperez29_riscv_core (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [31:0] debug_pc;
  wire        rst;

  // risc_core uses active-high reset; TT gives us active-low
  assign rst = ~rst_n;

  risc_core risc_core_inst (
      .clk(clk),
      .rst(rst),
      .debug_pc(debug_pc)
  );

  // ui_in[1:0] selects which byte of debug_pc to expose on uo_out
  reg [7:0] pc_byte;
  always @(*) begin
    case (ui_in[1:0])
      2'd0: pc_byte = debug_pc[7:0];
      2'd1: pc_byte = debug_pc[15:8];
      2'd2: pc_byte = debug_pc[23:16];
      2'd3: pc_byte = debug_pc[31:24];
    endcase
  end

  assign uo_out  = pc_byte;
  assign uio_out = 8'd0;
  assign uio_oe  = 8'd0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:2], uio_in, 1'b0};

endmodule
