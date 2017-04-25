----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:06:52 04/13/2015 
-- Design Name: 
-- Module Name:    IR - Behavioral 
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

entity IR is
port (
		clk,rst 		: in STD_LOGIC;
		IR_reg 		: in STD_LOGIC_VECTOR(31 downto 0);
		PC 			: in STD_LOGIC_VECTOR(31 downto 0);
		Aluout 		: in STD_LOGIC_VECTOR(31 downto 0);

		Reg_A,Reg_B : out STD_LOGIC_VECTOR(31 downto 0);
		Reg_offst 	: out STD_LOGIC_VECTOR(31 downto 0);
		Mem_write 	: out STD_LOGIC_VECTOR(31 downto 0);
		opcode 		: out STD_LOGIC_VECTOR(5 downto 0);
	  );
end IR;

architecture Behavioral of IR is

begin


end Behavioral;

