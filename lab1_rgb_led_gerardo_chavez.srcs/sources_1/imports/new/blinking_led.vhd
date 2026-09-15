----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2026 07:12:57 PM
-- Design Name: 
-- Module Name: blinking_led - Behavioral
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

entity blinking_led is
    generic(CLK_CYCLES_PER_TOGGLE : integer := 62_500_000);
    Port ( sys_clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led_en : in STD_LOGIC;
           led_out : out STD_LOGIC);
end blinking_led;

architecture Behavioral of blinking_led is
  signal led_reg : STD_LOGIC := '0';
begin

  process (sys_clk)
    variable count_var : NATURAL range 0 to CLK_CYCLES_PER_TOGGLE;
  begin
    if rising_edge(sys_clk) then
      if rst = '1' or led_en = '0' then
        count_var := 0;
        led_reg <= '0';
      else
        if count_var = CLK_CYCLES_PER_TOGGLE-1 then
          count_var := 0;
          led_reg <= not led_reg;
        else 
          count_var:= count_var + 1;            
        end if;
      end if;
    end if;
  end process;
  
  led_out <= led_reg;
  

end Behavioral;
