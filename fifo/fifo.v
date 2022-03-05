/* High level module of FIFO */
module fifo # (parameter DATA_SIZE=12,
               parameter ADDR_SIZE=8)
              (input w_clk_i, // write clock
               input w_rst_i,

               input r_clk_i, // read clock
               input r_rst_i,

               input w_inc_i, // write enable
               input r_inc_i, // read enable

               input [DATA_SIZE-1:0] w_data_i,
               output [DATA_SIZE-1:0] r_data_o,

               output w_full_o,
               output r_empty_o);
    
    wire [ADDR_SIZE-1:0] wr_ptr_2;
    wire [ADDR_SIZE-1:0] w_ptr;
    wire [ADDR_SIZE-1:0] w_addr;

    write_ptr #(.ADDR_SIZE(ADDR_SIZE))
        wp (.clk_i(w_clk_i),
            .rst_i(w_rst_i),
            .wr_ptr_2_i(wr_ptr_2),
            .inc_i(w_inc_i),
            .ptr_o(w_ptr),
            .addr_o(w_addr),
            .fifo_full_o(w_full_o));

    wire [ADDR_SIZE-1:0] rw_ptr_2;
    wire [ADDR_SIZE-1:0] r_ptr;
    wire [ADDR_SIZE-1:0] r_addr;

    read_ptr #(.ADDR_SIZE(ADDR_SIZE))
        rp (.clk_i(r_clk_i),
            .rst_i(w_rst_i),
            .rw_ptr_2_i(rw_ptr_2),
            .inc_i(r_inc_i),
            .ptr_o(r_ptr),
            .addr_o(r_addr),
            .fifo_empty_o(r_empty_o));

    fifo_ram #(.DATA_SIZE(DATA_SIZE),
               .ADDR_SIZE(ADDR_SIZE))
        ram (.clk_i(w_clk_i),
             .w_en_i(w_inc_i),
             .w_addr_i(w_addr),
             .w_data(w_data_i),
             .r_addr_i(r_addr),
             .r_data_o(r_data_o));

    sync_pointer #(.ADDR_SIZE(ADDR_SIZE))
        sync_r2w (.clk_i(w_clk_i),
                  .rst_i(w_rst_i),
                  .ptr_i(r_ptr),
                  .ptr_o(wr_ptr_2));

    sync_pointer #(.ADDR_SIZE(ADDR_SIZE))
        sync_w2r (.clk_i(r_clk_i),
                  .rst_i(r_rst_i),
                  .ptr_i(w_ptr),
                  .ptr_o(rw_ptr_2));
endmodule
