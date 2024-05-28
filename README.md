# Project Description
- This Project is simply a Design of pipeline MIPS processor written in Verilog with
handling of Data hazards and forwarding process to achieve the maximum
performance in units of clock cycles.
- Also, this Design Code is written in simple way without any complexities. 
Every single module is written in a separate file then they are integrated in the top file using hierarchical Design.
- The Design supports set of instructions as follow :
 ### 1- R-type instruction such as        : add - sub - AND - OR - NOR - slt
 ### 2- load and store instruction        : LW - SW
 ### 3- conditional branch instructions   : branch-if-equal (beq)
 ### 4- unconditional branch instructions : Jump (J)

# The Data path (Block Digram)
![pipeline_digram3](https://github.com/Abdulrahmmann18/Pipelined_MIPS32/assets/144833244/3cba9521-da56-4a01-8b18-a1f67ffedba5)
![pipeline_digram](https://github.com/Abdulrahmmann18/Pipelined_MIPS32/assets/144833244/1bb504aa-c8cd-477a-88bd-4300ff7fa9c9)

# The project phases
## Phase1 : Implementation of single cycle MIPS 
- The single cycle MIPS processor was implemented and the modules of the single cycle were integrated, after that i used a Test-bench to test the functionality 
and it totally worked after some bugs and issues which were of course solved and
cured.
- you also can checkout the single cycle MIPS repo from here : https://github.com/Abdulrahmmann18/single_cycle_MIPS32.

## Phase2 : Implementation of Pipelined MIPS
The work is continued to implement the pipeline MIPS processor by

1- modifying some modules from the single cycle modules as needed.

2- Adding new modules related to the pipeline data path such as: 
- Forwarding unit 
- Load use data hazard unit
- Early Branch prediction unit to predict the branch is taken or not in the decode stage
- The pipeline registers

# The wave form from modelsim
![waveform](https://github.com/Abdulrahmmann18/Pipelined_MIPS32/assets/144833244/53ce634b-92c5-468f-b536-ddbac15a782f)

# The program executed
![program_excuted](https://github.com/Abdulrahmmann18/Pipelined_MIPS32/assets/144833244/c6d52ea9-80a0-4d27-ab69-dd8f97011673)
