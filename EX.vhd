----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:04:03 04/20/2015 
-- Design Name: 
-- Module Name:    EX - Behavioral 
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
--use IEEE.NUMERIC_BIT.ALL;



entity EX is
port(
		clk,rst 						: in STD_LOGIC;
		PC,RA,RB,Reg_Offset		: in STD_ULOGIC_VECTOR(31 downto 0);
		opcode 						: in STD_ULOGIC_VECTOR(5 downto 0);
		shft							: in STD_ULOGIC_VECTOR(4 downto 0);
		
		NPC, Aluout 				: out STD_ULOGIC_VECTOR(31 downto 0)
	 );
end EX;

architecture Behavioral of EX is
signal RA_temp, RB_temp, Aluout_temp, shft_temp : integer;
begin

process(clk,rst)
begin

if(rst = '1') then
	null;										--Nothing happens during Reset
else
--EX takes place during Rising edge of clk
	if( rising_edge(clk) and rst ='0') then
		case opcode is

--LW,SW,ADD Instructions
		when "100011" | "101011" | "100000" =>  
			RA_temp <= to_integer(unsigned(RA));
			RB_temp <= to_integer(unsigned(RB));
			Aluout_temp <= RA_temp + RB_temp;
			Aluout <= STD_ULOGIC_VECTOR(to_unsigned(Aluout_temp, 32));
			NPC <= PC; 			 			--NPC is PC+4 (not a Branch Inst)

--BEQ Instruction
		when "000100" =>  
			if (RA = RB) then
				NPC <= Reg_Offset; 		--Branch Taken
			else
				NPC <= PC;  		 		--NPC is PC+4 (Branch Not Taken)
			end if;

--XORI Instruction
		when "001110" =>
			Aluout <= RA xor RB; 
			NPC <= PC;						--NPC is PC+4 (not a Branch Inst)

--NOR Instruction
		when "011011" =>
			Aluout <= RA nor RB;
			NPC <= PC;						--NPC is PC+4 (not a Branch Inst)

--SLL Instruction
		when "000000" =>
			RA_temp <= to_integer(unsigned(RA));
			shft_temp <= to_integer(unsigned(shft));
			for i in 1 to shft_temp loop
				Aluout <= RA(31 downto 0) & "0";
			end loop;	
			Aluout <= STD_ULOGIC_VECTOR(to_unsigned(Aluout_temp, 32));
			NPC <= PC;						--NPC is PC+4 (not a Branch Inst)

--J and JR Instructions
		when others => 
			NPC <= Reg_Offset; 			--Jumps to Target Address
		end case;
	end if;
end if;
end process;
end Behavioral;

