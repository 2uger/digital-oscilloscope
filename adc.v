module adc_driver (
    input s_clk_i, // clock for serial data transfer
    input rst_i,
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

    initial begin
        state = IDLE;
        counter = 4'b0;
        buffer = 10'b0;
        _data_ready_o = 1'b0;
    end

    assign cs_o = _cs_o;
    assign din_o = _din_o;

    assign data_ready_o = _data_ready_o;
    assign data_o = buffer;

    always @ (posedge s_clk_i) begin
        case (state)
            IDLE: begin
                if (!start_sample_i)
                    state <= IDLE;
                else begin
                    case (channel_num_i)
                        1: 
                            control_bit_selections = 5'b11000;
                        2:
                            control_bit_selections = 5'b11001;
                    endcase

                    state <= RESET;
                end
            end
            READING: begin
                buffer[recv_counter] <= din_o;
                recv_counter <= recv_counter + 1;
                if (recv_counter == 9) begin

                    state <= RESET;
                end
            end
        endcase
    end

    always @ (negedge s_clk_i) begin
        case (state)
            START: begin
                // start sampling
                if (counter == 5)
                    state <= START;
                // recv NULL bit
                else if (counter == 6)
                    state <= START;
                else if (counter == 7)
                    state <= READING;
                else
                    _din_o <= control_bit_selections[counter];

                _cs_o <= 1'b0;
                counter <= counter + 1;
            end
            RESET: begin
                _cs_o <= 1'b1;
                state <= START;
            end
        endcase
    end
endmodule
