# hdmi-out-rtl
HDMI Out VHDL code for Xilinx FPGAs. Tested on Arty-Z7-20, Pynq-Z1, and Pynq-Z2.

Supports 720p (1280x720), SVGA (800x600), and VGA (640x480) modes. Consists of a clock generator, timing generator, tmds encoder, and a serializer. The serial cock runs at 5x the pixel clock and uses OSERDES blocks.

Two patterns are added that are selectable on synthesizing.

- a rainbow color pattern - just shows the color spectrum
- an object buffer - generates a wall, a box, and a ball. Wall is the stationary object, and box / ball are movable objects using the position signals. Background can also be changed from top level

An example constraints file is added. On Arty and Pynq-Z1 boards, it works fine. There is an on/off problem on Pynq-Z2 board. (This problem does not happen when the clock is generated from ZYNQ IO PLL.)

A basic top level testbench is added to generate approximately 1 frame of data.