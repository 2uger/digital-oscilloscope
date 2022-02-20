#!/bin/bash

read module_name

case $module_name in
    "write_ptr")
        iverilog -o w_ptr_tb.vvp write_ptr.v write_ptr_tb.v
        vvp w_ptr_tb.vvp
        rm w_ptr_tb.vvp
        ;;
    "read_ptr")
        iverilog -o r_ptr_tb.vvp read_ptr.v read_ptr_tb.v
        vvp r_ptr_tb.vvp
        rm r_ptr_tb.vvp
        ;;
    "fifo")
        iverilog -o fifo_tb.vvp fifo_tb.v fifo.v write_ptr.v read_ptr.v fifo_ram.v sync_r2w_pointer.v sync_w2r_pointer.v
        vvp fifo_tb.vvp
        rm fifo_tb.vvp
        ;;
        
esac
