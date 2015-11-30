module ID(clk, reset, ins, EXDest, MADest, WBDest, WBResult, IFControl, IDResult, delay);
  input clk, reset, delay;
  input [31:0] ins;
  input [4:0] EXDest, MADest, WBDest;
  input [37:0] WBResult;
  output [105:0] IDResult;
  reg [105:0] IDResult;
  output [34:0] IFControl;

  wire WBResultValid;
  wire [4:0] WBResultDest;
  wire [31:0] WBResultSrc;

  assign WBResultValid = WBResult[37];
  assign WBResultDest = WBResult[36:32];
  assign WBResultSrc = WBResult[31:0];

  reg IDResultValid;
  wire [3:0] IDResultOpcode;
  reg [4:0] IDResultDest;
  wire [31:0] IDResultRec1;
  wire [31:0] IDResultRec2;
  reg [31:0] IDResultImm;

  reg IFControlValid;
  reg IFControlBranch;
  reg IFControlStop;
  reg [31:0] IFControlAddress;

  reg [31:0] innerIns;
  reg inner;
  always @(posedge clk) begin
  if (!delay) begin
    if (reset) begin
      inner <= 1'b0;
      innerIns <= 0;
    end else begin
      if (IFControlValid) begin
        inner <= 1'b0;
        innerIns <= 0;
      end else if (!inner) begin
        inner <= 1'b1;
        innerIns <= ins;
      end
    end
  end
  end

  reg [31:0] curIns;

  always @(*) begin
  if (!delay) begin
    if (!inner)
      curIns <= ins;
    else
      curIns <= innerIns;
  end
  end

  reg [4:0] regAddress1, regAddress2;
  always @(*) begin
  if (!delay) begin
    if (curIns[31:28]==4'b1011 || curIns[31:28]==4'b1100 ||
        curIns[31:28]==4'b1101 || curIns[31:28]==4'b1110 || curIns[31:28]==4'b1111) begin
      regAddress1 <= curIns[27:23];
      regAddress2 <= 0;
      IDResultDest <= 0;
      IDResultImm <= {9'b000000000, curIns[22:0]};
    end else if (curIns[31:28]==4'b1001) begin
      regAddress1 <= curIns[27:23];
      regAddress2 <= curIns[22:18];
      IDResultDest <= 0;
      IDResultImm <= {{15{curIns[17]}}, curIns[16:0]};
    end else if (curIns[31:28]==4'b0100 || curIns[31:28]==4'b0101 ||
        curIns[31:28]==4'b0110 || curIns[31:28]==4'b0111 || curIns[31:28]==4'b1000) begin
      regAddress1 <= curIns[22:18];
      regAddress2 <= 0;
      IDResultDest <= curIns[27:23];
      IDResultImm <= {{15{curIns[17]}}, curIns[16:0]};
    end else if (curIns[31:28]==4'b0001 || curIns[31:28]==4'b0010 ||
        curIns[31:28]==4'b0011) begin
      regAddress1 <= curIns[22:18];
      regAddress2 <= curIns[17:13];
      IDResultDest <= curIns[27:23];
      IDResultImm <= 0;
    end else if (curIns[31:28]==4'b1010) begin
      regAddress1 <= 0;
      regAddress2 <= 0;
      IDResultDest <= 0;
      IDResultImm <= {4'b0000, curIns[27:0]};
    end else begin
      regAddress1 <= 0;
      regAddress2 <= 0;
      IDResultDest <= 0;
      IDResultImm <= 0;
    end
  end
  end

  Register registers(.clk(clk), .reset(reset), .rin1(regAddress1), .rout1(IDResultRec1),
  .rin2(regAddress2), .rout2(IDResultRec2), .we(WBResultValid),
  .waddr(WBResultDest), .win(WBResultSrc), .delay(delay));

  assign IDResultOpcode = curIns[31:28];

  reg reset_over;
  always @(posedge clk) begin
  if (!delay) begin
    if (reset)
      reset_over <= 0;
    else
      reset_over <= 1;
  end
  end

  always @(*) begin
  if (!delay) begin
    if (reset_over) begin
      IFControlValid <= 1'b1;
    end else begin
      IFControlValid <= 1'b0;
    end

    if (curIns[31:28] == 4'b1011 || curIns[31:28] == 4'b1100 ||
        curIns[31:28] == 4'b1101 || curIns[31:28] == 4'b1110 || curIns[31:28] == 4'b1111) begin
       if ((curIns[27:23] != 0) &&
          ((curIns[27:23] == EXDest) || (curIns[27:23] == MADest) || (curIns[27:23] == WBDest)))
         IFControlValid <= 1'b0;
    end else if (curIns[31:28] == 4'b1001) begin
      if (((curIns[27:23] != 0) &&
          ((curIns[27:23] == EXDest) || (curIns[27:23]==MADest) || (curIns[27:23]==WBDest))) ||
          ((curIns[22:18] != 0) &&
          ((curIns[22:18] == EXDest) || (curIns[22:18]==MADest) || (curIns[22:18]==WBDest))) )
         IFControlValid <= 1'b0;
    end else if (curIns[31:28] == 4'b0100 || curIns[31:28] == 4'b0101 ||
        curIns[31:28] == 4'b0110 || curIns[31:28] == 4'b0111 || curIns[31:28] == 4'b1000) begin
      if ((curIns[22:18] != 0) &&
        ((curIns[22:18] == EXDest) || (curIns[22:18] == MADest) || (curIns[22:18] == WBDest)))
         IFControlValid <= 1'b0;
    end else if (curIns[31:28] == 4'b0001 || curIns[31:28] == 4'b0010 || curIns[31:28] == 4'b0011) begin
      if (((curIns[22:18] != 0) &&
          ((curIns[22:18] == EXDest) || (curIns[22:18] == MADest) || (curIns[22:18] == WBDest))) ||
          ((curIns[17:13] != 0) &&
          ((curIns[17:13] == EXDest) || (curIns[17:13] == MADest) || (curIns[17:13] == WBDest))))
         IFControlValid <= 1'b0;
    end
  end
  end

  //if branch
  always @(*) begin
  if (!delay) begin
    IFControlBranch <= 1'b0;
    IFControlAddress <= 32'h00000000;
    if (curIns[31:28]==4'b1010) begin
      IFControlBranch <= 1'b1;
      IFControlAddress <= {4'b0000, curIns[27:0]};
      IFControlStop <= 1'b1;
    end else if (curIns[31:28]==4'b1011 || curIns[31:28]==4'b1100 ||
        curIns[31:28]==4'b1101 || curIns[31:28]==4'b1110 || curIns[31:28]==4'b1111) begin
          //IFControlStop <= 1'b0;
          if ((curIns[27:23] != EXDest) &&
              (curIns[27:23] != MADest) && (curIns[27:23] != WBDest)) begin
            case(curIns[31:28])
              4'b1011 : begin
                  if (IDResultRec1 == 0) begin
                    IFControlBranch <= 1'b1;
                    IFControlAddress <= {9'b000000000, curIns[22:0]};
                    IFControlStop <= 1'b1;
                  end
                end
              4'b1100 : begin
                  if (IDResultRec1[31] == 0 && IDResultRec1[30:0] != 0) begin
                    IFControlBranch <= 1'b1;
                    IFControlAddress <= {9'b000000000, curIns[22:0]};
                    IFControlStop <= 1'b1;
                  end
                end
              4'b1101 : begin
                  if (IDResultRec1[31] == 1) begin
                    IFControlBranch <= 1'b1;
                    IFControlAddress <= {9'b000000000, curIns[22:0]};
                    IFControlStop <= 1'b1;
                  end
                end
              4'b1110 : begin
                  if (IDResultRec1[31] == 0) begin
                    IFControlBranch <= 1'b1;
                    IFControlAddress <= {9'b000000000, curIns[22:0]};
                    IFControlStop <= 1'b1;
                  end
                end
            endcase
          end
    end
  end
  end

  always @(posedge clk) begin
  if (!delay) begin
  /*
  if (curIns[31:28]==4'b1011 || curIns[31:28]==4'b1100 ||
      curIns[31:28]==4'b1101 || curIns[31:28]==4'b1110 || curIns[31:28]==4'b1111) begin
        //$display("ID: bxxz %b = %d~~~", curIns, curIns[22:0]);
        //$display("\t\t EXDest = %d, MADest = %d, WBDest = %d.", EXDest, MADest, WBDest);
      end
  */
  if (reset)
      IDResultValid <= 0;
    else
      IDResultValid <= IFControlValid;
  end
  end

  assign IFControl[34] = IFControlValid;
  assign IFControl[33] = IFControlBranch;
  assign IFControl[32] = IFControlStop;
  assign IFControl[31:0] = IFControlAddress;

  always @(*) begin
  if (!delay) begin
    if (reset) begin
      IFControlStop <= 0;
    end
  end
  end

  always @(posedge clk) begin
  if (!delay) begin
    if (reset) begin
      IDResult <= 0;
    end else if (IFControlStop) begin
      IFControlStop <= 0;
    end else begin

      if (IFControlStop) begin
        IFControlStop <= 0;
      end else begin
        IDResult[105] <= IFControlValid;
      end

      IDResult[104:101] <= IDResultOpcode;
      IDResult[100:96] <= IDResultDest;
      IDResult[95:64] <= IDResultRec1;
      IDResult[63:32] <= IDResultRec2;
      IDResult[31:0] <= IDResultImm;
    end
  end
  end

endmodule
