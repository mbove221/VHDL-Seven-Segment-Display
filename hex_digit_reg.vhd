-------------------------------------------------------------------------------
--
-- Title       : hex_digit_reg
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\hex_digit_reg.vhd
-- Generated   : Tue Apr 30 00:09:01 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This VHDL Source file is part of ESE 382 Spring 2024 Lab 11 Design Task 2
--The goal of this entity is to update the hex_dig_out output signal to hex_dig_in when both load_enable signals are set
--as well as rst_bar = '1', and there is a positive clock edge
	

--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {hex_digit_reg} architecture {behavior}}


library ieee;
use ieee.std_logic_1164.all;
entity hex_digit_reg is
	port(
	rst_bar : in std_logic; -- asynchronous reset
	clk : in std_logic; -- system clock
	load_en1 : in std_logic; -- enable load
	load_en2 : in std_logic; -- enable load
	hex_dig_in : in std_logic_vector(3 downto 0); -- received data in
	hex_dig_out : out std_logic_vector(3 downto 0) -- received data out
);
end hex_digit_reg;

--}} End of automatically maintained section

architecture behavior of hex_digit_reg is
begin
	process(clk, rst_bar)
	begin
		if rst_bar = '0' then --asynchronous reset has priority
			hex_dig_out <= (others => '0'); --reset hex_dig_out to all 0s upon reset
		elsif rising_edge(clk) and load_en1 = '1' and load_en2 = '1' then --check for rising edge and both enables are set
			hex_dig_out <= hex_dig_in; --update hex_dig_out to whatever hex_dig_in is if condition is met
		end if;
	end process;
end behavior;
