module cpu(clk, reset);
  input clk, reset;

  wire over;
  wire [31:0] ins;
  wire [4:0] EXDest, MADest, WBDest;
  wire [34:0] IFControl;
  wire [105:0] IDResult;
  wire [73:0] EXResult;
  wire [73:0] MAResult;
  wire [37:0] WBResult;
  wire delay;


  IF fetch(.clk(clk), .reset(reset), .IFControl(IFControl), .ins(ins), .over(over), .delay(delay));

  ID decode(.clk(clk), .reset(reset), .ins(ins), .EXDest(EXDest), .MADest(MADest),
                      .WBDest(WBDest), .WBResult(WBResult),
                      .IFControl(IFControl), .IDResult(IDResult), .delay(delay));

  EX alu(.clk(clk), .reset(reset), .IDResult(IDResult), .EXResult(EXResult),
                      .EXDest(EXDest), .delay(delay));

  MA mem(.clk(clk), .reset(reset), .over(over), .EXResult(EXResult), .MAResult(MAResult),
                      .MADest(MADest), .delay(delay));

  WB write_back(.clk(clk), .reset(reset), .MAResult(MAResult),
                      .WBResult(WBResult), .WBDest(WBDest), .delay(delay));

  always @(posedge over) begin
    //$display();
    #555 $finish;
  end
endmodule
