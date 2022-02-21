/*
Module to synchronize read pointer to write clock domain
*/
module sync_r2w_pointer # (parameter ADDR_SIZE=8)
                                 (input w_clk_i,
                                  input w_rst_i,
                                  input [ADDR_SIZE-1:0] r_ptr_i, // read pointer from read clock domain

                                  output [ADDR_SIZE-1:0] wr_ptr_o); // read pointer synchronised with write clock domain
     
     // store intermediate values of signal
     reg [ADDR_SIZE-1:0] wr_ptr_1;
     reg [ADDR_SIZE-1:0] wr_ptr_2;

     always @ (posedge w_clk_i or negedge w_rst_i) begin
        if (!w_rst_i)
            {wr_ptr_2, wr_ptr_1} <= 0;
        else
            {wr_ptr_2, wr_ptr_1} <= {wr_ptr_1, r_ptr_i};
     end

     assign wr_ptr_o = wr_ptr_2;
endmodule
