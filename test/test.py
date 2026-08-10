# SPDX-FileCopyrightText: © 2026 Noah Perez
# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer


async def read_debug_pc(dut):
    """Reconstruct the 32-bit debug_pc by cycling ui_in[1:0] through the byte selector."""
    pc = 0
    for byte_index in range(4):
        dut.ui_in.value = byte_index
        await Timer(5, unit="ns")
        pc |= (int(dut.uo_out.value) & 0xFF) << (byte_index * 8)
    return pc


@cocotb.test()
async def test_reset_and_pc_increment(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(clock.start())

    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    pc = await read_debug_pc(dut)
    dut._log.info(f"PC after reset: {pc}")
    assert pc == 0, f"Expected PC == 0 after reset, got {pc}"

    await ClockCycles(dut.clk, 1)
    pc_after_one = await read_debug_pc(dut)
    dut._log.info(f"PC after 1 cycle: {pc_after_one}")
    assert pc_after_one != pc, "PC did not change after one clock cycle — core may be stalled"

    seen_pcs = {pc, pc_after_one}
    for _ in range(8):
        await ClockCycles(dut.clk, 1)
        current_pc = await read_debug_pc(dut)
        seen_pcs.add(current_pc)

    dut._log.info(f"PC values observed: {sorted(seen_pcs)}")
    assert len(seen_pcs) > 1, "PC appears stuck — core is not progressing through the program"
