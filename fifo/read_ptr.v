module read_ptr #(parameter ADDR_SIZE=8)
                 (input clk_i,
                  input rst_i,

                  input [ADDR_SIZE-1:0] rw_ptr_2_i,
                  input inc_i, // signal to increment read pointer

                  output [ADDR_SIZE-1:0] ptr_o,
                  output [ADDR_SIZE-1:0] addr_o,
                  output fifo_empty_o);

    wire _fifo_empty;
    assign _fifo_empty = (rw_ptr_2_i == bin_cnt);
    assign fifo_empty_o = _fifo_empty;

    reg [ADDR_SIZE-1:0] bin_cnt;
    wire [ADDR_SIZE-1:0] bin_n;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) bin_cnt <= 0;
        else bin_cnt <= bin_n;
            //$display("bin cnt: %b, rw pointer: %b, gray cnt: %b, gray_n: %b, fifo empty: %b",bin_cnt, rw_ptr_2_i, gray_cnt, gray_n, _fifo_empty);
    end

    assign bin_n = bin_cnt + (~_fifo_empty & inc_i);

    assign ptr_o = bin_cnt;
    assign addr_o = bin_cnt;
endmodule
