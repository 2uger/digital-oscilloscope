module fifo # (parameter DATA_SIZE=12,
               parameter ADDR_SIZE=8,
               parameter MEM_SIZE=2 ** ADDR_SIZE)
              (input w_clk_i,
               input r_clk_i,
               input rst,

               input [ADDR_SIZE-1:0] w_addr_i,
               input [DATA_SIZE-1:0] w_data,

               input [ADDR_SIZE-1:0] r_addr_i,
               output [DATA_SIZE-1:0] r_data,

               input trigger_i,
               output reg fifo_full);

    reg [MEM_SIZE-1:0][DATA_SIZE-1:0] memory ;
    reg [3:0] state;
    reg [ADDR_SIZE:0] w_pointer;

    localparam IDLE = 0;
    localparam TRIGGERED = 1;
    localparam FULL = 2;

    integer i;
    always @ (posedge w_clk_i or negedge rst) begin
        $display("Memory dump");
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            $display("Addr: %h, data: %h", i, memory[i]);
        end
        if (!rst) begin
            state <= IDLE;
            w_pointer <= 0;
            fifo_full <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (trigger_i) begin
                        state <= TRIGGERED;
                        fifo_full <= 0;
                    end
                    else
                        state <= IDLE;
                end
                TRIGGERED: begin
                    if (w_pointer == MEM_SIZE-1) begin
                        w_pointer <= 0;
                        fifo_full <= 1;
                        state <= FULL;
                    end else begin
                        memory[MEM_SIZE-1:0] <= {memory[MEM_SIZE-2:0], w_data};
                        w_pointer <= w_pointer + 1;
                    end
                end
                FULL: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign r_data = memory[r_addr_i];
endmodule
