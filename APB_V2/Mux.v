module Mux #(
  parameter WIDTH = 32,
  parameter SLAVE_COUNT = 2
)(
  input      [SLAVE_COUNT-1:0]     sel,
  input      [WIDTH-1:0]           a,
  input      [WIDTH-1:0]           b,
  output reg [WIDTH-1:0]           y
);

  always @(sel, a, b) begin
    case(sel)
      2'b01   : y = a;
      2'b10   : y = b;
      default : y = a;
    endcase
  end 

endmodule
