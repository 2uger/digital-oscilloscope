`define EOF -1

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
    integer file;
    integer r;
    integer line_num = 0;

    reg [10:0] data_to_send;

    initial begin
        $dumpfile("adc_driver_test.vcd");
        $dumpvars(0, adc_test);

        file = $fopen("adc_values.txt", "r");

        if (file == 0) begin
            $display("ERROR: Can't open file to read");
            $finish;
        end

        start_sample_i = 1;
        channel_num_i = 1;

        # 5;
        while (line_num < 3) begin
            r = $fscanf(file, "%b\n", data_to_send);
            $display("Data to send is %b", data_to_send);
            # 70;
            for (i = 0; i < 11; i = i + 1) begin
                dout_i = data_to_send[i];
                # 10;
            end

            line_num = line_num + 1;
        end

        $fclose(file);
        $finish;
    end

    always @ (posedge data_ready_o) begin
        $display("Output data: %d, input data was: %d", data_o, data_to_send[10:1]);
    end

endmodule
