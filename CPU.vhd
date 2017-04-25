----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:23:08 04/12/2015 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
port(
		clk,rst 						: in STD_LOGIC;
		PC,IR,Mem_read 			: in STD_ULOGIC_VECTOR(31 downto 0);
		
		Mem_add,Mem_write,NPC 	: out STD_ULOGIC_VECTOR(31 downto 0);
		Sel 							: out STD_LOGIC
	 );
end CPU;

architecture Behavioral of CPU is

component PC4
port( 
		PC  							: in STD_ULOGIC_VECTOR(31 downto 0);
		PCplus4 						: out STD_ULOGIC_VECTOR(31 downto 0)
    );
end component;

component ID 
port(
		clk,rst 						: in STD_LOGIC;
		IR,PC,Wrt_Val 				: in STD_ULOGIC_VECTOR(31 downto 0);
		
		opcode 						: out STD_ULOGIC_VECTOR(5 downto 0);
		shft							: out STD_ULOGIC_VECTOR(4 downto 0);
		RA,RB,Reg_Offset 			: out STD_ULOGIC_VECTOR(31 downto 0);
		Mem_write 					: out STD_ULOGIC_VECTOR(31 downto 0)
	 );
end component;

component EX
port(
		clk,rst 						: in STD_LOGIC;
		PC,RA,RB,Reg_Offset		: in STD_ULOGIC_VECTOR(31 downto 0);
		opcode 						: in STD_ULOGIC_VECTOR(5 downto 0);
		shft							: in STD_ULOGIC_VECTOR(4 downto 0);
		
		NPC, Aluout 				: out STD_ULOGIC_VECTOR(31 downto 0)
	 );
end component;

component MM
port( 
		clk,rst						: in STD_LOGIC;
		opcode 						: in STD_ULOGIC_VECTOR(5 downto 0);
		RA, Aluout 					: in STD_ULOGIC_VECTOR(31 downto 0);		
		Mem_read 					: in STD_ULOGIC_VECTOR(31 downto 0);
		
		Mem_write 					: out STD_ULOGIC_VECTOR(31 downto 0);
		MDR 							: out STD_ULOGIC_VECTOR(31 downto 0);
		Mem_add 						: out STD_ULOGIC_VECTOR(31 downto 0);
		sel 							: out STD_LOGIC
	 );
end component;

component WB
port( 
		clk,rst 						: in STD_LOGIC;
		MDR,Aluout 					: in STD_ULOGIC_VECTOR(31 downto 0);
		opcode 						: in STD_ULOGIC_VECTOR(5 downto 0);
	
		Wrt_Val 						: out STD_ULOGIC_VECTOR(31 downto 0)	
    );
end component;

signal RA,RB,Reg_RT,Reg_Offset,Aluout,Wrt_Val,MDR,PCplus4,NFC : STD_ULOGIC_VECTOR(31 downto 0);
signal opcode : STD_ULOGIC_VECTOR(5 downto 0);
signal shft	  : STD_ULOGIC_VECTOR(4 downto 0);

begin

A1 : PC4 port map(PC,PCplus4);
A2 : ID port map(clk,rst,IR,PCplus4,Wrt_Val,opcode,shft,RA,RB,Reg_Offset,Reg_RT);
A3 : EX port map(clk,rst,PCplus4,RA,RB,Reg_Offset,opcode,shft,NFC,Aluout);
A4 : MM port map(clk,rst,opcode,Reg_RT,Aluout,Mem_read,Mem_write,MDR,Mem_add,sel);
A5 : WB port map(clk,rst,MDR,Aluout,opcode,Wrt_val);

end Behavioral;

