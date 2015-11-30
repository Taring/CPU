module MA(clk, reset, over, EXResult, MAResult, MADest, delay);
  input clk, reset, over;
  input [73:0] EXResult;
  output [73:0] MAResult;
  output [4:0] MADest;

  output delay;

  reg [73:0] MAResult;
  reg [4:0] MADest;

  wire EXResultValid;
  wire [3:0] EXResultOpcode;
  wire [4:0] EXResultDest;
  wire [31:0] EXResultAnswer;
  wire [31:0] EXResultValue;

  assign EXResultValid = EXResult[73];
  assign EXResultOpcode = EXResult[72:69];
  assign EXResultDest = EXResult[68:64];
  assign EXResultAnswer = EXResult[63:32];
  assign EXResultValue = EXResult[31:0];

  wire MAResultValid;
  wire [3:0] MAResultOpcode;
  wire [5:0] MAResultDest;
  wire [31:0] MAResultAnswer;
  wire [31:0] MAResultMemoryAnswer;

  always @(*) begin
    if (EXResultValid)
      MADest <= EXResultDest;
    else
      MADest <= 0;
  end

  reg rd_we;//sw or not
  always @(*) begin
  if (!delay) begin
    rd_we <= 0;
    if (EXResultOpcode == 4'b1001)
      rd_we <= 1;
  end
  end

  reg rd_le;//lw or not
  always @(*) begin
  //$display("MEM: re_le Changes: delay %d, %d", delay, EXResultOpcode == 4'b1000);
  if (!delay) begin
    rd_le <= 0;
    if (EXResultOpcode == 4'b1000)
      rd_le <= 1;
  end
  end

  assign MAResultValid = EXResultValid;
  assign MAResultOpcode = EXResultOpcode;
  assign MAResultDest = EXResultDest;
  assign MAResultAnswer = EXResultAnswer;

  Cache Cache_memory(.clk(clk), .reset(reset), .over(over),
   .rin(EXResultAnswer[17:2]), .le(rd_le), .rout(MAResultMemoryAnswer),
   .we(rd_we), .waddr(EXResultAnswer[17:2]), .win(EXResultValue), .delay(delay));

  always @(posedge clk) begin
    //$display("MEM: delay : %d", delay);
    if (!delay) begin
      if (reset)
        MAResult <= 0;
        else begin
    /*
    $display("MEM: show MAResultAnswer : %d", MAResultAnswer);
    $display("MEM: show MAResultMemoryAnswer : %d", MAResultMemoryAnswer);
    */
        MAResult[73] <= MAResultValid;
        MAResult[72:69] <= MAResultOpcode;
        MAResult[68:64] <= MAResultDest;
        MAResult[63:32] <= MAResultAnswer;
        MAResult[31:0] <= MAResultMemoryAnswer;
        end
    end
  end

endmodule
