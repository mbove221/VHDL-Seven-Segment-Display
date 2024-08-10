-------------------------------------------------------------------------------
--
-- Title       : hex_digit_reg_tb
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\hex_digit_reg_TB.vhd
-- Generated   : Tue Apr 30 11:32:07 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the testbench for the hex_dig_reg entity, which is part of ESE 382 Spring 2024 Lab 11 Design Task 2
	--This self-checking testbench will make sure the hex_dig_reg updates at reset, as well as only updates if there is a rising clock edge
		--and both load enables are set (acting as a storage element)
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {hex_digit_reg_tb} architecture {tb_architecture}}


library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity hex_digit_reg_tb is
end hex_digit_reg_tb;

--}} End of automatically maintained section

architecture tb_architecture of hex_digit_reg_tb is
constant period : time := 20 ns;
signal rst_bar, clk, load_en1, load_en2 : std_logic;
signal hex_dig_in, hex_dig_out : std_logic_vector(3 downto 0);
signal end_sim : boolean := false;
type test_vector is record
	rst_bar : std_logic;
	load_en1 : std_logic;
	load_en2 : std_logic;
	hex_dig_in : std_logic_vector(3 downto 0);
	hex_dig_out : std_logic_vector(3 downto 0);
end record;

type test_vector_array is array(natural range<>) of test_vector;
--list of applied values we want to apply sequentially
constant test_vectors : test_vector_array:= (
--rst_bar, load_en1, load_en2, hex_dig_in, hex_dig_out
('0', 'X', 'X', (others => 'X'), (others => '0')),
('1', '0', 'X', (others => 'X'), (others => '0')),
('1', 'X', '1', (others => 'X'), (others => '0')),
('1', '1', '1', "0101", "0101"),
('1', '0', 'X', (others => 'X'), "0101"),
('1', 'X', '0', (others => 'X'), "0101")
);
begin 
	--UUT port map
	UUT : entity hex_digit_reg
		port map(rst_bar => rst_bar, clk => clk, load_en1 => load_en1, load_en2 => load_en2, hex_dig_in => hex_dig_in, hex_dig_out => hex_dig_out);
	
	clock_gen : process
	begin
		clk <= '0'; --initialize clock to 0
		loop --keep looping
			wait for period/2; --wait to change level for period/2
			clk <= not clk;	--change level
			exit when end_sim = true; --exit loop when sim_end is true (clk no
		end loop;
		wait;
	end process;
	
	SIMULUS : process
	begin
		for i in test_vectors'range loop --loop through all possible values sequentially
			--assign values
			rst_bar <= test_vectors(i).rst_bar;
			load_en1 <= test_vectors(i).load_en1;
			load_en2 <= test_vectors(i).load_en2;
			hex_dig_in <= test_vectors(i).hex_dig_in;
			--wait for period to update
			wait for period;
			--check if our expected output matches our actual output
			assert hex_dig_out = test_vectors(i).hex_dig_out
			report "Error with rst_bar = " & std_logic'image(rst_bar) & " load_en1 = " & std_logic'image(load_en1) 
			& " load_en2 = " & std_logic'image(load_en2) & " hex_dig_in = " & to_string(hex_dig_in) 
			& CR & LF & "hex_dig_out = " & to_string(hex_dig_out)
			severity error;
		end loop;
		end_sim <= true; --set end_sim signal to true (stop clock)
		std.env.finish; --end the testbench
	end process;

end tb_architecture;
