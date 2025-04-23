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
  input  [WIDTH/8-1 : 0]        Req_pstrb,
  input  [ADD_WIDTH-1 : 0]      Req_addr,
  input  [WIDTH-1 : 0]          Req_wdata,
  output [WIDTH-1 : 0]          Req_rdata
  //---------------------------------------------------------------------------
  );

  //Internal wire declaration
  //---------------------------------------------------------------------------
  wire                     Pready;
  wire                     Pready_1;
  wire                     Pready_2;
  wire                     Psel_1;
  wire                     Psel_2;
  wire                     Pwrite;
  wire                     Penable;
  wire [WIDTH/8 - 1 : 0]   Pstrb;
  wire [WIDTH - 1 : 0]     Prdata;
  wire [WIDTH - 1 : 0]     Prdata_1;
  wire [WIDTH - 1 : 0]     Prdata_2;
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
    .Req_Pstrb          (Req_pstrb),
    .Req_addr           (Req_addr),
    .Req_wdata          (Req_wdata),
    .Prdata             (Prdata),
    .Pready             (Pready),
    .Psel_1             (Psel_1),
    .Psel_2             (Psel_2),
    .Pwrite             (Pwrite),
    .Penable            (Penable),
    .Pstrb              (Pstrb),
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
  )slave_1(
    .Pclk               (pclk),
    .Presetn            (presetn),
    .Psel               (Psel_1),
    .Penable            (Penable),
    .Pwrite             (Pwrite),
    .Pstrb              (Pstrb),
    .Paddr              (Paddr),
    .Pwdata             (Pwdata),
    .Prdata             (Prdata_1),
    .Pready             (Pready_1)
  );
  //---------------------------------------------------------------------------

  //Slave 2 Instance
  //---------------------------------------------------------------------------
  Slave_2 #(
    .ADD_WIDTH          (ADD_WIDTH),
    .WIDTH              (WIDTH)
  )slave_2(
    .Pclk               (pclk),
    .Presetn            (presetn),
    .Psel               (Psel_2),
    .Penable            (Penable),
    .Pwrite             (Pwrite),
    .Pstrb              (Pstrb),
    .Paddr              (Paddr),
    .Pwdata             (Pwdata),
    .Prdata             (Prdata_2),
    .Pready             (Pready_2)
  );
  //---------------------------------------------------------------------------

  //Prdata Selection
  //---------------------------------------------------------------------------
  Mux #(
    .WIDTH              (WIDTH),
    .SLAVE_COUNT        (2)
  )Prdata_mux(
    .sel                ({Psel_2,Psel_1}),
    .a                  (Prdata_1),
    .b                  (Prdata_2),
    .y                  (Prdata)
  );
  //---------------------------------------------------------------------------

  //Pready Selection
  //---------------------------------------------------------------------------
  Mux #(
    .WIDTH              (1),
    .SLAVE_COUNT        (2)
  )Pready_mux(
    .sel                ({Psel_2,Psel_1}),
    .a                  (Pready_1),
    .b                  (Pready_2),
    .y                  (Pready)
  );
  //---------------------------------------------------------------------------

endmodule
