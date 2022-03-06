#!/bin/bash

read module_name

case $module_name in
    "sample_logic")
        iverilog -o sample_logic_tb.vvp sample_logic_tb.v sample_logic.v 
        vvp sample_logic_tb.vvp
        rm sample_logic_tb.vvp
        ;;
        
esac
