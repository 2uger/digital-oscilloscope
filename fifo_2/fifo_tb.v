`timescale 10us/100ns
module fifo_tb;
    localparam DATA_SIZE=4;
    localparam ADDR_SIZE=2;
    localparam TEST_VALUES=8;

    reg w_clk = 1;
    reg r_clk = 1;
    reg rst = 0;

    reg [ADDR_SIZE-1:0] w_addr;
    reg [DATA_SIZE-1:0] w_data;

    reg [ADDR_SIZE-1:0] r_addr = 0;
    wire [DATA_SIZE-1:0] r_data;

    reg trigger;
    wire fifo_full;

    fifo #(.DATA_SIZE(DATA_SIZE),
           .ADDR_SIZE(ADDR_SIZE))
        ram (.w_clk_i(w_clk),
             .r_clk_i(r_clk),
             .rst(rst),
             .w_addr_i(w_addr),
             .w_data(w_data),
             .r_addr_i(r_addr),
             .r_data(r_data),

             .trigger_i(trigger),
             .fifo_full(fifo_full));

    integer r;
    integer file;
    integer line_num = 0;

    integer j;

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        file = $fopen("fifo_values.txt", "r");

        if (file == 0) begin
            $display("ERROR: Cant't open file");
            $finish;
        end
        # 1;
        rst = 1;
        trigger = 1;

        # 5;
        while (line_num < TEST_VALUES) begin
            if (fifo_full) # 40;
            else begin
                r <= $fscanf(file, "%b\n", w_data);
                line_num = line_num + 1;
                # 4;
            end
        end
        # 50;

        $finish;
    end
    
    always # 2 w_clk = !w_clk;
    always # 8 r_clk = !r_clk;

    always @ (posedge r_clk) begin
        r_addr <= r_addr + 1;
    end
endmodule
