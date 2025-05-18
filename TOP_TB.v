`timescale 1ns/1ps

module UART_Top_tb;

    // Parameters
    parameter UART_CLK_FREQ = 150_000_000; // UART Input Clock Frequency (150 MHz)
    parameter BAUD_RATE = 3_000_000;       // Desired Baud Rate (3 Mbps)
    parameter OVERSAMPLING = 16;           // Oversampling factor (16×)

    // Testbench signals
    reg CLK;
    reg RST;
    reg [7:0] TDATA;
    reg NEWD;
    wire DONETX;
    wire DONERX;
    wire [7:0] DOUT;

    // Clock generation (150 MHz system clock)
    initial CLK = 0;
    always #3.333 CLK = ~CLK; // 150 MHz clock (period = 6.6667 ns)

    // Instantiate the Top Module
    UART_Top #(
        .UART_CLK_FREQ(UART_CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLING(OVERSAMPLING)
    ) uut (
        .CLK(CLK),
        .RST(RST),
        .TDATA(TDATA),
        .NEWD(NEWD),
        .DONETX(DONETX),
        .DONERX(DONERX),
        .DOUT(DOUT)
    );

    // Test sequence
    initial begin
        $display("Starting UART_Top_tb simulation...");

        // Initialize inputs
        RST = 1;
        TDATA = 8'h00;
        NEWD = 0;

        // Release reset after a few clock cycles
        #20 RST = 0;

        // Send data from transmitter to receiver
        #10 TDATA = 8'hA5; // Test data
        NEWD = 1;
        #10 NEWD = 0;

        // Wait for transmission and reception to complete
        wait(DONETX == 1);
        wait(DONERX == 1);

        // Check received data
        if (DOUT == 8'hA5) begin
            $display("Data received: %h (PASS)", DOUT);
        end else begin
            $display("Data received: %h (FAIL)", DOUT);
        end

        // End simulation
        $display("Simulation complete.");
        #100;
        $stop;
    end

endmodule