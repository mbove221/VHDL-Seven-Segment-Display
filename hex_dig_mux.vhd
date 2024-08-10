-------------------------------------------------------------------------------
--
-- Title       : hex_dig_mux
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\hex_dig_mux.vhd
-- Generated   : Tue Apr 30 00:38:36 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This design description is for ESE 382 Spring 2024 Lab 11 Design Task 5
	--The objective is to select a specific mux input channel (i.e. hex_dig_0 when input is "00")
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {hex_dig_mux} architecture {behavior}}


library ieee;
use ieee.std_logic_1164.all;
entity hex_dig_mux is 
	port(
	hex_dig_0 : in std_logic_vector(3 downto 0); -- mux input vectors
	hex_dig_1 : in std_logic_vector(3 downto 0);
	hex_dig_2 : in std_logic_vector(3 downto 0);
	hex_dig_3 : in std_logic_vector(3 downto 0);
	sel : in std_logic_vector(1 downto 0);-- multiplexer select inputs
	hex_dig_out : out std_logic_vector(3 downto 0) -- multiplexer output
);
end hex_dig_mux;

--}} End of automatically maintained section

architecture with_select of hex_dig_mux is
begin
	with sel select --use select statement
	hex_dig_out <= hex_dig_0 when "00", --basically just assign values to hex_dig_out based on the current select "sel" value (i.e. 1-3 in binary)
				hex_dig_1 when "01",
				hex_dig_2 when "10",
				hex_dig_3 when others; --when "11" essentially
end with_select;
	  