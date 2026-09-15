----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2026 07:01:37 PM
-- Design Name: 
-- Module Name: rgb_led_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rgb_led_top is
    Generic ( CLK_CYCLES_PER_TOGGLE : integer := 62_500_000 );
    Port ( sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (2 downto 0);
           rgb_out : out STD_LOGIC_VECTOR (2 downto 0));
end rgb_led_top;
  
architecture Behavioral of rgb_led_top is
  signal red_en   : STD_LOGIC;
  signal green_en : STD_LOGIC;
  signal blue_en  : STD_LOGIC;
begin
  red_en   <= '1' when sw = "001" else '0';
  green_en <= '1' when sw = "010" else '0';
  blue_en  <= '1' when sw = "100" else '0';
  
  -- Red LED Instance
  LED_RED : entity work.blinking_led(Behavioral)
  generic map (CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE)
  port map (
    sys_clk => sys_clk,
    rst     => rst,
    led_en  => red_en,
    led_out => rgb_out(0)
  );
    
  -- Green LED Instance
  LED_GREEN : entity work.blinking_led(Behavioral)
  generic map (CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE)
  port map (
    sys_clk => sys_clk,
    rst     => rst,
    led_en  => green_en,
    led_out => rgb_out(1)
  );
    
  -- Blue LED Instance
  LED_BLUE : entity work.blinking_led(Behavioral)
  generic map (CLK_CYCLES_PER_TOGGLE => CLK_CYCLES_PER_TOGGLE)
  port map (
    sys_clk => sys_clk,
    rst     => rst,
    led_en  => blue_en,
    led_out => rgb_out(2)
  );
            
end Behavioral;
