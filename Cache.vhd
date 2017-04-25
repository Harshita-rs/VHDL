----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:14:32 04/20/2015
-- Design Name: 
-- Module Name:    Cache - Behavioral 
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

entity Cache is
    Port ( 	clk,rst 						: in STD_LOGIC;
				I_cache_in,D_cache_in 	: in STD_ULOGIC_VECTOR(255 downto 0);
				npc_in 						: in STD_ULOGIC_VECTOR(31 downto 0);
				D_addr 						: in STD_ULOGIC_VECTOR(31 downto 0);
				ldsw 							: in STD_LOGIC; 								--'0'=>Load, '1'=>Store
				rdy_inst,rdy_data 		: in STD_LOGIC;
				data_in 						: in STD_ULOGIC_VECTOR(31 downto 0);
				
				I_cache_out,D_cache_out : out STD_ULOGIC_VECTOR(31 downto 0);
				I_hit,rd_inst 				: out STD_LOGIC;
				iaddr_out 					: out STD_ULOGIC_VECTOR(31 downto 0);
			  	D_hit 						: out STD_LOGIC;
				rd_data,wt_data 			: out STD_LOGIC;
				daddr_out 					: out STD_ULOGIC_VECTOR(31 downto 0));
end Cache;

architecture Behavioral of Cache is

type MEM_I is array (511 downto 0) of STD_ULOGIC_VECTOR(7 downto 0 );
type MEM_D is array (255 downto 0) of STD_ULOGIC_VECTOR(7 downto 0 );
signal IC_MEM 					: MEM_I := (OTHERS => "00000000");
signal DC_MEM 					: MEM_D := (OTHERS => "00000000");
signal npc_int 				: integer ;
signal daddr_int 				: integer;
signal I_blk,D_blk 			: integer;
signal IC_blk,DC_blk 		: integer;
signal IC_temp,DC_temp 		: integer;
signal go_read 				: STD_LOGIC;
begin
npc_int <= to_integer(unsigned(npc_in));
daddr_int <= to_integer(unsigned(D_addr));
	D_blk <= daddr_int / 16;
	DC_blk <= D_blk mod 16;
	DC_temp <= DC_blk * 16;
--------------------------I-Cache process-----------
I_cache : process (clk, rst)
begin

if rst = '1' then
I_hit <= '0';
I_cache_out <= (OTHERS=> '0');
I_blk <= npc_int / 16;
IC_blk <= I_blk mod 32;
IC_temp <= IC_blk * 16;

else if rising_edge(clk) and rst = '0' then
--------------------------Inst Write Cycle---------------
if (IC_MEM(IC_temp + 0) & IC_MEM(IC_temp + 1) & IC_MEM(IC_temp + 2) & IC_MEM(IC_temp + 3)) /= "00000000000000000000000000000000" then
	I_hit <= '1';
	rd_inst <='0';
else 
	I_hit <= '0';
	rd_inst <= '1';
	iaddr_out <= npc_in;
if rdy_inst = '1' then
if I_cache_in(7 downto 0) /= "UUUUUUUU" then
for I in 0 to 15 loop
	IC_MEM(IC_temp + I) <= I_cache_in((8*(I+1)-1)downto(8*I));
end loop;
end if;
end if;
end if;
end if;
--------------------------Inst Read cycle-----------------
if falling_edge(clk) and rst = '0' then
	I_cache_out <= IC_MEM(IC_temp + 0) & IC_MEM(IC_temp + 1) & IC_MEM(IC_temp + 2) & IC_MEM(IC_temp + 3);
end if;
end if;
end process;
--------------------------D-Cache process-------------------
D_cache : process (clk, rst)
begin

if rst = '1' then
	D_hit <= '0';
	rd_data <= '0';
	wt_data <= '0';
	D_cache_out <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
	go_read <= '0';
	
else 
if rising_edge(clk) and rst = '0' then

if D_addr /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
--------------------------Write Cycle--------------------------
if (DC_MEM(DC_temp + 0) & DC_MEM(DC_temp + 1) & DC_MEM(DC_temp + 2) & DC_MEM(DC_temp + 3)) /= "00000000000000000000000000000000" then
	D_hit <= '1';
	go_read <= '1';
	rd_data <= '0';
	---------------------------Store Hit Operation--------------
	if ldsw = '1' then
	for k in 0 to 3 loop
		DC_MEM(DC_temp + k) <= data_in((8*(k+1)-1)downto(8*k));
	end loop;
	wt_data <= '1';
	daddr_out <= D_addr;
	end if;
else
	---------------------------Load Operation--------------------
	D_hit <= '0';
	if ldsw = '0' then 
	rd_data <= '1';
	daddr_out <= D_addr;
	if rdy_data = '1' then
	if D_cache_in(7 downto 0) /= "UUUUUUUU" then
	for J in 0 to 15 loop
		DC_MEM(DC_temp + J) <= D_cache_in((8*(J+1)-1)downto(8*J));
		go_read <= '1';
	end loop;
	end if;
	end if;
	else	
	---------------------------Store Miss Operation--------------
	if ldsw = '1' then
	wt_data <= '1';
	daddr_out <= D_addr;
	end if;
	end if;
end if;
end if;
end if;
--------------------------Read cycle----------------------------
if falling_edge(clk) and rst = '0' then
	if D_addr /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
	---------------------------Read only for Load operation------
	if ldsw = '0' then
			if go_read = '1' then
		D_cache_out <= DC_MEM(DC_temp + 0) & DC_MEM(DC_temp + 1) & DC_MEM(DC_temp + 2) & DC_MEM(DC_temp + 3);
			end if;
	end if;
end if;
end if;
end if;

end process;
end Behavioral;

