-- author: Furkan Cayci, 2018
-- description: hdmi out testbench

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_hdmi_out is
end tb_hdmi_out;

architecture rtl of tb_hdmi_out is

    component hdmi_out is
        generic (
            RESOLUTION   : string  := "HD720P"; -- HD720P, SVGA, VGA
            GEN_PATTERN  : boolean := true; -- generate pattern or objects
            GEN_PIX_LOC  : boolean := true;
            PIX_LOC_SIZE : natural := 16
        );
       port(
           clk, rst : in std_logic;
           -- tmds output ports
           tmds_clk_p : out std_logic;
           tmds_clk_n : out std_logic;
           tmds_data_p : out std_logic_vector(2 downto 0);
           tmds_data_n : out std_logic_vector(2 downto 0)
       );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    constant clk_period : time := 8 ns;
    constant reset_time : time :=   20 * clk_period;
    constant hsync_time : time := 1648 * clk_period;
    constant frame_time : time :=  750 * hsync_time;
    signal tmds_clk_p, tmds_clk_n : std_logic;
    signal tmds_data_p, tmds_data_n : std_logic_vector(2 downto 0);

begin

    -- clock generate
    uut0: hdmi_out port map(clk=>clk, rst=>rst, tmds_clk_p=>tmds_clk_p, tmds_clk_n=>tmds_clk_n,
                            tmds_data_p=>tmds_data_p, tmds_data_n=>tmds_data_n);

    process
    begin
        wait for clk_period/2;
        clk <= not clk;
    end process;

    process
    begin
        rst <= '1';
        wait for reset_time;
        rst <= '0';
        wait for frame_time;
        wait;
    end process;

end rtl;
