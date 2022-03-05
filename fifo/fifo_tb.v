`timescale 10us/100ns
module fifo_tb;
    localparam DATA_SIZE=4;
    localparam ADDR_SIZE=2;
    localparam TEST_VALUES=8;

    reg w_clk = 1;
    reg w_rst = 0;

    reg r_clk = 1;
    reg r_rst = 0;

    reg w_inc = 1;
    reg r_inc = 1;

    reg [DATA_SIZE-1:0] w_data;
    wire [DATA_SIZE-1:0] r_data;

    wire fifo_full;
    wire fifo_empty;

    wire [ADDR_SIZE-1:0] wr_ptr_2;
    wire [ADDR_SIZE-1:0] w_ptr;
    wire [ADDR_SIZE-1:0] w_addr;

    write_ptr #(.ADDR_SIZE(ADDR_SIZE))
        wp (.clk_i(w_clk),
            .rst_i(w_rst),
            .wr_ptr_2_i(wr_ptr_2),
            .inc_i(w_inc),
            .ptr_o(w_ptr),
            .addr_o(w_addr),
            .fifo_full_o(fifo_full));

    wire [ADDR_SIZE-1:0] rw_ptr_2;
    wire [ADDR_SIZE-1:0] r_ptr;
    wire [ADDR_SIZE-1:0] r_addr;

    read_ptr #(.ADDR_SIZE(ADDR_SIZE))
        rp (.clk_i(r_clk),
            .rst_i(w_rst),
            .rw_ptr_2_i(rw_ptr_2),
            .inc_i(r_inc),
            .ptr_o(r_ptr),
            .addr_o(r_addr),
            .fifo_empty_o(fifo_empty));

    fifo_ram #(.DATA_SIZE(DATA_SIZE),
               .ADDR_SIZE(ADDR_SIZE))
        ram (.clk_i(w_clk),
             .w_en_i(w_inc),
             .w_addr_i(w_addr),
             .w_data(w_data),
             .r_addr_i(r_addr),
             .r_data_o(r_data));

    sync_pointer #(.ADDR_SIZE(ADDR_SIZE))
        sync_r2w (.clk_i(w_clk),
                  .rst_i(w_rst),
                  .ptr_i(r_ptr),
                  .ptr_o(wr_ptr_2));

    sync_pointer #(.ADDR_SIZE(ADDR_SIZE))
        sync_w2r (.clk_i(r_clk),
                  .rst_i(r_rst),
                  .ptr_i(w_ptr),
                  .ptr_o(rw_ptr_2));

    integer r;
    integer file;
    integer line_num = 0;

    integer j;
    reg [DATA_SIZE-1:0] r_mem [TEST_VALUES:0];

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        file = $fopen("fifo_values.txt", "r");

        if (file == 0) begin
            $display("ERROR: Cant't open file");
            $finish;
        end
        # 1;
        w_rst = 1;
        r_rst = 1;

        while (line_num < TEST_VALUES) begin
            if (fifo_full) # 2;
            else begin
                r <= $fscanf(file, "%b\n", w_data);
                line_num = line_num + 1;
                # 4;
            end
        end
        # 50;

        $display("Values were read:");
        for (j = 0; j < TEST_VALUES; j = j + 1) begin
            $display("Addr: %h, value: %b", j, r_mem[j]);
        end
        $finish;
    end
    
    integer i = 0;
    always @ (posedge r_data or negedge r_data) begin
        r_mem[i] <= r_data;
        i = i + 1;
    end

    always # 2 w_clk = !w_clk;
    always # 8 r_clk = !r_clk;
endmodule
