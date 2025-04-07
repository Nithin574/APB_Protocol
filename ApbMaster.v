module ApbMaster #(parameter ADD_WIDTH = 9, WIDTH = 32) (
  input pclk,
  input presetn,
  input transfer,
  input Apb_read_write,
  input [ADD_WIDTH-1 : 0] Apb_addr,
  input [WIDTH-1 : 0] Apb_wdata,
  input [WIDTH-1 : 0] Prdata,
  input Pready,
  output reg Psel_1,
  output Pwrite,
  output reg Penable,
  output [ADD_WIDTH - 1 : 0] Paddr,
  output [WIDTH - 1 : 0] Pwdata,
  output [WIDTH - 1 : 0] Apb_rdata
);
  //-----------------------------------------------
  localparam IDLE = 2'b00,
             SETUP = 2'b01,
             ACCESS = 2'b10;

  //-----------------------------------------------

  //-----------------------------------------------
  reg [1:0] state, next_state;
  //-----------------------------------------------

  //wire declaration
  //-----------------------------------------------
  wire psel;
  //-----------------------------------------------

  //State machine Sequential part
  //------------------------------------------------
  always @(posedge pclk, negedge presetn) begin
    if(!presetn) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end
  //------------------------------------------------
  always @(state, transfer, Pready, psel) begin

    case(state)
      IDLE : begin
        Psel_1 = 1'b00;
        Penable = 1'b0;
        if(transfer) begin
          next_state = SETUP;
        end

        else begin
          next_state = IDLE;
        end
      end

      SETUP : begin
        Psel_1 = psel? 1'b1:1'b0;
        Penable = 1'b0;
        next_state = ACCESS;
      end

      ACCESS : begin
        Psel_1 = psel? 1'b1:1'b0;
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
        Psel_1 = 1'b0;
        Penable = 1'b0;
        next_state = IDLE;
      end
    endcase
  end
  //----------------------------------------------

  //direct module output assignment
  //----------------------------------------------
  assign Pwrite = Apb_read_write;
  assign Pwdata = Apb_wdata;
  assign Paddr = Apb_addr;
  assign Apb_rdata = Prdata;
  //-----------------------------------------------

  //internal signal assignment
  //-----------------------------------------------
  assign psel = Apb_addr[8];
  //-----------------------------------------------
  
endmodule



