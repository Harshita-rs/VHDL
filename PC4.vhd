----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:26:45 04/20/2015 
-- Design Name: 
-- Module Name:    PC4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

entity PC4 is
port( 
		PC  		: in STD_ULOGIC_VECTOR(31 downto 0);
		PCplus4 	: out STD_ULOGIC_VECTOR(31 downto 0)
    );
end PC4;

architecture Behavioral of PC4 is
signal PC_temp,PC4_temp : integer;
begin
process
begin
		PC_temp	<= to_integer(unsigned(PC));
		PC4_temp <= PC_temp + 4;
		PCplus4	<= STD_ULOGIC_VECTOR(to_unsigned(PC4_temp,32));
		wait for 10 ms;
end process;
end Behavioral;

