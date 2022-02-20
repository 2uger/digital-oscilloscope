module sync_w2r_pointer # (parameter ADDR_SIZE=8)
                          (input r_clk_i,
                           input r_rst_i,
                           input [ADDR_SIZE:0] w_ptr_i,

                           output [ADDR_SIZE:0] rw_ptr_o);

     reg [ADDR_SIZE:0] rw_ptr_1;
     reg [ADDR_SIZE:0] rw_ptr_2;

     always @ (posedge r_clk_i or negedge r_rst_i) begin
        if (!r_rst_i)
            {rw_ptr_2, rw_ptr_1} <= 0;
        else
            {rw_ptr_2, rw_ptr_1} <= {rw_ptr_1, w_ptr_i};
     end

     assign rw_ptr_o = rw_ptr_2;
endmodule
