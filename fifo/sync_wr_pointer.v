module sync_write_read_pointer # (parameter ADDR_SIZE=8)
                                 (input r_clk_i,
                                  input r_rst_i,
                                  input [ADDR_SIZE:0] w_ptr_i,

                                  output [ADDR_SIZE:0] r_w_ptr_o);

     reg [ADDR_SIZE:0] r_w_ptr_1;
     reg [ADDR_SIZE:0] r_w_ptr_2;

     always @ (posedge r_clk_i or negedge r_rst_i) begin
        if (!r_rst_i)
            {r_w_ptr_2, r_w_ptr_1} <= 0;
        else
            {r_w_ptr_2, r_w_ptr_1} <= {r_w_ptr_1, w_ptr_i};
     end

     assign r_w_ptr_o = r_w_ptr_2;
endmodule
