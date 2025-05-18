################################################################################
# Constraints for the UART Design on xc7z020clg400-2 FPGA
# Merged elements from V1 and V5 constraints files
################################################################################

# Clock Constraints
# Main system clock (CLK) with a period of 6.6667ns (150 MHz)
create_clock -period 6.6667 -name Main_CLK [get_ports CLK]

# Generated clock for BCLK, derived from the main clock
# BCLK frequency = BAUD_RATE * OVERSAMPLING = 48 MHz (divide by 3.125)
# If exact clock generation is not possible, approximate to divide_by 3 (50 MHz).
create_generated_clock -name BCLK -source [get_ports CLK] -divide_by 3 [get_pins baud_gen_inst/BCLK]

################################################################################
# Input Signal Assignments
################################################################################

# Main clock input
set_property PACKAGE_PIN U7 [get_ports CLK]               # Assign CLK to pin U7
set_property IOSTANDARD LVCMOS33 [get_ports CLK]

# Reset signal
set_property PACKAGE_PIN V7 [get_ports RST]               # Assign RST to pin V7
set_property IOSTANDARD LVCMOS33 [get_ports RST]

# UART Receiver signal
set_property PACKAGE_PIN T9 [get_ports RX]                # Assign RX to pin T9
set_property IOSTANDARD LVCMOS33 [get_ports RX]

# UART Transmitter signal
set_property PACKAGE_PIN U10 [get_ports TX]               # Assign TX to pin U10
set_property IOSTANDARD LVCMOS33 [get_ports TX]

# Transmitter new data signal
set_property PACKAGE_PIN W8 [get_ports NEWD]              # Assign NEWD to pin W8
set_property IOSTANDARD LVCMOS33 [get_ports NEWD]

# FIFO Write Enable
set_property PACKAGE_PIN W8 [get_ports WR_EN]             # Assign WR_EN to pin W8
set_property IOSTANDARD LVCMOS33 [get_ports WR_EN]

# FIFO Read Enable
set_property PACKAGE_PIN W10 [get_ports RD_EN]            # Assign RD_EN to pin W10
set_property IOSTANDARD LVCMOS33 [get_ports RD_EN]

# Transmitter data signals (TDATA)
set_property PACKAGE_PIN V8 [get_ports TDATA[0]]          # Assign TDATA[0] to pin V8
set_property PACKAGE_PIN Y8 [get_ports TDATA[1]]          # Assign TDATA[1] to pin Y8
set_property PACKAGE_PIN W7 [get_ports TDATA[2]]          # Assign TDATA[2] to pin W7
set_property PACKAGE_PIN W9 [get_ports TDATA[3]]          # Assign TDATA[3] to pin W9
set_property PACKAGE_PIN U9 [get_ports TDATA[4]]          # Assign TDATA[4] to pin U9
set_property PACKAGE_PIN Y9 [get_ports TDATA[5]]          # Assign TDATA[5] to pin Y9
set_property PACKAGE_PIN W11 [get_ports TDATA[6]]         # Assign TDATA[6] to pin W11
set_property PACKAGE_PIN Y11 [get_ports TDATA[7]]         # Assign TDATA[7] to pin Y11
set_property IOSTANDARD LVCMOS33 [get_ports TDATA[*]]

################################################################################
# Output Signal Assignments
################################################################################

# Receiver data output signals (DOUT / RX_DATA_OUT)
set_property PACKAGE_PIN Y12 [get_ports RX_DATA_OUT[0]]   # Assign RX_DATA_OUT[0] to pin Y12
set_property PACKAGE_PIN Y13 [get_ports RX_DATA_OUT[1]]   # Assign RX_DATA_OUT[1] to pin Y13
set_property PACKAGE_PIN V11 [get_ports RX_DATA_OUT[2]]   # Assign RX_DATA_OUT[2] to pin V11
set_property PACKAGE_PIN V10 [get_ports RX_DATA_OUT[3]]   # Assign RX_DATA_OUT[3] to pin V10
set_property PACKAGE_PIN V6 [get_ports RX_DATA_OUT[4]]    # Assign RX_DATA_OUT[4] to pin V6
set_property PACKAGE_PIN W6 [get_ports RX_DATA_OUT[5]]    # Assign RX_DATA_OUT[5] to pin W6
set_property PACKAGE_PIN T5 [get_ports RX_DATA_OUT[6]]    # Assign RX_DATA_OUT[6] to pin T5
set_property PACKAGE_PIN U5 [get_ports RX_DATA_OUT[7]]    # Assign RX_DATA_OUT[7] to pin U5
set_property IOSTANDARD LVCMOS33 [get_ports RX_DATA_OUT[*]]

# Transmitter done signal
set_property PACKAGE_PIN T10 [get_ports DONETX]           # Assign DONETX to pin W10
set_property IOSTANDARD LVCMOS33 [get_ports DONETX]

# Receiver done signal
set_property PACKAGE_PIN Y10 [get_ports DONERX]           # Assign DONERX to pin Y10
set_property IOSTANDARD LVCMOS33 [get_ports DONERX]

################################################################################
# Additional Constraints
################################################################################

# Ensure unused pins are set to a safe state
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]

# Assign input/output delay constraints for timing analysis
set_input_delay -clock Main_CLK -max 2 [get_ports NEWD]
set_input_delay -clock Main_CLK -max 2 [get_ports RX]
set_output_delay -clock Main_CLK -max 2 [get_ports DONETX]
set_output_delay -clock Main_CLK -max 2 [get_ports TX]

################################################################################
# End of Constraints
################################################################################