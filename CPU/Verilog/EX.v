module EX(clk, reset, IDResult, EXResult, EXDest, delay);
  input clk, reset, delay;
  input [105:0] IDResult;

  output [73:0] EXResult;
  reg [73:0] EXResult;
  output [4:0] EXDest;
  reg[4:0] EXDest;

  wire IDResultValid;
  wire [3:0] IDResultOpcode;
  wire [4:0] IDResultDest;
  wire [31:0] IDResultRec1;
  wire [31:0] IDResultRec2;
  wire [31:0] IDResultImm;
  assign IDResultValid = IDResult[105];
  assign IDResultOpcode = IDResult[104:101];
  assign IDResultDest = IDResult[100:96];
  assign IDResultRec1 = IDResult[95:64];
  assign IDResultRec2 = IDResult[63:32];
  assign IDResultImm = IDResult[31:0];

  reg EXResultValid;
  reg [3:0] EXResultOpcode;
  reg [4:0] EXResultDest;
  reg [31:0] EXResultAnswer;
  reg [31:0] EXResultValue;

  always @(*) begin
  if (!delay) begin
    if (IDResultValid)
      EXDest <= IDResultDest;
    else
      EXDest <= 0;
  end
  end

  always @(*) begin
  if (!delay) begin
    EXResultValid <= 0;
    EXResultOpcode <= 0;
    EXResultDest <= 0;
    EXResultAnswer <= 32'h00000000;
    EXResultValue <= 32'h00000000;
    if (IDResultValid) begin
      EXResultValid <= 1'b1;
      EXResultOpcode <= IDResultOpcode;
      EXResultDest <= IDResultDest;
      case(IDResultOpcode)
        4'b0001:begin
          EXResultAnswer <= IDResultRec1 + IDResultRec2;
        end
        4'b0010:begin
          EXResultAnswer <= IDResultRec1 - IDResultRec2;
        end
        4'b0011:begin
          EXResultAnswer <= IDResultRec1 * IDResultRec2;
        end
        4'b0100:begin
          EXResultAnswer <= IDResultRec1 + IDResultImm;
        end
        4'b0101:begin
          EXResultAnswer <= IDResultRec1 - IDResultImm;
        end
        4'b0110:begin
          EXResultAnswer <= IDResultRec1 * IDResultImm;
        end
        4'b0111:begin
          EXResultAnswer <= IDResultRec1 << IDResultImm[3:0];
        end
        4'b1000:begin
          EXResultAnswer <= IDResultRec1 + IDResultImm;
          //$display("EX: lw, EXResultAnswer = %d\n", IDResultRec1 + IDResultImm);
        end
        4'b1001:begin
          EXResultAnswer <= IDResultRec2 + IDResultImm;
          EXResultValue <= IDResultRec1;
          //$display("EX: sw, EXResultValue = %d\n", IDResultRec1);
        end
      endcase
    end
  end
  end


  always @(posedge clk) begin
  //$display();
  //if (!delay)
    //$display("EX delay = 0");
  if (!delay) begin
    if (reset)
      EXResult <= 0;
    else begin
      EXResult[73] <= EXResultValid;
      EXResult[72:69] <= EXResultOpcode;
      EXResult[68:64] <= EXResultDest;
      EXResult[63:32] <= EXResultAnswer;
      EXResult[31:0] <= EXResultValue;
    end
  end
  end

endmodule
