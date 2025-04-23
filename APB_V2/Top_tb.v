module Top_tb #(parameter ADD_WIDTH = 9, WIDTH = 32) ();

  reg                    pclk;
  reg                    presetn;
  reg                    transfer;
  reg                    Req_read_write;
  reg  [WIDTH/8-1 : 0]   Req_pstrb;
  reg  [ADD_WIDTH-1 : 0] Req_addr;
  reg  [WIDTH-1 : 0]     Req_wdata;
  wire [WIDTH-1 : 0]     Req_rdata;

  // Instantiate the Top module
  Top #(.ADD_WIDTH(ADD_WIDTH), .WIDTH(WIDTH)) dut (
    .pclk            (pclk),
    .presetn         (presetn),
    .transfer        (transfer),
    .Req_read_write  (Req_read_write),
    .Req_pstrb       (Req_pstrb),
    .Req_addr        (Req_addr),
    .Req_wdata       (Req_wdata),
    .Req_rdata       (Req_rdata)
  );

  // Clock generation
  always #5 pclk = ~pclk;

  initial begin
    // Initialize inputs
    pclk = 0;
    presetn = 0;
    transfer = 0;
    Req_read_write = 0;
    Req_pstrb = 0;
    Req_addr = 0;
    Req_wdata = 0;

    // Apply reset
    #10 presetn = 1;

    // Display signals during simulation
    $monitor("Time=%0t | pclk=%b | presetn=%b | transfer=%b | Req_read_write=%b | Req_addr=%h | Req_wdata=%h | Req_rdata=%h",
             $time, pclk, presetn, transfer, Req_read_write, Req_addr, Req_wdata, Req_rdata);


    // Slave 1
    //write test
    //-----------------------------------------------------------------------------------------------------------------
    transfer = 1;
    //strobe=1111
    #20 Req_read_write = 1; Req_pstrb = 4'b1111; Req_addr = 9'h000; Req_wdata = 32'h00000000;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=1110
    #20 Req_read_write = 1; Req_pstrb = 4'b1110; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=1101
    #20 Req_read_write = 1; Req_pstrb = 4'b1101; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=1011
    #20 Req_read_write = 1; Req_pstrb = 4'b1011; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=0111
    #20 Req_read_write = 1; Req_pstrb = 4'b0111; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=0000
    #20 Req_read_write = 1; Req_pstrb = 4'b0000; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end
    //strobe=0001
    #20 Req_read_write = 1; Req_pstrb = 4'b0001; Req_addr = 9'h003; Req_wdata  = 32'h00000003;
    repeat(2) begin
      #20 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end
    //-----------------------------------------------------------------------------------------------------------------

    //Read transfer
    #20 Req_read_write = 0; Req_addr = 9'h000;
    repeat(14) begin
      #20 Req_addr = Req_addr + 1'b1;
    end
    transfer = 0;
    #10;
    //-----------------------------------------------------------------------------------------------------------------

    //Slave 2
    //write test
    //-----------------------------------------------------------------------------------------------------------------
    transfer = 1;
    //strobe=1111
    #10 Req_read_write = 1; Req_pstrb = 4'b1111; Req_addr = 9'h100; Req_wdata = 32'h00000000;
    repeat(2) begin
      #50 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=1110
    #50 Req_read_write = 1; Req_pstrb = 4'b1110; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #50 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=1101
    #50 Req_read_write = 1; Req_pstrb = 4'b1101; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #50 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=1011
    #50 Req_read_write = 1; Req_pstrb = 4'b1011; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #50 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=0111
    #50 Req_read_write = 1; Req_pstrb = 4'b0111; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #50 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end

    //strobe=0000
    #50 Req_read_write = 1; Req_pstrb = 4'b0000; Req_addr = Req_addr + 1'b1; Req_wdata = Req_wdata + 1'b1;;
    repeat(2) begin
      #50 Req_addr = Req_addr + 1'b1;
          Req_wdata = Req_wdata + 1'b1;
    end
    //-----------------------------------------------------------------------------------------------------------------

    //Read transfer
    //-----------------------------------------------------------------------------------------------------------------
    #50 Req_read_write = 0; Req_addr = 9'h100;
    repeat(14) begin
      #50 Req_addr = Req_addr + 1'b1;
    end
    transfer = 0;
    #10;
    //-----------------------------------------------------------------------------------------------------------------

    #50 $finish;

  end

endmodule
