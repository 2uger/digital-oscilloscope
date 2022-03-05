#!/bin/bash

read module_name

case $module_name in
    "fifo")
        iverilog -o fifo_tb.vvp fifo_tb.v fifo.v 
        vvp fifo_tb.vvp
        rm fifo_tb.vvp
        ;;
        
esac
