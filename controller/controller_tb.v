`timescale 1ns/1ps
module controller_tb;
    localparam DATA_SIZE = 8;
    localparam TEST_VALUES = 8;

    reg clk = 0;
    reg rst = 0;

    reg [DATA_SIZE-1:0] rx_data;
    reg rx_ready;

    wire [DATA_SIZE-1:0] tx_data;
    wire tx_write_en;
    reg tx_busy = 0;

    reg [DATA_SIZE-1:0] fifo_data;
    reg fifo_empty = 0;
    wire fifo_read_en;

    controller #(.DATA_SIZE(DATA_SIZE))
        uut(.clk_i(clk),
            .rst_i(rst),

            .rx_data_i(rx_data),
            .rx_ready_i(rx_ready),

            .tx_data_o(tx_data),
            .tx_write_en_o(tx_write_en),
            .tx_busy_i(tx_busy),

            .fifo_data_i(fifo_data),
            .fifo_empty_i(fifo_empty),
            .fifo_read_en_o(fifo_read_en));

    integer i;
    initial begin
        $dumpfile("controller_tb.vcd");
        $dumpvars(0, controller_tb);

        # 1;
        rst = 1;
        rx_ready = 1;
        rx_data = 8'b1;
        #9;
        for (i = 0; i < 10; i = i + 1) begin
            fifo_data = i;
            #10;
        end

        rx_data = 8'b10;
        #20;
        rx_data = 8'b1;
        for (i = 0; i < 10; i = i + 1) begin
            fifo_data = i;
            #10;
        end
        fifo_data = 22;
        fifo_empty = 1;
        #30;
        $finish;
    end

    always #5 clk = !clk;

endmodule
