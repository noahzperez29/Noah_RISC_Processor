![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# RISC Processor Project

### **Objective**
I designed a single-cycle RISC-V processor core implementing a subset of the RV32I instruction set.

### **Logic**
The core fetches, decodes, and executes one instruction per clock cycle, using a register file, ALU,
control unit, and separate instruction/data memories. Verified instructions include addi, add, jal,
lw, sw, sub, and beq. Since the chip only exposes 8 input and 8 output pins, the internal 32-bit
program counter is exposed externally through a byte-select multiplexer, allowing it to be
reconstructed one byte at a time to confirm the core is fetching and executing correctly.

