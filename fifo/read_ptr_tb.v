`timescale 10us/100ns
module read_ptr_tb;
    localparam ADDR_SIZE = 3;
    reg clk = 0;
    reg rst = 0;
    reg [ADDR_SIZE:0] rw_ptr_2 = 0;
    reg inc;
    wire [ADDR_SIZE:0] r_ptr;
    wire [ADDR_SIZE-1:0] r_addr;
    wire fifo_empty;

    read_ptr # (.ADDR_SIZE(ADDR_SIZE)) 
              uut(.clk_i(clk),
                  .rst_i(rst),
                  .rw_ptr_2_i(rw_ptr_2),
                  .inc_i(inc),
                  .ptr_o(r_ptr),
                  .addr_o(r_addr),
                  .fifo_empty_o(fifo_empty));

    always #5 clk = !clk;

    initial begin
        $dumpfile("read_ptr_tb.vcd");
        $dumpvars(0, read_ptr_tb);
        # 1;
        rst = 1;
        rw_ptr_2 = 10;
        inc = 1;
        # 200;
        $finish;
    end

    always @ (posedge clk) begin
        if (fifo_empty) begin
            if (r_ptr == rw_ptr_2)
                $display("FIFO is empty, read address: %b, read pointer: %b == rw pointer: %b", r_addr, r_ptr, rw_ptr_2);
            else
                $display("Smth goes wrong read pointer: %b != rw pointer: %b", r_addr, r_ptr, rw_ptr_2);
            $finish;
        end
        $display("Read address : %b, read pointer: %b", r_addr, r_ptr);
    end
endmodule
