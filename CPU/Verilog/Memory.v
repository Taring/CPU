module Memory(clk, over, rin1, rout1, rin2, rout2, le, we, waddr, win, delay, wa);
  input clk, le, we, over;
  input [31:0] win;
  input [15:0] rin1, rin2, waddr;

  reg[31:0]  M[65535:0];
  initial begin
    $readmemb("data.vlog",M);
    //$display("Has been written");
  end

  output [127:0] rout1, rout2;
  //reg [127:0] rout1, rout2;

  output delay;
  reg delay;
  reg [7:0] delay_clock;
  initial begin
    delay_clock = 8'b00000000;
    delay = 1'b0;
  end

  output wa;
  reg wa;
  initial begin
    wa = 1'b1;
  end

  //parameter READ_DELAY = 200, WRITE_DELAY = 200;
  //parameter READ_DELAY = 0, WRITE_DELAY = 0;

  assign rout1 = {M[rin1 + 3], M[rin1 + 2], M[rin1 + 1], M[rin1]};
  assign rout2 = {M[rin2 + 3], M[rin2 + 2], M[rin2 + 1], M[rin2]};

  always @(posedge clk) begin
    delay <= (le == 1'b1 || we == 1'b1);
    wa <= (le != 1'b1);
  end

  always @(posedge clk) begin
/*
      if (le == 1'b1)
      $display("Memory ask M[%d] is %d", rin1, M[rin1]);
      if (le == 1'b1)
      $display("Memory ask M[%d] is %d", rin2, M[rin2]);
  */
      if (we == 1'b1) begin
        M[waddr] <= win;
        //$display("\nsw successfully!~\nAnswer:", win, "\n\n");
        $display("sw %d successfully! : %d", waddr, win);
        //$display("%d\n", M[1]);
      end
/*
      if (we == 1'b1) begin
        if (delay_clock == 8'b11001000) begin
          delay_clock <= 8'b00000000;
          $display("delay_clock :", 8'b00000000);
          delay <= 1'b0;
          M[waddr] <= win;
        end else begin
          delay_clock <= delay_clock + 1;
          $display("delay_clock : ", delay_clock + 1);
          delay <= 1'b1;
        end
      end else if (le == 1'b1) begin
        if (delay_clock == 8'b11001000) begin
          delay_clock <= 8'b00000000;
          $display("delay_clock :", 8'b00000000);
          delay <= 1'b0;
          //rout1 <= {M[rin1 + 3], M[rin1 + 2], M[rin1 + 1], M[rin1]};
          //rout2 <= {M[rin2 + 3], M[rin2 + 2], M[rin2 + 1], M[rin2]};
          wa = 1'b0;
        end else begin
          delay_clock <= delay_clock + 1;
          $display("delay_clock : ", delay_clock + 1);
          delay <= 1'b1;
          wa = 1'b1;
        end
      end else begin
        delay <= 1'b0;
        wa = 1'b1;
      end
    */
  end

  always @(posedge over) begin
    $writememb("memoryover.vlog",M);
    $display("Sw Checking");
  end

 endmodule
