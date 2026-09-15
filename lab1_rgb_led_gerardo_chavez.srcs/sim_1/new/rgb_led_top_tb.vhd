----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2026 07:36:58 PM
-- Design Name: 
-- Module Name: rgb_led_top_tb - Behavioral
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
library work;
use work.testing_pkg.all;

entity rgb_led_top_tb is
--  Port ( );
end rgb_led_top_tb;

architecture Behavioral of rgb_led_top_tb is
  signal sys_clk_tb : STD_LOGIC;
  signal rst_tb     : STD_LOGIC;
  signal sw_tb      : STD_LOGIC_VECTOR(2 downto 0);
  signal rgb_out_tb : STD_LOGIC_VECTOR(2 downto 0);
begin

  DUT : entity work.rgb_led_top(Behavioral)
      generic map (CLK_CYCLES_PER_TOGGLE => 10)
      port map (
          sys_clk => sys_clk_tb,
          rst     => rst_tb,
          sw      => sw_tb,
          rgb_out => rgb_out_tb
      );
      
  ------------------------------------------------------------------------------
  -- Clock Generation (125 MHz)
  ------------------------------------------------------------------------------
  clk_gen(sys_clk_tb, 125.0e6);

  ------------------------------------------------------------------------------
  -- Test Cases Process
  ------------------------------------------------------------------------------
  test_cases : process
      variable padding : STD_LOGIC_VECTOR(28 downto 0) := (others => '0');
  begin
    simulation_start(pads("RGB LED Top Test"), 5);
    
    rst_tb <= '1';
    sw_tb  <= "000";
    wait for 40 ns;
    
    --------------------------------------------------------------------------
    -- Test Case 1: Reset Behavior
    --------------------------------------------------------------------------
    rst_tb <= '1';
    sw_tb  <= "001";
    wait for 30 ns;
    compare(pads("TEST CASE 1: Reset Behavior"), x"00000000", x"00000000", padding & rgb_out_tb);
    
    --------------------------------------------------------------------------
    -- Test Case 2: Red Channel Selection & Blinking (SW0 = '1')
    --------------------------------------------------------------------------
    rst_tb <= '0';
    sw_tb  <= "001"; -- Select Red
    wait until rising_edge(rgb_out_tb(0)); -- wait for red to toggle high
    wait for 1 ns;
    compare(pads("TEST CASE 2: Red LED Active"), x"00000001", x"00000001", padding & rgb_out_tb);
    
    --------------------------------------------------------------------------
    -- Test Case 3: Green Channel Selection & Blinking (SW1 = '1')
    --------------------------------------------------------------------------
    sw_tb <= "010"; -- Select Green
    wait for 20 ns; -- Let it toggle
    wait until rising_edge(rgb_out_tb(1)); -- wait for green to toggle high
    wait for 1 ns;
    compare(pads("TEST CASE 3: Green LED Active"), x"00000002", x"00000002", padding & rgb_out_tb);
    
    --------------------------------------------------------------------------
    -- Test Case 4: Blue Channel Selection & Blinking (SW2 = '1')
    --------------------------------------------------------------------------
    sw_tb <= "100"; -- Select Blue
    wait for 20 ns; 
    wait until rising_edge(rgb_out_tb(2)); -- wait for blue to toggle high
    wait for 1 ns;
    compare(pads("TEST CASE 4: Blue LED Active"), x"00000004", x"00000004", padding & rgb_out_tb);
    
    --------------------------------------------------------------------------
    -- Test Case 5: Multiple Switches Enabled
    --------------------------------------------------------------------------
    sw_tb <= "011"; -- Multiple switches (SW0 and SW1 active)
    wait for 30 ns;
    compare(pads("TC5: Multiple Switches OFF"), x"00000000", x"00000000", padding & rgb_out_tb);

    simulation_done(0);
    wait;
  end process;
end Behavioral;
