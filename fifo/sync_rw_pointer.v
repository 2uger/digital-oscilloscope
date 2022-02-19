/*
Module to synchronize read pointer to write clock domain
*/
module sync_read_write_pointer
    #(parameter PTR_WIDTH=8)
    (input w_clk_i,
     input w_rst_i,
     input [0: PTR_WIDTH-1] r_ptr_i, // read pointer from read clock domain

     output [0: PTR_WIDTH-1] w_r_ptr_o); // read pointer synchronised with write clock domain
     
     // store intermediate values of signal
     reg [0: PTR_WIDTH-1] w_r_ptr_1;
     reg [0: PTR_WIDTH-1] w_r_ptr_2;

     always @ (posedge w_clk_i or negedge w_rst_i) begin
        if (!w_rst_i)
            {w_r_ptr_2, w_r_ptr_1} <= 0;
        else
            {w_r_ptr_2, w_r_ptr_1} <= {w_r_ptr_1, r_ptr_i};
     end

     assign w_r_ptr_o = w_r_ptr_2;
endmodule
