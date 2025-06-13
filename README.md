This project implements a UART (Universal Asynchronous Receiver/Transmitter) module in Verilog, featuring both transmission and reception logic.

## Features
- Full-duplex UART communication (TX and RX)
- Parameterizable baud rate (typically 9600 bps)
- Works with 1 start bit, 8 data bits, 1 stop bit (8N1 format)
- Synchronous design — no separate baud rate generator module

## Module Descriptions

### uart_tx.v
- Takes 8-bit parallel data
- Serializes it with start/stop bits
- Outputs serial data via tx_out
- Begins transmission when tx_start is high

### uart_rx.v
- Monitors serial input on rx_in
- Reconstructs incoming byte when valid data is detected
- Outputs data and sets rx_ready flag

## Known Errors
- RX is not recieving data even as TX is transmitting.
- uart_txd is stuck at 0 for many cycles.

## Output
RTL Schematic:
Output Waveform:
