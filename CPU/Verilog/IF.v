module IF(clk, reset, IFControl, ins, over, delay);
  input clk, reset, delay;
  input [34:0] IFControl;

  output [31:0] ins;
  reg [31:0] ins;
  output over;
  reg over;

  reg [31:0] PC;

  wire IFControlValid;
  wire IFControlBranch;
  wire IFControlStop;
  wire [31:0] IFControlBranchAddress;
  assign IFControlValid = IFControl[34];//not stall or yep
  assign IFControlBranch = IFControl[33];//branch taken or not
  assign IFControlStop = IFControl[32];//be killed and deleted
  assign IFControlBranchAddress = IFControl[31:0];//move to address

  wire [31:0] ins_out;

  Ins Inst_Memory(.address(PC[13:2]), .out(ins_out));

  always @(*) begin
    if (!delay) begin
      if (reset)
        over <= 0;
      else if (!over)
        over <= (ins_out[31:28] == 4'b1111);
    end
  end

  reg ins_flag;//should not be reset
  always @(posedge clk) begin
    if (!delay) begin
    if (reset)
      ins_flag <= 0;
    else
      ins_flag <= 1;
    end
  end

  //ins changes
  always @(posedge clk) begin
  //$display("=w=: %d address is %d \n", delay, ins_out[31:28]);
  if (!delay) begin
    if (reset) begin
      ins <= 0;
    end else if (IFControlStop) begin
      ins <= 0;
    end else if (!over && ins_flag && !(ins_out[31:28] == 4'b1111)) begin
      //$display("~~~~~:address is %d \n", ins_out[31:28]);
      ins <= ins_out;
    end else begin
      ins <= 32'h00000000;
    end
  end
  end

  //PC changes
  always @(posedge clk) begin
  if (!delay) begin
    if (reset) begin
      //$display("reset in IF\n");
      PC <= 0;
    end else if (IFControlBranch) begin
      PC <= IFControlBranchAddress;
    end else if (IFControlValid) begin
      PC <= PC + 4;
    end else begin
      PC <= PC;
    end
  end
  end

endmodule

module Ins(address, out);
    input [11:0] address;
    output [31:0] out;

    reg [31:0] Ins[4095:0];
    initial
    begin
        $readmemb("Ins.vlog", Ins);
        //$display("Instruction Connected");
    end

    assign out = Ins[address];
endmodule
