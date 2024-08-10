-------------------------------------------------------------------------------
--
-- Title       : hex_seven
-- Design      : lab10
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 10\lab10\lab10\src\task3.vhd
-- Generated   : Tue Apr 23 13:00:48 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the description file to map a 4-bit hexadecimal input to a 7-bit code to map to segments a-g for a 7-segment display
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {hex_seven} architecture {behavior}}


library ieee;
use ieee.std_logic_1164.all;
entity hex_seven is
	port(
	hex : in std_logic_vector(3 downto 0); --hexadecimal input
	-- segs. a...g right justified
	seg_drive : out std_logic_vector(7 downto 0)
	);
end hex_seven;

--}} End of automatically maintained section

architecture behavior of hex_seven is
begin 
	process(hex)
	begin										 --map created by looking at what bits turn on for what digit
		case hex is								--map hex to segs a...g using 7 LSBs (7 rightmost bits)
			when "0000" => seg_drive <= "01111110";	--0
			when "0001" => seg_drive <= "00110000";	--1
			when "0010" => seg_drive <= "01101101";	--2
			when "0011" => seg_drive <= "01111001";	--3
			when "0100" => seg_drive <= "00110011";	--4
			when "0101" => seg_drive <= "01011011";	--5
			when "0110" => seg_drive <= "01011111"; --6
			when "0111" => seg_drive <= "01110000"; --7
			when "1000" => seg_drive <= "01111111"; --8
			when "1001" => seg_drive <= "01111011"; --9
			when "1010" => seg_drive <= "01110111"; --A
			when "1011" => seg_drive <= "00011111"; --B
			when "1100" => seg_drive <= "01001110"; --C
			when "1101" => seg_drive <= "00111101"; --D
			when "1110" => seg_drive <= "01001111"; --E
			when others => seg_drive <= "01000111"; --F	
		end case;
	end process;
			

end behavior;
