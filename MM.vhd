----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:15:11 04/20/2015 
-- Design Name: 
-- Module Name:    MM - Behavioral 
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

entity MM is
port	( 
		clk,rst		: in STD_LOGIC;
		opcode 		: in STD_ULOGIC_VECTOR(5 downto 0);
		RA, Aluout 	: in STD_ULOGIC_VECTOR(31 downto 0);		
		Mem_read 	: in STD_ULOGIC_VECTOR(31 downto 0);
		
		Mem_write 	: out STD_ULOGIC_VECTOR(31 downto 0);
		MDR 			: out STD_ULOGIC_VECTOR(31 downto 0);
		Mem_add 		: out STD_ULOGIC_VECTOR(31 downto 0);
		sel 			: out STD_LOGIC
		);
end MM;

architecture Behavioral of MM is
signal mem : STD_ULOGIC_VECTOR(31 downto 0);
begin
process(clk,rst)
begin
if(rst = '1') then
	null;
else
	mem <= RA;
	case opcode is
		when "100011" =>				--LW
			if(falling_edge(clk) and rst ='0') then
				Mem_add <= Aluout;
				MDR <= Mem_read;
				sel <= '0';
			end if;

		when "101011" =>				--SW
			if(rising_edge(clk) and rst ='0') then
				Mem_add <= Aluout;
				sel <= '1';
				Mem_write <= mem;
			end if;

		when others =>
			null;
	end case;
end if;
end process;
end Behavioral;