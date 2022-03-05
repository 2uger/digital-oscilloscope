module sample_logic_tb;
    localparam DATA_SIZE = 8;
    localparam TEST_VALUES = 8;

    reg clk = 0;
    reg rst = 1;
    reg [DATA_SIZE-1:0] sample_data;
    reg [DATA_SIZE-1:0] sample_data_p;
    reg fifo_empty = 0;

    wire w_en;
    wire trigger;

    sample_logic #(.DATA_SIZE(DATA_SIZE))
        uut(.clk_i(clk),
            .rst_i(rst),
            .sample_data_i(sample_data),
            .fifo_empty_i(fifo_empty),
            .w_en_o(w_en),
            .trigger_o(trigger));
    integer r;
    integer file;
    integer line_num = 0;

    integer j;

    initial begin
        $dumpfile("sample_logic_tb.vcd");
        $dumpvars(0, sample_logic_tb);

        file = $fopen("sample_logic_values.txt", "r");

        if (file == 0) begin
            $display("ERROR: Cant't open file");
            $finish;
        end
        # 1;
        rst = 0;
        fifo_empty = 1;
        # 1;
        rst = 1;

        while (line_num < TEST_VALUES) begin
            if (line_num == 3)
                fifo_empty = 0;
            sample_data_p <= sample_data;
            r <= $fscanf(file, "%h\n", sample_data);
            line_num = line_num + 1;
            # 10;
        end
        # 50;
        $finish;
    end

    always #5 clk = !clk;

    always @ (posedge trigger) begin
        $display("Triggered, prev data: %h, new data: %h", sample_data_p, sample_data);
    end

endmodule
