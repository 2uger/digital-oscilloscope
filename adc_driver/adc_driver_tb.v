module adc_driver_tb;
    reg clk = 1;
    reg start_sample;
    reg channel_num;

    wire cs_o;
    wire din_o;
    reg dout_i;

    wire data_ready_o;
    wire [9:0] data_o;

    adc_driver uut(
        .s_clk_i(clk),
        .start_sample_i(start_sample),
        .channel_num_i(channel_num),

        .cs_o(cs_o),
        .din_o(din_o),
        .dout_i(dout_i),

        .data_ready_o(data_ready_o),
        .data_o(data_o)
    );

    always # 5 clk = !clk;

    integer i;
    integer j;

    reg [10:0] data_to_send [2:0];

    initial begin
        $dumpfile("adc_driver_tb.vcd");
        $dumpvars(0, adc_driver_tb);

        data_to_send[0] = 11'b00000101100;
        data_to_send[1] = 11'b00000100100;
        data_to_send[2] = 11'b00010100100;

        start_sample = 1;
        channel_num = 1;

        #5;
        for (i = 0; i < 3; i = i + 1) begin
            #70;
            for (j = 0; j < 11; j = j + 1) begin
                dout_i = data_to_send[j];
                # 10;
            end
        end
        $finish;
    end

    always @ (posedge data_ready_o) begin
        $display("Output data: %d, input data was: %d", data_o, data_to_send[10:1]);
    end

endmodule
