module controller #(parameter DATA_SIZE=12)
                   (input clk_i,
                    input rst_i,

                    // R_x communication
                    input [DATA_SIZE-1:0] rx_data_i,
                    input rx_ready_i,

                    // T_x communication
                    output reg [DATA_SIZE-1:0] tx_data_o,
                    output reg tx_write_en_o,
                    input tx_busy_i,

                    // FIFO communication
                    input [DATA_SIZE-1:0] fifo_data_i,
                    input fifo_empty_i,
                    output reg fifo_read_en_o);

    // list of commands from PC
    localparam PC_SEND = 8'b1;
    localparam PC_STOP = 8'b10;

    reg[2:0] state;
    localparam IDLE = 0;
    localparam SENDING = 1;

    always @ (posedge clk_i or negedge rst_i) begin
        if (!rst_i) begin
            tx_data_o <= 0;
            state <= IDLE;

            tx_write_en_o <= 0;
            fifo_read_en_o <= 0;

        end else begin
            case (state)
                IDLE: begin
                    if (rx_ready_i & rx_data_i == PC_SEND) begin
                        state <= SENDING;

                        fifo_read_en_o <= 1;
                    end else begin
                        tx_write_en_o <= 0;
                        fifo_read_en_o <= 0;

                    end
                end
                SENDING: begin
                    if (rx_ready_i & rx_data_i == PC_STOP) begin

                        tx_write_en_o <= 0;
                        fifo_read_en_o <= 0;

                        state <= IDLE;
                    end else begin
                        if (!tx_busy_i & !fifo_empty_i) begin
                            tx_data_o <= fifo_data_i;

                            tx_write_en_o <= 1;
                            fifo_read_en_o <= 1;

                        end else begin
                            tx_write_en_o <= 0;
                            fifo_read_en_o <= 0;
                        end
                    end
                end
            endcase
        end
    end
endmodule


