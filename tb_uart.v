`timescale 1ns / 1ps

module uart_tb;

  // Clock parameters
  parameter CLK_FREQ     = 10000000;     // 10 MHz
  parameter BAUD_RATE    = 115200;
  parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
  parameter CLK_PERIOD   = 1000000000 / CLK_FREQ;  // ns

  // DUT I/Os
  reg        r_Clock = 0;
  reg        r_Tx_DV = 0;
  reg [7:0]  r_Tx_Byte = 8'h00;
  wire       w_Tx_Active;
  wire       w_Tx_Serial;
  wire       w_Tx_Done;

  wire       w_Rx_DV;
  wire [7:0] w_Rx_Byte;

  // Clock generation
  always #(CLK_PERIOD/2) r_Clock = ~r_Clock;

  // Instantiate UART Transmitter
  uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_INST (
    .i_Clock(r_Clock),
    .i_Tx_DV(r_Tx_DV),
    .i_Tx_Byte(r_Tx_Byte),
    .o_Tx_Active(w_Tx_Active),
    .o_Tx_Serial(w_Tx_Serial),
    .o_Tx_Done(w_Tx_Done)
  );

  // Instantiate UART Receiver
  uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .i_Clock(r_Clock),
    .i_Rx_Serial(w_Tx_Serial), // Connect TX output to RX input
    .o_Rx_DV(w_Rx_DV),
    .o_Rx_Byte(w_Rx_Byte)
  );

  // Main test sequence
  initial begin
    $display("UART Testbench Start");
    
    // Wait for global reset
    #(10 * CLK_PERIOD);

    // Transmit a byte
    r_Tx_Byte = 8'h3F; // Send 00111111
    r_Tx_DV   = 1'b1;
    #(CLK_PERIOD);
    r_Tx_DV   = 1'b0;

    // Wait for TX to complete
    wait(w_Tx_Done == 1'b1);
    $display("TX Done");

    // Wait for RX to indicate data valid
    wait(w_Rx_DV == 1'b1);
    if (w_Rx_Byte == 8'h3F) begin
      $display("Test PASSED: Received byte = 0x%02X", w_Rx_Byte);
    end else begin
      $display("Test FAILED: Received byte = 0x%02X", w_Rx_Byte);
    end

    #(10 * CLK_PERIOD);
    $finish;
  end

endmodule
