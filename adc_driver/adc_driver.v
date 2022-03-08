module adc_driver (
    input s_clk_i, // clock for serial data transfer
    input start_sample_i, // signal from controller unit to start sampling
    input channel_num_i, // channel number

    output cs_o, // chip selection
    output din_o, // data to ADC
    input dout_i, // data from ADC

    output data_ready_o,
    output [9:0] data_o
);
    localparam IDLE = 0; // do nothing, wait for controlled signal
    localparam START = 1; // send start bit and choose channel
    localparam READING = 2; // receiving serial data from ADC module
    localparam RESET = 3; // reset cs_o signal to receive new portion of data

    reg [1:0] state;
    reg [3:0] start_bits_counter; // count serial translated start bits
    reg [3:0] recv_bits_counter; // count how many bytes received
    reg [9:0] buffer; // store eventual data

    reg _cs_o;
    reg _din_o;
    reg _data_ready_o;

    /* 
    {start_bit, single/diff, D2, D1, D0}
    Combination of single/diff, D2, D1, D0 will configure
    input configuration and channel number
    */
    reg [4:0] control_bit_selections;

    // assigning inside regs to output wire
    assign cs_o = _cs_o;
    assign din_o = _din_o;

    assign data_ready_o = _data_ready_o;
    assign data_o = buffer;

    initial begin
        state = IDLE;
        start_bits_counter = 0;
        recv_bits_counter = 0;
        buffer = 0;
        _data_ready_o = 0;
    end

    always @ (posedge s_clk_i) begin
        case (state)
            IDLE: begin
                if (start_sample_i) begin
                    state <= RESET;
                end else
                    state <= IDLE;
            end
            READING: begin
                buffer[recv_bits_counter] <= dout_i;
                if (recv_bits_counter == 9) begin
                    _data_ready_o <= 1;
                    state <= RESET;
                end else
                    state <= READING;

                recv_bits_counter <= recv_bits_counter + 1;
            end
        endcase
    end

    always @ (negedge s_clk_i) begin
        case (state)
            RESET: begin
                // choosing channel number
                case (channel_num_i)
                    1: 
                        control_bit_selections = 5'b00011;
                    2:
                        control_bit_selections = 5'b11001;
                endcase

                // reset counters
                start_bits_counter <= 0;
                recv_bits_counter <= 0;

                _cs_o <= 1;
                state <= START;
            end
            START: begin
                // start sampling
                if (start_bits_counter == 5)
                    state <= START;
                // recv NULL bit
                else if (start_bits_counter == 6)
                    state <= START;
                else if (start_bits_counter == 7) begin
                    recv_bits_counter <= 0;
                    state <= READING;
                end else
                    _din_o <= control_bit_selections[start_bits_counter];

                start_bits_counter <= start_bits_counter + 1;

                _data_ready_o <= 0;
                _cs_o <= 0;
            end
        endcase
    end
endmodule
