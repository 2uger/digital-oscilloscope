module fifo_ram 
    #(parameter DATA_SIZE=12,
      parameter ADDR_SIZE=8)
    (input w_clk_i,
     input w_clk_en_i,
     input w_addr_i,
     input [DATA_SIZE-1:0] w_data,

     input r_addr_i,
     output r_data_o);

    reg [DATA_SIZE-1:0] memory [2**ADDR_SIZE-1:0];

    always @ (posedge w_clk_i) begin
        if (w_clk_en_i)
            memory[w_addr_i] <= w_data;
    end

    assign r_data_o = memory[r_addr_i];
endmodule
