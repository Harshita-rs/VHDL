----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:09 04/13/2015 
-- Design Name: 
-- Module Name:    Memory - Behavioral 
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

entity Memory is
Port( 	
		clk,rst 		: in STD_LOGIC;
		r_inst 		: in STD_LOGIC;
		inst_addr 	: in STD_ULOGIC_VECTOR(31 downto 0);
		r_data 		: in STD_LOGIC;
		w_data 		: in STD_LOGIC;
		data_addr 	: in STD_ULOGIC_VECTOR(31 downto 0);
		mem_in 		: in STD_ULOGIC_VECTOR(31 downto 0);
	
		ins_rdy 		: out STD_LOGIC;
		data_rdy 	: out STD_LOGIC;
		mem_out 		: out STD_ULOGIC_VECTOR(255 downto 0)
    );
end Memory;

architecture Behavioral of Memory is
type MEM is array (4095 downto 0) of STD_ULOGIC_VECTOR(7 downto 0);
signal L_MEM 	 	: MEM := (OTHERS => "00000000");
signal iaddr_int 	: integer;
signal daddr_int 	: integer;

begin
iaddr_int 	<= to_integer(unsigned(inst_addr));
daddr_int 	<= to_integer(unsigned(data_addr));

Memory : Process(clk, rst)
begin

if rst = '1' then
--lw $s1,100($t2)
	L_MEM (576) <= "10001101";
	L_MEM (577) <= "01010001";
	L_MEM (578) <= "00000000";
	L_MEM (579) <= "01100100";
--1 byte of Data to be read from memory
	L_MEM (208) <= "01110010";
--sw $t6,200($t2)
	L_MEM (672) <= "10101101";
	L_MEM (673) <= "01001110";
	L_MEM (674) <= "00000000";
	L_MEM (675) <= "11001000";
--add $s2,$t4,$s4
	L_MEM (16) 	<= "00000010";
	L_MEM (17) 	<= "01001100";
	L_MEM (18) 	<= "10100000";
	L_MEM (19) 	<= "00100000";
--beq $t5,$t1,200
	L_MEM(96) 	<= "00010001";
	L_MEM(97) 	<= "10101001";
	L_MEM(98) 	<= "00000000";
	L_MEM(99) 	<= "11001000";
--xori $t3,$s4,100
	L_MEM(192) 	<= "00111010";
	L_MEM(193) 	<= "10001011";
	L_MEM(194) 	<= "00000000";
	L_MEM(195) 	<= "01100100";
--j 400
	L_MEM(128) 	<= "00001000";
	L_MEM(129) 	<= "00000000";
	L_MEM(130) 	<= "00000001";
	L_MEM(131) 	<= "10010000";
--nor $s4,$t1,$t3
	L_MEM(800)	<= "00000001";
	L_MEM(801)	<= "00101011";
	L_MEM(802)	<= "10100000";
	L_MEM(803)	<= "00011011";
--sll $s1,$s1,10
	L_MEM(448) 	<= "00000000";
	L_MEM(449) 	<= "00010001";
	L_MEM(450) 	<= "10001010";
	L_MEM(451) 	<= "10000000";	
--jr $s3
	L_MEM(320) 	<= "00010110";
	L_MEM(321) 	<= "01100000";
	L_MEM(322) 	<= "00000000";
	L_MEM(323) 	<= "00000000";
end if;

if w_data = '1' then
	ins_rdy <= '0';
	data_rdy <= '0';
	for i in 0 to 3 loop
		L_MEM(daddr_int+i) <= mem_in((8*(i+1)-1)downto(8*i));
	end loop;

else 
	if r_inst = '1' then
		ins_rdy <= '1';
		data_rdy <= '0';
		mem_out <= L_MEM(iaddr_int +15) & L_MEM(iaddr_int +14) & L_MEM(iaddr_int +13) & L_MEM(iaddr_int +12) & L_MEM(iaddr_int +11) & L_MEM(iaddr_int +10) & L_MEM(iaddr_int +9) & L_MEM(iaddr_int +8) & L_MEM(iaddr_int +7) & L_MEM(iaddr_int +6) & L_MEM(iaddr_int +5) & L_MEM(iaddr_int +4) & L_MEM(iaddr_int +3) & L_MEM(iaddr_int +2) & L_MEM(iaddr_int +1) & L_MEM(iaddr_int +0) ;

	else 
		if r_data = '1' then
			ins_rdy <= '0';
			data_rdy <= '1';
			mem_out <= L_MEM(daddr_int +15) & L_MEM(daddr_int +14) & L_MEM(daddr_int +13) & L_MEM(daddr_int +12) & L_MEM(daddr_int +11) & L_MEM(daddr_int +10) & L_MEM(daddr_int +9) & L_MEM(daddr_int +8) & L_MEM(daddr_int +7) & L_MEM(daddr_int +6) & L_MEM(daddr_int +5) & L_MEM(daddr_int +4) & L_MEM(daddr_int +3) & L_MEM(daddr_int +2) & L_MEM(daddr_int +1) & L_MEM(daddr_int +0) ;
		end if;
	end if;
end if;
end process;
end Behavioral;



