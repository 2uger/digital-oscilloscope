/* High level module of FIFO */
module fifo # (parameter DATA_SIZE=12,
               parameter ADDR_SIZE=8)
              (input w_clk_i,
               input w_rst_i,

               input w_inc_i,
               input r_inc_i,

               input [DATA_SIZE-1:0] w_data_i,
               output [DATA_SIZE-1:0] r_data_o,

               output w_full_o,
               output r_empty_o);
    
    wire [ADDR_SIZE:0] wr_ptr_2;
    wire [ADDR_SIZE:0] w_ptr;
    wire [ADDR_SIZE-1:0] w_addr;

    write_pointer #(.ADDR_SIZE(ADDR_SIZE))
                    wp (.clk_i(w_clk_i),
                        .rst_i(w_rst_i),
                        .rw_ptr_i(wr_ptr_2),
                        .inc_i(w_inc_i),
                        .ptr_o(w_ptr),
                        .addr_o(w_addr),
                        .fifo_full_o(w_full_0));
endmodule
