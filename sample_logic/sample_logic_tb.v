`timescale 1ns/1ps
module sample_logic_tb;
    localparam DATA_SIZE = 8;

    reg clk = 0;
    reg rst = 0;

    reg [DATA_SIZE-1:0] sample_data;

    reg fifo_empty = 0;
    reg fifo_full = 0;
    reg acquiring = 0;

    wire w_en;
    wire trigger;

    sample_logic #(.DATA_SIZE(DATA_SIZE))
        uut(.clk_i(clk),
            .rst_i(rst),

            .sample_data_i(sample_data),

            .fifo_empty_i(fifo_empty),
            .fifo_full_i(fifo_full),
            .acquiring_i(acquiring),

            .w_en_o(w_en),
            .trigger_o(trigger));

    integer i;
    initial begin
        $dumpfile("sample_logic_tb.vcd");
        $dumpvars(0, sample_logic_tb);

        # 1;
        rst = 1;
        fifo_empty = 1;
        acquiring = 1;
        sample_data = 'h11;
        #9;
        for (i = 0; i < 300; i = i + 25) begin
            sample_data = i;
            #10;
        end
        fifo_full = 1;
        for (i = 0; i < 300; i = i + 25) begin
            sample_data = i;
            #10;
        end

        #10;
        $finish;
    end

    always #5 clk = !clk;

endmodule
