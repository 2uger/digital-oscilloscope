module sync_pointer # (parameter ADDR_SIZE=8)
                      (input clk_i,
                       input rst_i,
                       input [ADDR_SIZE-1:0] ptr_i,

                       output [ADDR_SIZE-1:0] ptr_o);

     reg [ADDR_SIZE-1:0] ptr_o_1;
     reg [ADDR_SIZE-1:0] ptr_o_2;

     always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i)
            {ptr_o_2, ptr_o_1} <= 0;
        else
            {ptr_o_2, ptr_o_1} <= {ptr_o_1, ptr_i};
     end

     assign ptr_o = ptr_o_2;
endmodule
