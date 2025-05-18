`timescale 1ns/1ps

module baud_gen (
    input wire        CLK,        // UART Input Clock (e.g., 150 MHz)
    input wire        RST,        // Active-high synchronous reset
    output reg        BCLK        // Baud Clock (16× the desired baud rate)
);

    // Parameters
    parameter UART_CLK_FREQ = 150_000_000;  // UART Input Clock Frequency (150 MHz)
    parameter BAUD_RATE     = 3_000_000;    // Desired Baud Rate (3 Mbps)
    parameter OVERSAMPLING  = 16;           // Oversampling factor (16× by default)

    // Calculate divisor using the formula:
    // Divisor = UART_CLK_FREQ / (BAUD_RATE × OVERSAMPLING)
    localparam integer DIVISOR = UART_CLK_FREQ / (BAUD_RATE * OVERSAMPLING);

    // Registers
    reg [$clog2(DIVISOR):0] cnt;  // Counter width is based on the divisor value

    always @(posedge CLK) begin
        if (RST) begin
            cnt  <= 0;
            BCLK <= 0;
        end else begin
            if (cnt == DIVISOR - 1) begin
                cnt  <= 0;        // Reset counter
                BCLK <= ~BCLK;    // Toggle BCLK
            end else begin
                cnt <= cnt + 1;   // Increment counter
            end
        end
    end

endmodule