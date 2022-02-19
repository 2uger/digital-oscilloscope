module sync_tb;
    localparam PTR_WIDTH = 8;
    reg clk = 0;
    reg rst = 1;
    reg [PTR_WIDTH-1:0] ptr_i = 0;
    wire [PTR_WIDTH-1:0] ptr_o;

    sync_write_read_pointer uut(.r_clk_i(clk),
                                .r_rst_i(rst),
                                .w_ptr_i(ptr_i),
                                .r_w_ptr_o(ptr_o));

    always #3 clk = !clk;

    initial begin
        $dumpfile("sync_tb.vcd");
        $dumpvars(0, sync_tb);
        # 1;
        rst = 0;
        # 1;
        rst = 1;
        ptr_i = 8;
        # 20;
        $finish;
    end
endmodule
