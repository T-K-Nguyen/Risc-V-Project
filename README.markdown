## Overview
This project involves the design and simulation of a simple RISC (Reduced Instruction Set Computer) CPU, implemented as part of the VLSI Design course (CO3098) at Ho Chi Minh City University of Technology. The CPU is designed with a minimal instruction set and operates synchronously with a clock signal, featuring a 3-bit opcode and 5-bit operands, supporting a 32x8-bit memory for both program and data storage. The design follows the Von Neumann architecture and is implemented using Verilog, with synthesis and simulation performed using industry-standard tools.

The project was carried out by:
- **Nguyen Kim Thuan** 
- **Phan Huy Trung** 

**Course**: CO3098 - VLSI Design  
**Semester**: HK242  
**Date**: May 2025

## Features
The RISC CPU supports the following instructions:
- **HLT**: Halts the CPU operation.
- **SKZ**: Skips the next instruction if the accumulator is zero.
- **ADD**: Adds data from memory to the accumulator.
- **AND**: Performs a bitwise AND operation between the accumulator and memory data.
- **XOR**: Performs a bitwise XOR operation between the accumulator and memory data.
- **LDA**: Loads data from memory into the accumulator.
- **STO**: Stores the accumulator value into memory.
- **JMP**: Jumps to a specified memory address.

### Key Functionalities
- Fetches and decodes instructions from a 32x8-bit memory.
- Executes arithmetic and logical operations via the Arithmetic Logic Unit (ALU).
- Manages control flow with unconditional jumps and conditional skips.
- Interacts with a 32x8-bit memory for read/write operations.
- Operates synchronously with a clock signal and supports a reset mechanism.

## Architecture
The CPU is designed based on the Von Neumann architecture, with a shared memory for instructions and data. The main components include:
- **Control Unit**: Decodes instructions and manages the Finite State Machine (FSM) with 8 states (INST_ADDR, INST_FETCH, INST_LOAD, OP_ADDR, OP_FETCH, ALU_OP, STORE, HALT).
- **Arithmetic Logic Unit (ALU)**: Performs arithmetic (ADD) and logical operations (AND, XOR, LDA).
- **Registers**: Includes the Accumulator, Instruction Register (IR), and Data Register for temporary storage.
- **Program Counter (PC)**: Manages the address of the next instruction.
- **Memory**: A 32x8-bit memory for storing both program instructions and data.
- **Address Multiplexer**: Selects between PC and IR addresses for memory access.
- **Data and Control Buses**: Facilitate communication between components.

The instruction execution follows a fetch-decode-execute cycle, with the FSM ensuring proper sequencing of operations.

## Tools Used
- **Cadence Genus**: For synthesis of the Verilog design.
- **Icarus Verilog**: For hardware description and simulation.
- **GTKWaves**: For waveform visualization and functional verification.
- **VSCode**: For code editing and synthesis management.
- **MobaXterm**: For running synthesis scripts (with initial issues resolved during the project).

## Directory Structure
```
RISC_CPU/
├── src/
│   ├── ALU.v
│   ├── Address_mux.v
│   ├── Controller.v
│   ├── Memory.v
│   ├── Program_Counter.v
│   ├── Register.v
│   ├── RISC_CPU.v
├── testbench/
│   ├── tb_ALU.v
│   ├── tb_Address_mux.v
│   ├── tb_Controller.v
│   ├── tb_Memory.v
│   ├── tb_Program_Counter.v
│   ├── tb_Register.v
│   ├── tb_RISC_CPU.v
├── scripts/
│   ├── synthesis.tcl
├── README.md
```

## Setup and Installation
1. **Install Required Tools**:
   - Install Cadence Genus for synthesis.
   - Install Icarus Verilog for simulation.
   - Install GTKWaves for waveform visualization.
   - Install VSCode for code editing.
   - (Optional) Install MobaXterm for running synthesis scripts on a remote server.

2. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd RISC_CPU
   ```

3. **Compile Verilog Files**:
   Use Icarus Verilog to compile the source and testbench files:
   ```bash
   iverilog -o risc_cpu_sim src/*.v testbench/tb_RISC_CPU.v
   ```

4. **Run Simulation**:
   Execute the compiled simulation:
   ```bash
   vvp risc_cpu_sim
   ```

5. **View Waveforms**:
   Open the generated VCD file in GTKWaves:
   ```bash
   gtkwave dump.vcd
   ```

6. **Run Synthesis**:
   Use Cadence Genus with the provided synthesis script:
   ```bash
   genus -f scripts/synthesis.tcl
   ```

## Simulation Results
The design was thoroughly tested using testbenches for each module (ALU, Address Multiplexer, Controller, Memory, Program Counter, Register, and the top-level RISC CPU). Key observations:
- **ALU**: Correctly performs ADD and LDA operations, with proper handling of the `is_zero` signal.
- **Address Multiplexer**: Accurately selects between PC and IR addresses based on the `sel` signal.
- **Controller**: Successfully manages the 8-state FSM, with correct transitions and control signals (`sel`, `rd`, `ld_ir`, `halt`, `inc_pc`, `ld_ac`, `ld_pc`, `wr`, `data_e`).
- **Program Counter**: Handles increment, jump, and skip operations correctly, verified through testbench results.
- **Register**: Properly latches memory data on clock edges and resets to zero when required.
- **Memory**: Supports read/write operations with accurate address handling.
- **Synthesis**: The Genus synthesis results show no timing violations, with a critical path slack of 872.1 in the basic case and positive slacks in the low-power case, indicating stable timing performance.
<p align="center">
  <img src="Screenshots/genus.png" width="700"/>
  <br/>
  <i>Figure: Genus Synthesis result</i>
</p>
- **LEC (Logic Equivalence Checking)**: All 322 compared points (16 Primary Outputs, 306 D Flip-Flops) were equivalent, confirming the synthesized netlist matches the original design.
<p align="center">
  <img src="Screenshots/netlist.png" width="700"/>
  <br/>
  <i>Figure: Netlist Output</i>
</p>

## Challenges and Solutions
- **Synthesis Issues**: Initial synthesis runs in MobaXterm resulted in "No paths" errors. These were resolved by adjusting the synthesis scripts and constraints to ensure proper timing analysis.
- **Timing Optimization**: The design was optimized for both basic and low-power scenarios, with techniques like power gating applied in the low-power case to reduce energy consumption.

## Future Improvements
- **Wider Data Bus**: Expand the bus width from 8 bits to 16 or 32 bits for enhanced performance.
- **Peripheral Integration**: Add support for peripherals like UART, LED, 7-segment displays, GPIO, or LCD using I2C protocol.
- **Advanced Optimizations**: Incorporate cache, pipelining, or multi-threading for improved performance.
- **Porting to FPGA/ASIC**: Implement the design on an FPGA or ASIC for real-world testing.

## Conclusion
This project successfully demonstrates the design and simulation of a simple RISC CPU based on the Von Neumann architecture. The implementation in Verilog, combined with rigorous simulation and synthesis, validates the functionality and stability of the design. The project serves as a foundation for understanding CPU operations and provides a platform for future enhancements in performance and functionality.

## References
1. L. Poli, S. Saha, X. Zhai, and K. D. Medonald-Maier, "Design and Implementation of a RISC V Processor on FPGA," *2021 17th International Conference on Mobility, Sensing and Networking (MSN)*, Exeter, United Kingdom, 2021, pp. 161-166, doi: 10.1109/MSN53354.2021.00037.
