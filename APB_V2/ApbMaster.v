module ApbMaster #(
  parameter                     ADD_WIDTH = 9,
  parameter                     WIDTH = 32
)(
  //Global Signals
  //---------------------------------------------------------------------------
  input                         pclk,
  input                         presetn,
  //---------------------------------------------------------------------------

  //from requester
  //---------------------------------------------------------------------------
  input                         transfer,
  input                         Req_read_write,
  input [WIDTH / 8 - 1 : 0]     Req_Pstrb,
  input [ADD_WIDTH-1 : 0]       Req_addr,
  input [WIDTH-1 : 0]           Req_wdata,
  //---------------------------------------------------------------------------

  //From ApbSlave
  //---------------------------------------------------------------------------
  input [WIDTH-1 : 0]           Prdata,
  input                         Pready,
  //---------------------------------------------------------------------------

  //To ApbSlave
  //---------------------------------------------------------------------------
  output reg                    Psel_1,
  output reg                    Psel_2,
  output                        Pwrite,
  output reg                    Penable,
  output [WIDTH / 8 - 1 : 0]    Pstrb,
  output [ADD_WIDTH - 2 : 0]    Paddr,
  output [WIDTH - 1 : 0]        Pwdata,
  //---------------------------------------------------------------------------

  //Master to Requester
  //---------------------------------------------------------------------------
  output [WIDTH - 1 : 0]        Req_rdata
  //---------------------------------------------------------------------------
);

  //state parameter
  //---------------------------------------------------------------------------
  localparam IDLE   = 2'b00,
             SETUP  = 2'b01,
             ACCESS = 2'b10;
  //---------------------------------------------------------------------------

  //State register
  //---------------------------------------------------------------------------
  reg [1:0] state;
  reg [1:0] next_state;
  //---------------------------------------------------------------------------

  //wire declaration
  //---------------------------------------------------------------------------
  wire psel;
  //---------------------------------------------------------------------------

  //State machine Sequential part
  //---------------------------------------------------------------------------
  always @(posedge pclk, negedge presetn) begin
    if(!presetn) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end
  //---------------------------------------------------------------------------

  //State machine Combinational part
  //---------------------------------------------------------------------------
  always @(state, transfer, Pready, psel) begin

    case(state)
      IDLE : begin
        Psel_1  = 1'b0;
        Psel_2  = 1'b0;
        Penable = 1'b0;
        if(transfer) begin
          next_state = SETUP;
        end

        else begin
          next_state = IDLE;
        end
      end

      SETUP : begin
        Psel_1     = psel? 1'b0:1'b1;
        Psel_2     = psel? 1'b1:1'b0;
        Penable    = 1'b0;
        next_state = ACCESS;
      end

      ACCESS : begin
        Psel_1     = psel? 1'b0:1'b1;
        Psel_2     = psel? 1'b1:1'b0;
        Penable = 1'b1;

        if(Pready) begin
          if(transfer) begin
            next_state = SETUP;
          end

          else begin
            next_state = IDLE;
          end
        end

        else begin
          next_state = ACCESS;
        end
      end
      default : begin
        Psel_1     = 1'b0;
        Penable    = 1'b0;
        next_state = IDLE;
      end
    endcase
  end
  //---------------------------------------------------------------------------

  //internal signal assignment
  //---------------------------------------------------------------------------
  assign psel = Req_addr[ADD_WIDTH - 1];
  //---------------------------------------------------------------------------

  //direct module output assignment
  //---------------------------------------------------------------------------
  assign Pwrite    = Req_read_write;
  assign Pwdata    = Req_wdata;
  assign Pstrb     = Req_Pstrb;
  assign Paddr     = Req_addr[ADD_WIDTH - 2:0];
  assign Req_rdata = Prdata;
  //---------------------------------------------------------------------------

endmodule
