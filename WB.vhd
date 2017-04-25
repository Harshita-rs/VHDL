----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:15:22 04/20/2015 
-- Design Name: 
-- Module Name:    WB - Behavioral 
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

entity WB is
port( 
		clk,rst 		: in STD_LOGIC;
		MDR,Aluout 	: in STD_ULOGIC_VECTOR(31 downto 0);
		opcode 		: in STD_ULOGIC_VECTOR(5 downto 0);
	
		Wrt_Val 		: out STD_ULOGIC_VECTOR(31 downto 0)	
    );
end WB;

architecture Behavioral of WB is

begin
process(clk,rst)
begin

if(rst = '1') then
	null;
else
	if(rising_edge(clk) and rst ='0') then
		case opcode is
			when "100011" => Wrt_Val <= MDR;
			when "101011" => null;
			when others   => Wrt_Val <= Aluout;
		end case;
	end if;
end if;
end process;
end Behavioral;

