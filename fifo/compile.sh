iverilog -o fifo_tb.vvp fifo_tb.v fifo.v write_ptr.v read_ptr.v fifo_ram.v sync_pointer.v
vvp fifo_tb.vvp
rm fifo_tb.vvp
