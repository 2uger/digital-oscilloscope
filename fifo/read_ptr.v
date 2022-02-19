module read_pointer #(parameter ADDR_SIZE=8)
                     (input clk_i,
                      input rst_i,

                      input [ADDR_SIZE:0]wr_ptr_i,
                      input inc_i, // signal to increment read pointer

                      output [ADDR_SIZE:0] ptr_o,
                      output [ADDR_SIZE-1:0] addr_o,
                      output fifo_empty_o);

    wire _fifo_empty;
    assign _fifo_empty = wr_ptr_i == gray_cnt;
    assign fifo_empty_o = _fifo_empty;

    // for binary and gray code counters
    reg [ADDR_SIZE:0] bin_cnt = 0;
    reg [ADDR_SIZE:0] gray_cnt = 0;

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

    assign gray_n = (bin_cnt >> 1) ^ bin_cnt;
    assign bin_n = bin_n + (!_fifo_empty & inc_i);

    assign ptr_o = gray_cnt;
    assign addr_o = bin_cnt[ADDR_SIZE-1:0];
endmodule
