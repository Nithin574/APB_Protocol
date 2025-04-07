module Slave_1 #(parameter ADD_WIDTH = 9, WIDTH = 32)(
  input Pclk,
  input Presetn,
  input Psel,
  input Penable,
  input Pwrite,
  input [ADD_WIDTH - 2 : 0]Paddr,
  input [WIDTH - 1 : 0]Pwdata,
  output reg [WIDTH - 1 : 0] Prdata,
  output  Pready 
);

  //------------------------------------------------
  localparam DEPTH = 2 ** 4;
  //------------------------------------------------
  
  //------------------------------------------------
  reg [7:0]reg_addr;
  reg [WIDTH - 1 : 0] mem [0 : DEPTH - 1];
  //------------------------------------------------
 
  //Read Opration
  //-------------------------------------------------
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
  //--------------------------------------------------
  
  //write opertion
  //--------------------------------------------------
  always @(posedge Pclk) begin
    if(Psel && Penable) begin
	    if(Pwrite)
          mem[Paddr] <= Pwdata;
	  end  
  end
  //---------------------------------------------------
  
  //---------------------------------------------------
  assign Pready = Psel && Penable;
  //---------------------------------------------------

endmodule


