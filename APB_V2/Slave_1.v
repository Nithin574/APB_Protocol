module Slave_1 #(
  parameter                     ADD_WIDTH = 9,
  parameter                     WIDTH = 32
)(
  //Global Signals
  //---------------------------------------------------------------------------
  input                         Pclk,
  input                         Presetn,
  //---------------------------------------------------------------------------

  //From Master
  //---------------------------------------------------------------------------
  input                         Psel,
  input                         Penable,
  input                         Pwrite,
  input [WIDTH / 8 - 1 : 0]     Pstrb,
  input [ADD_WIDTH - 2 : 0]     Paddr,
  input [WIDTH - 1 : 0]         Pwdata,
  //---------------------------------------------------------------------------

  //To Master
  //---------------------------------------------------------------------------
  output reg [WIDTH - 1 : 0]    Prdata,
  output  Pready
  //---------------------------------------------------------------------------
);

  //Memory Depth calculation
  //---------------------------------------------------------------------------
  localparam DEPTH = 2 ** (ADD_WIDTH - 1);
  //---------------------------------------------------------------------------

  //Memory Definition
  //---------------------------------------------------------------------------
  reg [WIDTH - 1 : 0] mem [0 : DEPTH - 1];
  //---------------------------------------------------------------------------

  //Read Opration
  //---------------------------------------------------------------------------
  always @(posedge Pclk) begin
    if(!Presetn)
      Prdata <= 'b0;
    else begin
          if(Psel && Penable) begin
            if(!Pwrite)
          Prdata <=  mem[Paddr];
          end
          else begin
            Prdata <= 1'b0;
          end
    end
  end
  //---------------------------------------------------------------------------

  //write opertion
  //---------------------------------------------------------------------------
  always @(posedge Pclk) begin
    if(Psel && Penable) begin
      if(Pwrite) begin
        if(Pstrb[0] == 1'b1) mem[Paddr][7:0]   <= Pwdata[7:0];
        if(Pstrb[1] == 1'b1) mem[Paddr][15:8]  <= Pwdata[15:8];
        if(Pstrb[2] == 1'b1) mem[Paddr][23:16] <= Pwdata[23:16];
        if(Pstrb[3] == 1'b1) mem[Paddr][31:24] <= Pwdata[31:24];
      end
    end
  end
  //---------------------------------------------------------------------------

  //Pready assignment based on sel and enable
  //---------------------------------------------------------------------------
  assign Pready = Psel && Penable;
  //---------------------------------------------------------------------------

endmodule
