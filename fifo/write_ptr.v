module write_ptr #(parameter ADDR_SIZE=8)
                  (input clk_i,
                   input rst_i,

                   input [ADDR_SIZE:0] wr_ptr_2_i,
                   input inc_i, // signal to increment write pointer

                   output [ADDR_SIZE:0] ptr_o,
                   output [ADDR_SIZE-1:0] addr_o,
                   output fifo_full_o);

    wire _fifo_full;
    assign _fifo_full = {~wr_ptr_2_i[ADDR_SIZE], wr_ptr_2_i[ADDR_SIZE-1:0]} == gray_cnt;
    assign fifo_full_o = _fifo_full;

    // for binary and gray code counters
    reg [ADDR_SIZE:0] bin_cnt;
    reg [ADDR_SIZE:0] gray_cnt;

    wire [ADDR_SIZE:0] gray_n;
    wire [ADDR_SIZE:0] bin_n;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) 
            {bin_cnt, gray_cnt} <= 0;
        else begin
            bin_cnt <= bin_n;
            gray_cnt <= gray_n;
        end
    end

    assign gray_n = (bin_n >> 1) ^ bin_n;
    assign bin_n = bin_cnt + (!_fifo_full & inc_i);

    assign ptr_o = gray_cnt;
    assign addr_o = bin_cnt[ADDR_SIZE-1:0];
endmodule
