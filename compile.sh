#!/bin/bash

read module_name

case $module_name in
    "adc_driver")
        iverilog -o sample_logic_tb.vvp sample_logic_tb.v sample_logic.v 
        vvp sample_logic_tb.vvp
        rm sample_logic_tb.vvp
        ;;
    "sample_logic")
        iverilog -o sample_logic_tb.vvp sample_logic/sample_logic_tb.v sample_logic/sample_logic.v 
        vvp sample_logic_tb.vvp
        rm sample_logic_tb.vvp
        ;;
    "controller")
        iverilog -o controller_tb.vvp controller/controller_tb.v controller/controller.v 
        vvp controller_tb.vvp
        rm controller_tb.vvp
        ;;
        
esac
