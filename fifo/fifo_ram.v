module fifo_ram 
    #(parameter DATA_WIDTH=12,
      parameter MEM_SIZE=256)
    (input w_clk_i,
     input w_clk_en_i,
     input w_addr_i,
     input [0:DATA_WIDTH-1] w_data,

     input r_addr_i,
     output r_data_o);

    reg [0:DATA_WIDTH-1] memory [0:MEM_SIZE];

    always @ (posedge w_clk_i) begin
        if (w_clk_en_i)
            memory[w_addr_i] <= w_data;
    end

    assign r_data_o = memory[r_addr_i];
endmodule
