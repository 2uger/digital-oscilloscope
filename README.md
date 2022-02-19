## Digital oscilloscope

FPGA based digital oscilloscope</br>
Parts:
### ADC driver
### Asynchronous FIFO
Consists from:
* Memory</br>
    Actually it's just simple RAM with 2 ports for writing and reading.
* Read and Write pointers</br>
    This pointers saves state about free and empty cells in memory.<br>
    Write pointer generate address for next free place and signal about is fifo FULL.<br>
    Read pointer generate address for next cell to read and signal about is fifo EMPTY.<br>
    Because of synchronisation problems between two clock domains,<br>
    we use Gray code for counting instead binary one.<br>
    It change only one bit at time, means chances for data synchronisation problems is much lower.<br>
* Synchronisers<br>
  Basic double flip-flop to synchronise signal between read and write pointers


