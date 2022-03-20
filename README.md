## Digital oscilloscope

### Sources:
[Ready to build oscilloscope](https://www.instructables.com/DPScope-Build-Your-Own-USBPC-Based-Oscilloscope/)
[Example of oscilloscope written in Verilog](https://github.com/Oguzhanka/Digital-Signal-Oscilloscope)
FPGA based digital oscilloscope</br>
Parts:
### ADC driver
Module to control ADC MCP3004/3008 and receive data from it</br>
Learn more in sources
### Asynchronous FIFO
Consists from:
* Memory</br>
    Actually it's just simple RAM with 2 ports for writing and reading.
* Read and Write pointers</br>
    This pointers saves state about free and empty cells in memory.<br>
    Write pointer generate address for next free place and signal about is fifo FULL.<br>
    Read pointer generate address for next cell to read and signal about is fifo EMPTY.<br>
    Because of synchronisation problems between two clock domains,<br>
    we need synchronizer between read and write pointers.<br>
* Synchronisers<br>
  Basic double flip-flop to synchronise signal between read and write pointers
### Controller
Receive commands from PC, send signals to ADC driver and Sample Logic modules to start acquiring data
### Sample logic
Capture data from ADC driver to know when to TRIGGER and send signal about writing data into FIFO

