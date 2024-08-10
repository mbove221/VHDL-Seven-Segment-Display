-------------------------------------------------------------------------------
--
-- Title       : rx_buff_reg_tb
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\rx_buff_reg_TB.vhd
-- Generated   : Tue Apr 30 10:22:36 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the testbench for the rx_buff_reg entity, which is part of ESE 382 Spring 2024 Lab 11 Design Task 1
	--This self-checking testbench will verify that the rx_buff_reg's output will get the input when load_en is asserted on a rising clock edge
	--The self-checking part is implemented with a record
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {rx_buff_reg_TB} architecture {tb_architecture}}


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
entity rx_buff_reg_tb is
end rx_buff_reg_tb;

--}} End of automatically maintained section

architecture tb_architecture of rx_buff_reg_tb is
constant period : time := 20 ns; --set period to 20 ns
type test_vector is record
	rst_bar : std_logic;
	load_en : std_logic;
	rx_buff_in : std_logic_vector(7 downto 0);
	rx_buff_out : std_logic_vector(7 downto 0);
end record;

signal clk : std_logic; --clock will run independently
signal rst_bar, load_en : std_logic; --input signals rst_bar and load_en
signal rx_buff_in, rx_buff_out : std_logic_vector(7 downto 0); --data in and data out 
signal end_sim : boolean := false;
type test_vector_array is array(natural range<>) of test_vector;
--create the range we will iterate through to validate our data
constant test_vectors : test_vector_array :=
--rst_bar, load_en, rx_buff_in, rx_buff_out
(
('0', 'X', (others=>'X'), (others=>'0')),
('1', '0', (others=>'X'), (others=>'0')),
('1', '0', "10101010", (others=>'0')),
('1', '1', "10101010", "10101010"),
('1', '1', (others =>'1'), (others => '1')),
('1', '0', (others =>'X'), (others => '1'))
); 

begin 
	--UUT port map
	UUT : entity rx_buff_reg
		port map(rst_bar => rst_bar, clk => clk, load_en => load_en, rx_buff_in => rx_buff_in, rx_buff_out => rx_buff_out);
	
	--generate the clock signal periodically
	clock_gen : process 
	begin
		clk <= '0';
		loop
			wait for period/2; --wait to change level for period/2
			clk <= not clk;	--change level
			exit when end_sim = true; --exit loop when sim_end is true (clk no longer required)
		end loop;
		wait;
	end process;
	
	STIMULUS : process
	begin 
		--generate the sequence of applied test signals from our record
		for i in test_vectors'range loop 
			--apply signals
			rst_bar <= test_vectors(i).rst_bar;
			load_en <= test_vectors(i).load_en;
			rx_buff_in <= test_vectors(i).rx_buff_in;
			--wait for period (for clock to update our values--view waveform to see this)
			wait for period;
			--check if our actual value is the value we want
			assert (rx_buff_out = test_vectors(i).rx_buff_out)
			report "Error with rst_bar = " & std_logic'image(rst_bar) & " load_en = " & std_logic'image(load_en) 
			& " rx_buff_in = " & to_string(rx_buff_in) & CR & LF & "rx_buff_out = " & to_string(rx_buff_out)
			severity error;
		end loop;
		end_sim <= true; --end simulation to stop clock
		std.env.finish; --finish generating signals
	end process;   


	
end tb_architecture;
