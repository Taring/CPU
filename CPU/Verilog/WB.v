module WB(clk, reset, MAResult, WBResult, WBDest, delay);
  input clk, reset, delay;
  input [73:0] MAResult;

  output [37:0] WBResult;
  reg[37:0] WBResult;

  output [4:0] WBDest;
  reg [4:0] WBDest;

  wire MAResultValid;
  wire [3:0] MAResultOpcode;
  wire [5:0] MAResultDest;
  wire [31:0] MAResultAnswer;
  wire [31:0] MAResultMemoryAnswer;
  assign MAResultValid = MAResult[73];
  assign MAResultOpcode = MAResult[72:69];
  assign MAResultDest = MAResult[68:64];
  assign MAResultAnswer = MAResult[63:32];
  assign MAResultMemoryAnswer = MAResult[31:0];

  reg WBResultValid;
  reg [4:0] WBResultDest;
  reg [31:0] WBResultSrc;

  //WBDest <- MAResultDest
  always @(*) begin
    if (!delay) begin
    if (MAResultValid)
      WBDest <= MAResultDest;
    else
      WBDest <= 0;
    end
  end

  //WBResult generate: Calc or lw
  always @(*) begin
  if (!delay) begin
    WBResultValid <= 0;
    WBResultDest <= 0;
    WBResultSrc <= 0;
    if (MAResultValid) begin
      if ((MAResultOpcode[3]==1'b0) || (MAResultOpcode==4'b1000)) begin
        WBResultValid <= 1'b1;
        WBResultDest <= MAResultDest;

        if (MAResultOpcode == 4'b1000)
          WBResultSrc <= MAResult_memmoyAnswer;
        else
          WBResultSrc <= MAResultAnswer;

      //$display("WB: watch WBResultSrc : %d %d %d\n",(MAResultOpcode == 4'b1000) , MAResultMemoryAnswer , MAResultAnswer );
      end
    end
  end
  end

  always @(*) begin
  if (!delay) begin
    WBResult[37] <= WBResultValid;
    WBResult[36:32] <= WBResultDest;
    WBResult[31:0] <= WBResultSrc;
  end
  end

endmodule
