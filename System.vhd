----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:14:32 04/20/2015 
-- Design Name: 
-- Module Name:    System - Behavioral 
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

entity System is
Port ( 
		clk,rst 	: in  STD_LOGIC;
      PC 		: in  STD_ULOGIC_VECTOR (31 downto 0);
		
      NPC 		: out  STD_ULOGIC_VECTOR (31 downto 0);
      ihit 		: out  STD_LOGIC;
      dhit 		: out  STD_LOGIC
		);
end System;

architecture Behavioral of System is
component CPU is
port(
		clk,rst 						: in STD_LOGIC;
		PC,IR,Mem_read 			: in STD_ULOGIC_VECTOR(31 downto 0);
		
		Mem_add,Mem_write,NPC 	: out STD_ULOGIC_VECTOR(31 downto 0);
		Sel 							: out STD_LOGIC
	 );
end Component;

component Cache is
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
end component;

component Bus_module is
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
end Component;

component Memory is
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
end Component;

signal pc4, m_addr, m_write, m_write_out, inst_in, data_in : STD_ULOGIC_VECTOR(31 downto 0);
signal sel, ir_in, dr_in, dw_in, ir_out, dr_out, dw_out, irdy_in, drdy_in, irdy_out, drdy_out : STD_LOGIC;
signal iaddr_in, iaddr_out, daddr_in, daddr_out : STD_ULOGIC_VECTOR(31 downto 0);
signal idc_in, idc_out : STD_ULOGIC_VECTOR(255 downto 0);

begin
CPU_Mod : CPU port map(clk,rst,pc4, inst_in, data_in, m_addr, m_write, NPC, sel);
CACHE_Mod : Cache port map(clk, rst, idc_out, idc_out, pc, m_addr, sel, irdy_out, drdy_out, m_write, inst_in, data_in, ihit, ir_in, iaddr_in, dhit, dr_in, dw_in, daddr_in);
BUS_Mod : Bus_module port map (clk, rst, idc_in, irdy_in, drdy_in, ir_in, dr_in, dw_in, m_write, m_write_out,iaddr_in, daddr_in, idc_out, irdy_out, drdy_out, ir_out, dr_out, dw_out, iaddr_out, daddr_out);
MEMORY_Mod : Memory port map (clk, rst, ir_out, iaddr_out, dr_out, dw_out, daddr_out, m_write_out, irdy_in, drdy_in, idc_in);

end Behavioral;

