module write_ptr #(parameter ADDR_SIZE=8)
                  (input clk_i,
                   input rst_i,

                   input [ADDR_SIZE-1:0] wr_ptr_2_i,
                   input inc_i, // signal to increment write pointer

                   output [ADDR_SIZE-1:0] ptr_o,
                   output [ADDR_SIZE-1:0] addr_o,
                   output fifo_full_o);

    wire _fifo_full;
    assign _fifo_full = (wr_ptr_2_i == bin_cnt_1);
    assign fifo_full_o = _fifo_full;

    reg [ADDR_SIZE-1:0] bin_cnt;
    reg [ADDR_SIZE-1:0] bin_cnt_1;
    wire [ADDR_SIZE-1:0] bin_n;
    wire [ADDR_SIZE-1:0] bin_n_1;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) begin
            bin_cnt <= 0; 
            bin_cnt_1 <= 1; 
        end
        else {bin_cnt, bin_cnt_1} <= {bin_n, bin_n_1};
        //$display("Bin cnt: %b, wr ptr: %b, bin n: %b, full: %b", bin_cnt, wr_ptr_2_i, bin_n, _fifo_full);
    end

    assign bin_n = bin_cnt + (~_fifo_full & inc_i);
    assign bin_n_1 = bin_cnt_1 + (~_fifo_full & inc_i);

    assign ptr_o = bin_cnt;
    assign addr_o = bin_cnt;
endmodule
