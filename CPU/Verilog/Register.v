module Register(clk, reset, rin1, rout1, rin2, rout2, we, waddr, win, delay);
  input clk, reset, we, delay;
  input [4:0] rin1, rin2, waddr;
  input [31:0] win;
  output [31:0] rout1, rout2;

  reg [31:0] R[31:0];
  assign rout1 = R[rin1];
  assign rout2 = R[rin2];

  integer i;
  always @(posedge clk) begin
    if (!delay) begin
      if (reset)
        for (i = 0; i <= 31; i = i + 1)
          R[i] <= 32'b0;
    end
  end

  always @(posedge clk) begin
    R[0] <= 32'b0;
    /*
    if (rin1 != 0)
      $display("register read1 R[%d] is %d", rin1, rout1);
    if (rin2 != 0)
      $display("register read2 R[%d] is %d", rin2, rout2);
    */
    if (!delay) begin
    if (we)
      if (waddr!=0) begin
        R[waddr] <= win;
        //$display("register write R[%d] <= %d\n", waddr, win);
      end
    end
  end

endmodule
