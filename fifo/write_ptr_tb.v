`timescale 10us/100ns
module write_ptr_tb;
    localparam ADDR_SIZE = 2;
    reg clk = 0;
    reg rst = 0;
    reg [ADDR_SIZE-1:0] wr_ptr_2 = 0;
    reg inc;
    wire [ADDR_SIZE-1:0] w_ptr;
    wire [ADDR_SIZE-1:0] w_addr;
    wire fifo_full;

    write_ptr # (.ADDR_SIZE(ADDR_SIZE)) 
              uut(.clk_i(clk),
                  .rst_i(rst),
                  .wr_ptr_2_i(wr_ptr_2),
                  .inc_i(inc),
                  .ptr_o(w_ptr),
                  .addr_o(w_addr),
                  .fifo_full_o(fifo_full));

    always #5 clk = !clk;

    initial begin
        $dumpfile("write_ptr_tb.vcd");
        $dumpvars(0, write_ptr_tb);
        # 1;
        rst = 1;
        wr_ptr_2 = 0;
        inc = 1;
        # 40;
        wr_ptr_2 = 2'b10;
        # 70;
        wr_ptr_2 = 2'b11;
        # 70;
        $finish;
    end

    always @ (posedge clk) begin
        if (fifo_full) begin
        end
        //$display("Write address : %b, write pointer: %b", w_addr, w_ptr);
    end
endmodule
