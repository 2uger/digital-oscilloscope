module adc_test;
    reg clk = 1;
    reg start_sample_i;
    reg channel_num_i;

    wire cs_o;
    wire din_o;
    reg dout_i;

    wire data_ready_o;
    wire [9:0] data_o;

    adc_driver uut(
        .s_clk_i(clk),
        .start_sample_i(start_sample_i),
        .channel_num_i(channel_num_i),

        .cs_o(cs_o),
        .din_o(din_o),
        .dout_i(dout_i),

        .data_ready_o(data_ready_o),
        .data_o(data_o)
    );

    always # 5 clk = !clk;

    integer i;
    integer fd;
    reg [10:0] data_to_send;

    reg r;

    initial begin
        $dumpfile("adc_test.vcd");
        $dumpvars(0, adc_test);

        fd = $fopen("adc_values.txt", "r");

        start_sample_i = 1;
        channel_num_i = 1;

        r = $fscanf(fd, "%b\n", data_to_send);
        $display("Data to send is %b", data_to_send);
        # 75;
        for (i = 0; i < 11; i = i + 1) begin
            dout_i = data_to_send[i];
            # 10;
        end

        # 70;
        r = $fscanf(fd, "%b\n", data_to_send);
        for (i = 0; i < 11; i = i + 1) begin
            dout_i = data_to_send[i];
            # 10;
        end
        #10;

        $fclose(fd);
        $finish;
    end

    reg [5:0] cnt = 0;
    always @ (posedge clk) begin
        if (data_ready_o) begin
            $display("Output data: %d, input data was: %d", data_o, data_to_send[10:1]);
        end
        cnt <= cnt + 1;
    end

endmodule
