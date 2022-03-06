module computation # (parameter DATA_SIZE=12,
                      parameter ADDR_SIZE=8)
                     (input clk_i,
                      input rst_i,

                      input [DATA_SIZE-1:0] sample_data_i,
                      input trigger_i,

                      output reg [DATA_SIZE-1:0] volt_max_o,
                      output reg [DATA_SIZE-1:0] volt_min_o,

                      output reg freq_o);

    reg [DATA_SIZE-1:0] max_t;
    reg [DATA_SIZE-1:0] min_t;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) begin
            volt_max_o <= 0;
            volt_min_o <= 0;
            max_t <= 0;
            min_t <= 2048;
            freq_o <= 0;
        end else begin
            if (trigger_i) begin
                {volt_max_o, volt_min_o} <= {max_t, min_t};
                max_t <= 0;
                min_t <= 2048;
            end else begin
                if (sample_data_i > max_t) max_t <= sample_data_i;
                if (sample_data_i < min_t) min_t <= sample_data_i;
            end
        end
    end
endmodule
