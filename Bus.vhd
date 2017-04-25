----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:27:21 04/20/2015 
-- Design Name: 
-- Module Name:    Bus - Behavioral 
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

entity Bus_module is
Port ( 
	   clk,rst 		: in STD_LOGIC;
	   idc_in 		: in STD_ULOGIC_VECTOR (255 downto 0);
      irdy_in 		: in STD_LOGIC;
      drdy_in		: in STD_LOGIC;
      ir_in 		: in STD_LOGIC;
      dr_in 		: in STD_LOGIC;
      dw_in 		: in STD_LOGIC;
	   sdata_in 	: in STD_ULOGIC_VECTOR (31 downto 0);
      iaddr_in 	: in STD_ULOGIC_VECTOR (31 downto 0);
      daddr_in 	: in STD_ULOGIC_VECTOR (31 downto 0);

	   sdata_out 	: out STD_ULOGIC_VECTOR (31 downto 0);
      idc_out 		: out STD_ULOGIC_VECTOR (255 downto 0);
      irdy_out 	: out STD_LOGIC;
      drdy_out 	: out STD_LOGIC;
      ir_out 		: out STD_LOGIC;
      dr_out 		: out STD_LOGIC;
      dw_out 		: out STD_LOGIC;
      iaddr_out 	: out STD_ULOGIC_VECTOR (31 downto 0);
      daddr_out 	: out STD_ULOGIC_VECTOR (31 downto 0)
	);
end Bus_module;

architecture Behavioral of Bus_module is

signal clk_counter: integer := 1;
signal clk_value : integer;
signal clk_temp1, clk_temp2: integer;
begin

process (clk, rst)
begin

if rst = '1' then
	irdy_out <= '0';
	drdy_out <= '0';
	ir_out <= '0';
	dr_out <= '0';
	dw_out <= '0';

else
	if rising_edge(clk)  then

		idc_out <= idc_in;
		iaddr_out <= iaddr_in;
		daddr_out <= daddr_in;
		sdata_out <= sdata_in;

		if ir_in = '1' then
			clk_counter <= clk_counter +1;
			if clk_counter = 13 then
				ir_out <= '1';
				irdy_out <= '1';
			end if;
			if clk_counter = 15 then
				ir_out <= '0';
				irdy_out <= '0';
				clk_counter <= 1;
			end if;
		end if;

		if dr_in = '1' then
			clk_counter <= clk_counter +1;
			if clk_counter = 13 then
				dr_out <= '1';
				drdy_out <= '1';
			end if;
			if clk_counter = 15 then
				dr_out <= '0';
				drdy_out <= '0';
				clk_counter <= 1;
			end if;
		end if;
	
		if dw_in = '1' then
			clk_counter <= clk_counter +1;
			if clk_counter = 16 then
				dw_out <= '1';
			end if;
			if clk_counter = 18 then
				dw_out <= '0';
			end if;
		end if;
	end if;
end if;
end process;
end Behavioral;

