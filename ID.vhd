----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:31:18 04/17/2015 
-- Design Name: 
-- Module Name:    ID - Behavioral 
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

entity ID is
port(
		clk,rst 						: in STD_LOGIC;
		IR,PC,Wrt_Val 				: in STD_ULOGIC_VECTOR(31 downto 0);
		
		opcode 						: out STD_ULOGIC_VECTOR(5 downto 0);
		shft							: out STD_ULOGIC_VECTOR(4 downto 0);
		RA,RB,Reg_Offset 			: out STD_ULOGIC_VECTOR(31 downto 0);
		Mem_write 					: out STD_ULOGIC_VECTOR(31 downto 0)
	 );
end ID;

architecture Behavioral of ID is

type array_type is array (0 to 31) of STD_ULOGIC_VECTOR(31 downto 0);
signal GPREG	 					:		  array_type; 
signal op	 						:		  STD_ULOGIC_VECTOR(5 downto 0);
signal RS,RT,RD					:		  STD_ULOGIC_VECTOR(4 downto 0);
signal Imm		 				 	:		  STD_ULOGIC_VECTOR(15 downto 0);
signal Reg_off 				 	:		  STD_ULOGIC_VECTOR(25 downto 0);
signal PC_4 					 	:		  STD_ULOGIC_VECTOR(3 downto 0);
signal test 					 	:		  STD_LOGIC;

begin
process(clk,rst)
begin
op 	<= IR(31 downto 26);
PC_4 	<= PC(31 downto 28); 	--4 bits from MSB of PC

-- at reset state registers are initialized
if(rst = '1') then
	GPREG(0)  <= "00000000000000000000000000000000";
--lw 		$s1,100($t2)		--$s1=R17 $t2=R10
	GPREG(17) <= "00000000000000000000000000000000";			
	GPREG(10) <= "00000000000000000000000001101100";			
--sw 		$t6,200($t2)		--$t6=R14 $t2=R10
	GPREG(14) <= "00010101011111000001010111111111";			
	GPREG(10) <= "00000000000000000000000110111000";		
--add		$s2,$t4,$s4			--$s2=R18 $t4=R12 $s4=R20
	GPREG(18) <= "00000000000000000000000000011111";			
	GPREG(12) <= "00000000000000000000000000000010";			
	GPREG(20) <= "00000000000000000000000000000000";
		-- change for BRANCH NOT TAKEN
--beq 	$t5,$t1,200			--$t5=R13 $t1=R9
	GPREG(13) <= "00000000000000000000000000000000";			
	GPREG(9)  <= "00000000000000000000000000000000";			
--xori 	$t3,$s4,100			--$t3=R11 $s4=R20
	GPREG(11) <= "00000000000000000000000000000000";			
	GPREG(20) <= "00000000000000000000000000000000";			
--nor 	$s4,$t1,$t3
	GPREG(20) <= "00000000000000000000000000000000";
	GPREG(9) <= "00000000000000000000000000000000";
	GPREG(11) <= "00000000000000000000000000000000";	
--sll		$s5,$s5,10			--$s5=R22
	GPREG(22) <= "00000000000000000000000110000000";			
--jr 		$s3					--$s3=R19
	GPREG(19) <= "00001100000000011110000000011111";			
			
else

case op is

-- SW instruction : 
when "101011" =>
	if(rising_edge(clk) and (rst ='0')) then
		opcode 	 <= IR(31 downto 26);	
		RS 	 	 <= IR(25 downto 21);
		RT 	 	 <= IR(20 downto 16);
		Imm	 	 <= IR(15 downto 0);
	end if;

	if(falling_edge(clk) and (rst ='0')) then
		RA 		 <= GPREG(to_integer(unsigned(RS)));
		RB 		 <= "0000000000000000" & Imm;
		Mem_write <= GPREG(to_integer(unsigned(RT))); 
	end if;

--R-type : ADD, NOR and SLL Inst
when "000000" =>
	if(rising_edge(clk) and (rst ='0')) then
		opcode 	 <= IR(5 downto 0);	
		RS 	 	 <= IR(25 downto 21);
		RT 	 	 <= IR(20 downto 16);
		RD 	 	 <= IR(15 downto 11);
	end if;

	if(falling_edge(clk) and (rst ='0')) then 
		RA 		 <= GPREG(to_integer(unsigned(RS)));
		RB 		 <= GPREG(to_integer(unsigned(RT)));
		GPREG(to_integer(unsigned(RD))) <= Wrt_Val;
	end if;

-- BEQ instruction
when "000100" =>
	if(rising_edge(clk) and (rst ='0')) then
		opcode 	 <= IR(31 downto 26);
		RS 	 	 <= IR(25 downto 21);
		RT		 	 <= IR(20 downto 16);
		Imm	 	 <= IR(15 downto 0);
	end if;

	if(falling_edge(clk) and (rst ='0')) then
		RA 		 <= GPREG(to_integer(unsigned(RS)));
		RB 		 <= GPREG(to_integer(unsigned(RT)));
		Reg_Offset<= "0000000000000000" & Imm;
	end if;

-- J instruction
when "000010" =>
	if(rising_edge(clk) and (rst ='0')) then
		opcode  	 <= IR(31 downto 26);
		Reg_off 	 <= IR(25 downto 0);
	end if;

	if(falling_edge(clk) and (rst ='0')) then
		Reg_Offset<= PC_4 & Reg_off & "00";			--first 4 bits of current PC & multiply by 4
	end if;

-- JR instruction
when "000101" =>
	if(rising_edge(clk) and (rst ='0')) then
		opcode 	 <= IR(31 downto 26);
		RS 	 	 <= IR(25 downto 21);
	end if;

	if(falling_edge(clk) and (rst ='0')) then
		Reg_Offset<= GPREG(to_integer(unsigned(RS)));
	end if;

-- I-type instructions : LW and XORI Instructions
when others =>
	if(rising_edge(clk) and (rst ='0')) then
		opcode 	 <= IR(31 downto 26);
		RS		 	 <= IR(25 downto 21);
		RT 	 	 <= IR(20 downto 16);
		Imm	 	 <= IR(15 downto 0);
	end if;

	if(falling_edge(clk) and (rst ='0')) then
		RA 		 <= GPREG(to_integer(unsigned(RS)));
		RB 		 <= "0000000000000000" & Imm;
		GPREG(to_integer(unsigned(RT))) <= Wrt_Val;
	end if;
end case;
if(IR(5 downto 0) = "000000") then
		shft		 <= IR(10 downto 6);
end if;		
end if;
end process;
end Behavioral;

