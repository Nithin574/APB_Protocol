module Top #(
  parameter                     ADD_WIDTH = 9,
  parameter                     WIDTH = 32
) (
  //Global signals
  //---------------------------------------------------------------------------
  input                         pclk,
  input                         presetn,
  //---------------------------------------------------------------------------

  //Requester signals
  //---------------------------------------------------------------------------
  input                         transfer,
  input                         Req_read_write,
  input  [ADD_WIDTH-1 : 0]      Req_addr,
  input  [WIDTH-1 : 0]          Req_wdata,
  output [WIDTH-1 : 0]          Req_rdata
  //---------------------------------------------------------------------------
  );

  //Internal wire declaration
  //---------------------------------------------------------------------------
  wire                     Pready;
  wire                     Psel_1;
  wire                     Pwrite;
  wire                     Penable;
  wire [WIDTH - 1 : 0]     Prdata;
  wire [WIDTH - 1 : 0]     Pwdata;
  wire [ADD_WIDTH - 2 : 0] Paddr;
  //---------------------------------------------------------------------------

  //Master Instance
  //---------------------------------------------------------------------------
  ApbMaster #(
    .ADD_WIDTH          (ADD_WIDTH),
    .WIDTH              (WIDTH)
  ) Master(
    .pclk               (pclk),
    .presetn            (presetn),
    .transfer           (transfer),
    .Req_read_write     (Req_read_write),
    .Req_addr           (Req_addr),
    .Req_wdata          (Req_wdata),
    .Prdata             (Prdata),
    .Pready             (Pready),
    .Psel_1             (Psel_1),
    .Pwrite             (Pwrite),
    .Penable            (Penable),
    .Paddr              (Paddr),
    .Pwdata             (Pwdata),
    .Req_rdata          (Req_rdata)
  );
  //---------------------------------------------------------------------------

  //Slave 1 Instance
  //---------------------------------------------------------------------------
  Slave_1 #(
    .ADD_WIDTH          (ADD_WIDTH),
    .WIDTH              (WIDTH)
  )slave(
    .Pclk               (pclk),
    .Presetn            (presetn),
    .Psel               (Psel_1),
    .Penable            (Penable),
    .Pwrite             (Pwrite),
    .Paddr              (Paddr[ADD_WIDTH - 2 : 0]),
    .Pwdata             (Pwdata),
    .Prdata             (Prdata),
    .Pready             (Pready)
  );
  //---------------------------------------------------------------------------

endmodule
