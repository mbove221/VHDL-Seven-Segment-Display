-------------------------------------------------------------------------------
--
-- Title       : rx_buff_reg
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\rx_buff_reg.vhd
-- Generated   : Tue Apr 30 00:02:06 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the VHDL source file for Design Task 1 for ESE 382 Spring 2024 Lab 11
	--This source file describes the functionality of the buffer register, called
	--rx_buff_reg, which loads the received input data on a rising clock edge if the load enable is set 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {rx_buff_reg} architecture {behavior}}


library ieee;
use ieee.std_logic_1164.all;
entity rx_buff_reg is
port(
	rst_bar : in std_logic; -- asynchronous reset
	clk : in std_logic; -- system clock
	load_en : in std_logic; -- enable shift
	rx_buff_in : in std_logic_vector(7 downto 0); -- received data in
	rx_buff_out : out std_logic_vector(7 downto 0) -- received data out
);
end rx_buff_reg;

--}} End of automatically maintained section

architecture behavior of rx_buff_reg is
begin
	process(rst_bar, clk) --sensitive to rst_bar (async reset) and clk (system clock)
	begin
		if rst_bar = '0' then --if rst_bar is set, reset rx_buff_out to all 0s
			rx_buff_out <= (others => '0');
		elsif rising_edge(clk) then	--otherwise on a rising clock edge
			if load_en = '1' then  --if load_en is set, the output gets the input data
				rx_buff_out <= rx_buff_in;
			end if;
		end if;
	end process;


end behavior;
