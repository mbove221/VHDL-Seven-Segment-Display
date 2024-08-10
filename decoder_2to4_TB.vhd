-------------------------------------------------------------------------------
--
-- Title       : decoder_2to4_tb
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\decoder_2to4_TB.vhd
-- Generated   : Tue Apr 30 12:37:48 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This This is the testbench for the decoder_2to4 entity, which is part of ESE 382 Spring 2024 Lab 11 Design Task 3
	--This self-checking testbench will make sure the 1 is in the appropraite position for our output y vector based on
	--b and a, where b is the MSB and a is the LSB
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {decoder_2to4_tb} architecture {tb_architecture}}


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
entity decoder_2to4_tb is
end decoder_2to4_tb;

--}} End of automatically maintained section

architecture tb_architecture of decoder_2to4_tb is
constant period : time := 20 ns;
--input signals b (MSB) and a (LSB)
signal b, a : std_logic;
--output signal y
signal y : std_logic_vector(3 downto 0); 
begin 
	--UUT port map
	UUT : entity decoder_2to4
		port map(b => b, a => a, y => y);
	
	SIMULUS : process
	begin
		--iterate through all possible values (i.e. 0 through 3)
		for i in 0 to 2**2 - 1 loop
			(b, a) <= to_unsigned(i, 2);
			wait for period;  
			--check if 1 gets shifted left each time
			assert y = (std_logic_vector(to_unsigned(2**i, 4)))
			report "Error with input a = " & std_logic'image(a) & " b = " & std_logic'image(b) & " y = " & to_string(y)
			severity error;
		end loop;
		std.env.finish; --end the testbench
	end process;

end tb_architecture;