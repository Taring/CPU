module Cache(clk, reset, over, rin, le, rout, we, waddr, win, delay);
  input clk, le, we, reset, over;
  input [31:0] win;
  input [15:0] rin, waddr;
  output [31:0] rout;
  reg [31:0] rout;

  reg [134:0] C[255:0];
  integer i;
  initial begin
      for (i = 0; i < 256; i = i + 1)
        C[i] <= 0;
  end

  wire [5:0] readTag, writeTag;
  wire [1:0] readOffset, writeOffset;
  wire [7:0] readIndex, writeIndex;

  assign readTag = rin[15:10];
  assign readIndex = rin[9:2];
  assign readOffset = rin[1:0];

  assign writeTag = waddr[15:10];
  assign writeIndex = waddr[9:2];
  assign writeOffset = waddr[1:0];

  output delay;
  reg delay;
  initial begin
    delay = 1'b0;
  end

  wire d_delay, wa;
  wire [127:0] readOut, writeOut;
  Memory Memory0(.clk(clk), .over(over), .rin1({readTag,readIndex,2'b00}), .rout1(readOut),
           .rin2({writeTag, writeIndex, 2'b00}), .rout2(writeOut),
           .le(le), .we(we), .waddr(waddr), .win(win), .delay(d_delay), .wa(wa));
/*
  always @(posedge clk) begin
    $display("Cache: load : %d, store : %d\n", le, we);
  end
*/
  always @(*) begin
  //$display("Cache: load : %d, store : %d\n", le, we);
    if (le) begin
      //delay <= d_delay;
      //$display("Cache: load delay <- %d", d_delay);
      //if (!d_delay)
        //$display("Cache: wrong answer <- %d", wa);
      if (C[readIndex][128]) begin
        if (C[readIndex][134:129] == readTag) begin
          case (readOffset)
            2'b00 : rout <= C[readIndex][31:0];
            2'b01 : rout <= C[readIndex][63:32];
            2'b10 : rout <= C[readIndex][95:64];
            2'b11 : rout <= C[readIndex][127:96];
          endcase
          delay <= 1'b0;
          //$display("SIGH");
        end else begin
        //$display("Cache: lw error 2");
          //if (!wa) begin
          C[readIndex][134:129] <= readTag;
          C[readIndex][127:0] <= readOut;
          case (readOffset)
            2'b00 : rout <= readOut[31:0];
            2'b01 : rout <= readOut[63:32];
            2'b10 : rout <= readOut[95:64];
            2'b11 : rout <= readOut[127:96];
          endcase
          //end
        end
      end else begin
        //$display("Cache: lw error 3");
        //if (!wa) begin
        C[readIndex][134:129] <= readTag;
        C[readIndex][128] <= 1'b1;
        C[readIndex][127:0] <= readOut;
        case (readOffset)
            2'b00 : rout <= readOut[31:0];
            2'b01 : rout <= readOut[63:32];
            2'b10 : rout <= readOut[95:64];
            2'b11 : rout <= readOut[127:96];
        endcase
        //end
      end
    end
  end

  always @(posedge clk) begin
    if (we) begin
      //delay <= d_delay;
      if (C[writeIndex][128]) begin
        if (C[writeIndex][134:129]==writeTag) begin
        //if (!d_delay) begin
          case (writeOffset)
            2'b00 : C[writeIndex][31:0] = win;
            2'b01 : C[writeIndex][63:32] = win;
            2'b10 : C[writeIndex][95:64] = win;
            2'b11 : C[writeIndex][127:96] = win;
          endcase
        //end
        end else begin
      // if (!d_delay) begin
          C[writeIndex][134:129] <= writeTag;
          C[writeIndex][127:0] <= writeOut;
          case (writeOffset)
            2'b00 : C[writeIndex][31:0] <= win;
            2'b01 : C[writeIndex][63:32] <= win;
            2'b10 : C[writeIndex][95:64] <= win;
            2'b11 : C[writeIndex][127:96] <= win;
          endcase
    //    end
        end
      end else begin
    //    if (!d_delay) begin
        C[writeIndex][134:129] <= writeTag;
        C[writeIndex][128] <= 1'b1;
        C[writeIndex][127:0] <= writeOut;
        case (writeOffset)
          2'b00 : C[writeIndex][31:0] <= win;
          2'b01 : C[writeIndex][63:32] <= win;
          2'b10 : C[writeIndex][95:64] <= win;
          2'b11 : C[writeIndex][127:96] <= win;
        endcase
    //    end
      end
    end
  end

endmodule
