module adc_driver (
    input s_clk_i, // clock for serial data transfer
    input start_sample_i, // signal from controller unit to start sampling
    input channel_num_i, // channel number

    output cs_o, // chip selection
    output din_o, // data in
    input dout_i, // data out

    output data_ready_o,
    output [9:0] data_o
);
    localparam IDLE = 0;
    localparam START = 1; // send start bit and choose channel
    localparam READING = 2; // receiving serial data from ADC module
    localparam RESET = 3; // reset cs_o signal to receive new portion of data

    reg [1:0] state;
    reg [3:0] counter; 
    reg [3:0] recv_counter; // count how many bytes received
    reg [9:0] buffer; // store eventual data

    reg _cs_o;
    reg _din_o;
    reg _data_ready_o;

    reg [4:0] control_bit_selections;

    // assigning inside regs to output wire
    assign cs_o = _cs_o;
    assign din_o = _din_o;

    assign data_ready_o = _data_ready_o;
    assign data_o = buffer;

    initial begin
        state = IDLE;
        counter = 0;
        recv_counter = 0;
        buffer = 10'b0000000000;
        _data_ready_o = 1'b0;
    end

    always @ (posedge s_clk_i) begin
        counter <= counter + 1;
    end

    always @ (negedge s_clk_i) begin
    end

    always @ (posedge s_clk_i) begin
        case (state)
            IDLE: begin
                if (start_sample_i)
                    state <= RESET;
                else
                    state <= IDLE;
            end
            READING: begin
                buffer[recv_counter] <= dout_i;
                if (recv_counter == 9) begin
                    _data_ready_o <= 1;
                    state <= RESET;
                end else
                    state <= READING;
            end
        endcase
    end

    always @ (negedge s_clk_i) begin
        case (state)
            READING: begin
                recv_counter <= recv_counter + 1;
            end
            START: begin
                // start sampling
                if (counter == 5)
                    state <= START;
                // recv NULL bit
                else if (counter == 6)
                    state <= START;
                else if (counter == 7) begin
                    recv_counter <= 0;
                    state <= READING;
                end
                else
                    _din_o <= control_bit_selections[counter];

                _data_ready_o <= 1'b0;
                _cs_o <= 1'b0;
            end
            RESET: begin
                // choosing channel number
                case (channel_num_i)
                    1: 
                        control_bit_selections = 5'b00011;
                    2:
                        control_bit_selections = 5'b11001;
                endcase
                // check for stop signal
                if (!start_sample_i)
                    state <= IDLE;

                // reset counters
                counter <= -1;
                recv_counter <= 0;

                _cs_o <= 1'b1;
                state <= START;
            end
        endcase
    end
endmodule
