module fifo_ram # (parameter DATA_SIZE=12,
                   parameter ADDR_SIZE=8)
                  (input clk_i,
                   input w_en_i,
                   input [ADDR_SIZE-1:0] w_addr_i,
                   input [DATA_SIZE-1:0] w_data,

                   input [ADDR_SIZE-1:0] r_addr_i,
                   output [DATA_SIZE-1:0] r_data_o);

    reg [DATA_SIZE-1:0] memory [(2**ADDR_SIZE)-1:0];

    integer i;
    always @ (posedge clk_i) begin
        if (w_en_i)
            memory[w_addr_i] <= w_data;
        //$display("Memory dump");
        //for (i = 0; i < (2 ** ADDR_SIZE); i = i + 1) begin
        //    $display("Addr: %h, data: %h", i, memory[i]);
        //end
        
    end

    assign r_data_o = memory[r_addr_i];
endmodule
