# vhdl-hdmi-out

HDMI Out driver written in VHDL for Xilinx FPGAs. Only the video side is implemented and audio stuff is not included. Three resolutions are supported. Serial cock runs at 5x the pixel clock and uses `OSERDES` blocks to generate the TMDS signals. Can be used to connect to a DVI input as well since they share the same protocol and timings. 

Project is configured to run at `125 Mhz` clock, but can be configurable from the `clock_gen.vhd` to run at different frequencies. `timing_generator.vhd` generates the the video timing signals: *hsync*, *vsync*, *video_active* as well as the pixel x and y locations. `pattern_generator.vhd` and `objectbuffer.vhd` are used to generate RGB pixel values and `rgb2tmds.vhd` is the top module that handles the conversion from RGB values to TMDS signal outputs.

## Files

```
+- rtl/
| -- hdmi_out.vhd          : hdmi out top module
| -- clock_gen.vhd         : generates pixel (1x) and serial (5x) clocks
| -- timing_generator.vhd  : generates timing signals for a given resolution
| -- rgb2tmds.vhd          : rgb to tmds parent module
| -- tmds_encoder.vhd      : 8b/10b rgb to tmds encoder
| -- serializer.vhd        : 10b tmds signal serializer to be sent out using serial (5x) clock
| -- objectbuffer.vhd      : rgb object generator based on active area
| -- pattern_generator.vhd : rgb color spectrum pattern generator based on active area
+- sim/
| -- tb_hdmi_out.vhd       : testbench for hdmi out module
+- imp/
| -- arty-z7.xdc           : constraints for Arty-Z7 / Pynq-Z1 boards
```

## Features 
* Supports `720p (1280x720)`, `SVGA (800x600)`, and `VGA (640x480)` modes.
* Two patterns are included that are selectable on synthesizing
    * a rainbow color pattern - shows color spectrum
    * an object buffer for a game base - generates a wall, a box, and a ball. Wall is the stationary object, and box / ball are movable objects using the position signals. Background color can also be changed from top level
* Tested on `Arty-Z7-20`, `Pynq-Z1` boards.

## Misc.

* There is an on/off problem on `Pynq-Z2` board when the clock is sourced from 125 Mhz PL clock. The display turns on for ~1 seconds and off for ~1 second. This problem goes away when the clock is generated from ZYNQ IO PLL.