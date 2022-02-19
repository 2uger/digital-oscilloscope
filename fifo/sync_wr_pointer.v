/*
Module to synchronize write pointer signal into read clock domain
*/
module sync_write_read_pointer
    #(parameter PTR_WIDTH=8)
    (input r_clk_i,
     input r_rst_i,
     input [0:PTR_WIDTH-1] w_ptr_i, // write pointer from write clock domain

     output [0:PTR_WIDTH-1] r_w_ptr_o); // read-write pointer synchronised for read clock domain

     reg [0:PTR_WIDTH-1] r_w_ptr_1;
     reg [0:PTR_WIDTH-1] r_w_ptr_o;

     always @ (posedge r_clk_i or negedge r_rst_i) begin
        if (!r_rst_i)
            {r_w_ptr_o, r_w_ptr_1} <= 0;
        else
            {r_w_ptr_o, r_w_ptr_1} <= {r_w_ptr_1, w_ptr_i};
     end
endmodule
