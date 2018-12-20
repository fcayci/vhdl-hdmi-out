-- author: Furkan Cayci, 2018
-- description: hdmi out top module
--    consists of the timing module, clock manager and tgb to tdms encoder
--    three different resolutions are added, selectable from the generic
--    objectbuffer is added that displays 2 controllable 1 stationary objects
--    optional pattern generator is added

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity hdmi_top is
    generic (
        RESOLUTION   : string  := "HD720P"; -- HD720P, SVGA, VGA
        GEN_PATTERN  : boolean := false; -- generate pattern or objects
        GEN_PIX_LOC  : boolean := true; -- generate location counters for x / y coordinates
        OBJECT_SIZE  : natural := 16;   -- size of the objects. should be higher than 11
        PIXEL_SIZE   : natural := 24    -- RGB pixel total size. (R + G + B)
    );
    port(
        clk, rst : in std_logic;
        -- tmds output ports
        clk_p : out std_logic;
        clk_n : out std_logic;
        data_p : out std_logic_vector(2 downto 0);
        data_n : out std_logic_vector(2 downto 0)
    );
end hdmi_top;

architecture rtl of hdmi_top is

    component clock_gen is
    generic (
        CLKIN_PERIOD :    real := 8.000;  -- input clock
        CLK_MULTIPLY : integer := 8;      -- multiplier
        CLK_DIVIDE   : integer := 1;      -- divider
        CLKOUT0_DIV  : integer := 8;      -- serial clock divider
        CLKOUT1_DIV  : integer := 40      -- pixel clock divider
    );
    port(
        clk_i  : in  std_logic; --  input clock
        clk0_o : out std_logic; -- serial clock
        clk1_o : out std_logic  --  pixel clock
    );
    end component;

    component rgb2tmds is
    port(
        -- reset and clocks
        rst : in std_logic;
        pixelclock : in std_logic;  -- slow pixel clock 1x
        serialclock : in std_logic; -- fast serial clock 5x

        -- video signals
        video_data : in std_logic_vector(23 downto 0);
        video_active  : in std_logic;
        hsync : in std_logic;
        vsync : in std_logic;

        -- tmds output ports
        clk_p : out std_logic;
        clk_n : out std_logic;
        data_p : out std_logic_vector(2 downto 0);
        data_n : out std_logic_vector(2 downto 0)
    );
    end component;

    component timing_generator is
        generic (
            RESOLUTION   : string  := "HD720P"; -- HD720P, SVGA, VGA
            GEN_PIX_LOC  : boolean := true;
            OBJECT_SIZE  : natural := 16
        );
        port(
            clk           : in  std_logic;
            hsync, vsync  : out std_logic;
            video_active  : out std_logic;
            pixel_x       : out std_logic_vector(OBJECT_SIZE-1 downto 0);
            pixel_y       : out std_logic_vector(OBJECT_SIZE-1 downto 0)
        );
    end component;

    component pattern_generator is
    port(
        clk          : in  std_logic;
        video_active : in  std_logic;
        rgb          : out std_logic_vector(23 downto 0)
    );
    end component;

    component objectbuffer is
    generic (
        OBJECT_SIZE : natural := 16;
        PIXEL_SIZE  : natural := 24;
        RES_X : natural := 1280;
        RES_Y : natural := 720
    );
    port (
        video_active       : in  std_logic;
        pixel_x, pixel_y   : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
        object1x, object1y : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
        object2x, object2y : in  std_logic_vector(OBJECT_SIZE-1 downto 0);
        backgrnd_rgb       : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
        rgb                : out std_logic_vector(PIXEL_SIZE-1 downto 0)
    );
    end component;

    signal pixclk, serclk : std_logic;
    signal video_active   : std_logic := '0';
    signal video_data     : std_logic_vector(PIXEL_SIZE-1 downto 0);
    signal vsync, hsync   : std_logic := '0';
    signal pixel_x        : std_logic_vector(OBJECT_SIZE-1 downto 0);
    signal pixel_y        : std_logic_vector(OBJECT_SIZE-1 downto 0);
    signal object1x       : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(500, OBJECT_SIZE));
    signal object1y       : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(140, OBJECT_SIZE));
    signal object2x       : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(240, OBJECT_SIZE));
    signal object2y       : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(340, OBJECT_SIZE));
    signal backgrnd_rgb   : std_logic_vector(PIXEL_SIZE-1 downto 0) := x"FFFF00"; -- yellow

begin

    -- generate 1x pixel and 5x serial clocks
    timing_hd720p: if RESOLUTION = "HD720P" generate
    begin
    clock: clock_gen
        generic map ( CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>59, CLK_DIVIDE=>5, CLKOUT0_DIV=>4, CLKOUT1_DIV=>20 ) -- 720p
        port map ( clk_i=>clk, clk0_o=>serclk, clk1_o=>pixclk );
    end generate;

    timing_vga: if RESOLUTION = "SVGA" generate
    begin
    clock: clock_gen
        generic map ( CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>8, CLK_DIVIDE=>1, CLKOUT0_DIV=>5, CLKOUT1_DIV=>25 ) -- 800x600
        port map ( clk_i=>clk, clk0_o=>serclk, clk1_o=>pixclk );
    end generate;

    timing_svga: if RESOLUTION = "VGA" generate
    begin
    clock: clock_gen
        generic map ( CLKIN_PERIOD=>8.000, CLK_MULTIPLY=>8, CLK_DIVIDE=>1, CLKOUT0_DIV=>8, CLKOUT1_DIV=>40 ) -- 640x480
        port map ( clk_i=>clk, clk0_o=>serclk, clk1_o=>pixclk );
    end generate;

    -- video timing
    timing: timing_generator
        generic map ( RESOLUTION => RESOLUTION, GEN_PIX_LOC => GEN_PIX_LOC, OBJECT_SIZE => OBJECT_SIZE )
        port map( clk=>pixclk, hsync=>hsync, vsync=>vsync, video_active=>video_active, pixel_x=>pixel_x, pixel_y=>pixel_y );

    -- tmds signaling
    tmds_signaling: rgb2tmds  port map(
        rst=>rst, pixelclock=>pixclk, serialclock=>serclk,
        video_data=>video_data, video_active=>video_active, hsync=>hsync, vsync=>vsync,
        clk_p=>clk_p, clk_n=>clk_n, data_p=>data_p, data_n=>data_n
    );

    -- pattern generator
    gp: if GEN_PATTERN = true generate
    begin
    pattern: pattern_generator port map ( clk=>pixclk, video_active=>video_active, rgb=>video_data);
    end generate;

    -- game object buffer
    go: if GEN_PATTERN = false generate
    begin
    objbuf: objectbuffer generic map ( OBJECT_SIZE=>OBJECT_SIZE, PIXEL_SIZE =>PIXEL_SIZE )
        port map ( video_active=>video_active, pixel_x=>pixel_x, pixel_y=>pixel_y,
            object1x=>object1x, object1y=>object1y,
            object2x=>object2x, object2y=>object2y,
            backgrnd_rgb=>backgrnd_rgb, rgb=>video_data
       );
    end generate;

end rtl;
