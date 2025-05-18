`timescale 1ns/1ps

module UART_Top #(parameter UART_CLK_FREQ = 150_000_000,   // UART Input Clock Frequency
                            BAUD_RATE = 3_000_000,        // Desired Baud Rate
                            OVERSAMPLING = 16            // Oversampling factor (default is 16×)
)(
    input wire CLK,         // System clock input (e.g., 150 MHz)
    input wire RST,         // Active-high synchronous reset
    input wire [7:0] TDATA, // Data to send from the transmitter
    input wire NEWD,        // New data signal for the transmitter

    output wire DONETX,     // Transmit done signal
    output wire DONERX,     // Receive done signal
    output wire [7:0] DOUT // Data received by the receiver
);

    // Internal signal for interconnection
    wire BCLK;
    wire TX; // TX signal from the transmitter
    wire RX; // RX signal to the receiver

    // Connect the TX of the transmitter to the RX of the receiver
    assign RX = TX;

    baud_gen #(
        .UART_CLK_FREQ(UART_CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLING(OVERSAMPLING)
    ) baud_gen_inst (
        .CLK(CLK),          // System clock input
        .RST(RST),          // Active-high reset
        .BCLK(BCLK)         // Generated baud clock output
    );

    // Instantiate the UART Transmitter
    UART_Tx #(
        .UART_CLK_FREQ(UART_CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLING(OVERSAMPLING)
    ) uart_tx (
        .BCLK(BCLK),
        .RST(RST),
        .NEWD(NEWD),
        .TDATA(TDATA),
        .TX(TX),
        .DONETX(DONETX)
    );

    // Instantiate the UART Receiver
    UART_Rx #(
        .UART_CLK_FREQ(UART_CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLING(OVERSAMPLING)
    ) uart_rx (
        .BCLK(BCLK),
        .RST(RST),
        .RX(RX),
        .DOUT(DOUT),
        .DONERX(DONERX)
    );

endmodule