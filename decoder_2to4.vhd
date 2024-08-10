-------------------------------------------------------------------------------
--
-- Title       : decoder_2to4
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\decoder_2to4.vhd
-- Generated   : Tue Apr 30 00:12:38 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the VHDL source file for ESE 382 Spring 2024 Design Task 3.
	--The goal of this entity is to assign a 1 to a specific position in our y output vector and 0s to other spots
	--This will act as a load select in our top level design
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {decoder_2to4} architecture {behavior}}


library ieee;
use ieee.std_logic_1164.all;
entity decoder_2to4 is 
	port(
	b : in std_logic; -- most significant address bit
	a : in std_logic; -- least significant address bit
	y : out std_logic_vector(3 downto 0) -- selected output asserted high
);
end decoder_2to4;

--}} End of automatically maintained section

architecture with_select of decoder_2to4 is
begin
	with std_logic_vector'(b,a) select
	y <= "0001" when "00", --when 00 (pos 0)
		"0010" when "01", -- when 01 (pos 1)
		"0100" when "10", --when 10	(pos 2)
		"1000" when others;	--when 11 (pos 3) 
end with_select;
