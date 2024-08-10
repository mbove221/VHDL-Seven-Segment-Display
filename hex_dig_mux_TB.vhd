-------------------------------------------------------------------------------
--
-- Title       : hex_dig_mux_tb
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\hex_dig_mux_TB.vhd
-- Generated   : Tue Apr 30 13:51:23 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the testbench for the decoder_2to4 entity, which is part of ESE 382 Spring 2024 Lab 11 Design Task 5
	--This self-checking testbench will
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {hex_dig_mux_tb} architecture {tb_architecture}}


library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity hex_dig_mux_tb is
end hex_dig_mux_tb;

--}} End of automatically maintained section

architecture tb_architecture of hex_dig_mux_tb is
constant period : time := 20 ns;
signal hex_dig_0, hex_dig_1, hex_dig_2, hex_dig_3 : std_logic_vector(3 downto 0); --map inputs to mux
signal sel : std_logic_vector(1 downto 0); --used to map which channel we want to select
signal hex_dig_out : std_logic_vector(3 downto 0); --output channel based on inputs
type test_vector is record
	hex_dig_0 : std_logic_vector(3 downto 0); --mux select 0
	hex_dig_1 : std_logic_vector(3 downto 0); --mux select 1
	hex_dig_2 : std_logic_vector(3 downto 0); --mux select 2
	hex_dig_3 : std_logic_vector(3 downto 0); --mux select 3
	sel : std_logic_vector(1 downto 0); --used to map which channel we want to select
	hex_dig_out : std_logic_vector(3 downto 0); --output channel based on inputs
	
end record;

type test_vector_array is array(natural range<>) of test_vector;
--list of applied values we want to apply sequentially
constant test_vectors : test_vector_array:= (
--hex_dig_0, hex_dig_1, hex_dig_2, hex_dig_3, sel, hex_dig_out
("1010",(others => 'X'), (others => 'X'), (others => 'X'), "00", "1010"),
((others => 'X'),"0101", (others => 'X'), (others => 'X'), "01", "0101"),
((others => 'X'), (others => 'X'), "1100", (others => 'X'), "10", "1100"),
((others => 'X'), (others => 'X'), (others => 'X'), "0011", "11", "0011")
);
begin 
	--UUT port map
	UUT : entity hex_dig_mux
		port map(hex_dig_0 => hex_dig_0, hex_dig_1 => hex_dig_1, hex_dig_2 => hex_dig_2, hex_dig_3 => hex_dig_3, sel => sel, hex_dig_out => hex_dig_out);
	
	SIMULUS : process
	begin
		for i in test_vectors'range loop --loop through all possible values sequentially
			--assign values
			hex_dig_0 <= test_vectors(i).hex_dig_0; --assign first hex value
			hex_dig_1 <= test_vectors(i).hex_dig_1; --assign second hex value
			hex_dig_2 <= test_vectors(i).hex_dig_2; --assign third hex value
			hex_dig_3 <= test_vectors(i).hex_dig_3; --assign fourth hex value
			sel <= test_vectors(i).sel;
			--wait for period to update
			wait for period;
			--check if our expected output matches our actual output
			assert hex_dig_out = test_vectors(i).hex_dig_out
			report "Error with hex_dig_0 = " & to_string(hex_dig_0) & " hex_dig_1 = " & to_string(hex_dig_1) 
			& " hex_dig_2 = " & to_string(hex_dig_2) & " hex_dig_3 = " & to_string(hex_dig_3) 
			& CR & LF & "sel = " & to_string(sel) & " hex_dig_out = " & to_string(hex_dig_out) & " should be hex_dig_out = " & to_string(test_vectors(i).hex_dig_out)
			severity error;
		end loop;
		std.env.finish; --end the testbench
	end process;

end tb_architecture;
