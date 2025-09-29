# ALU_cp2

Name: Devon Sun
NetID: ys507

Project: Gate-level 32-bit ALU (ADD, SUB, AND, OR, SLL, SRA) with `isNotEqual`, `isLessThan`, `overflow`.

Design summary: Modular, gate-primitive implementation using `fa`/`rc4` blocks for the adder, generate loops for bitwise logic, and a 5-stage barrel shifter; top-level `alu.v` masks and merges per-op results.

Modules:

`fa.v` — 1-bit full adder (sum, cout).
 `rc4.v` — 4-bit adder block producing sum, P/G.
 `add32.v` — 32-bit adder built from eight `rc4` blocks (cin input).
 `sub32.v` — subtractor: invert B + `add32` with cin=1.
 `and32.v`, `or32.v` — 32 primitive bitwise gates (generate).
 `barrel_shifter_32.v` — staged SLL / SRA using 1-bit muxes.
 `balanced_or32.v` — balanced OR tree for `isNotEqual`.
 `opcode_decoder_5.v` — gate-only opcode decoder.
 `alu.v` — top-level assembler producing outputs and flags.

Known issues: Integration typos (e.g., port-name mismatches, one `b31` typo) were fixed; current testbench passes basic functional checks.

How to run: add all `.v` files to your simulator and run `alu_tb.v` (e.g., `iverilog *.v && vvp a.out`).
