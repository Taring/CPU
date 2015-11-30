module system();
    reg clk;
    reg reset;

    initial begin
      $dumpfile("test.vcd");//for gtkwave!
      $dumpvars(0,system);
    end

    initial begin
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end

    initial
    begin
        #0 reset<=1'b1;
        #70 reset<=1'b0;
    end

    cpu cpu00(.clk(clk), .reset(reset));
endmodule
