module sample_logic # (parameter DATA_SIZE=12,
                       parameter ADDR_SIZE=8)
                      (input clk_i,
                       input rst_i,

                       input [DATA_SIZE-1:0] sample_data_i,
                       
                       input fifo_empty_i,

                       output reg w_en_o,
                       output trigger_o);
    
    reg trigger_threshold_1;
    reg trigger_threshold_2;
    wire trigger;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) begin
            trigger_threshold_1 <= 0;
            trigger_threshold_2 <= 0;
        end else begin
            {trigger_threshold_2, trigger_threshold_1} <= {trigger_threshold_1, sample_data_i >= 8'h80};
        end
    end

    assign trigger = trigger_threshold_1 & !trigger_threshold_2;
    assign trigger_o = trigger;

    // synchronise signal from different clock domain
    reg fifo_empty_1;
    reg fifo_empty_2;
    always @ (posedge clk_i) begin
        {fifo_empty_2, fifo_empty_1} <= {fifo_empty_1, fifo_empty_i};
    end

    reg state;
    localparam IDLE = 0;
    localparam ACQUIRING = 1;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) begin
            w_en_o <= 0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (fifo_empty_2 & trigger) begin
                        state <= ACQUIRING;
                        w_en_o <= 1;
                    end else begin
                        state <= IDLE;
                        w_en_o <= 0;
                    end
                end
                ACQUIRING: begin
                    if (fifo_empty_2) begin
                        state <= ACQUIRING;
                    end else begin
                        state <= IDLE;
                        w_en_o <= 0;
                    end
                end
            endcase
        end
    end
endmodule
