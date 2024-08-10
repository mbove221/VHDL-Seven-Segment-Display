-------------------------------------------------------------------------------
--
-- Title       : load_digit_fsm_tb
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\load_digit_fsm_TB.vhd
-- Generated   : Tue Apr 30 15:52:13 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the non self-checking testbench for ESE 382 Spring 2024 Design Task 4
	--The objective is to output a '1' when ss_bar_pe is a 1 followed by Id_cmd being a 1 on the following clock edge
	--if this is true, we will output a 1 (load_dig)
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {load_digit_fsm_tb} architecture {tb_architecture}}


library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity load_digit_fsm_tb is
end load_digit_fsm_tb;

--}} End of automatically maintained section

architecture tb_architecture of load_digit_fsm_tb is
--assign a period of 20 ns
constant period : time := 20 ns;  
constant pe_period : time :=  1.5*period;
constant ld_period : time := 5 * period;
--apply inputs
signal rst_bar, clk, ss_bar_pe, ld_cmnd : std_logic;
--map to output
signal load_dig : std_logic;
signal end_sim : boolean := false;
begin
	UUT : entity load_digit_fsm
		port map(rst_bar => rst_bar, clk => clk, ss_bar_pe => ss_bar_pe, ld_cmnd => ld_cmnd, load_dig => load_dig);
	
	-- generate system reset
	rst_bar <= '0', '1' after period;
	--generate system clock
	clock_gen : process
	begin
		clk <= '0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim = true;
		end loop; 
		wait;
	end process;
	
	--generate clock for ss_bar
	ss_bar_gen : process
	begin
		ss_bar_pe <= '0';
		loop
			wait for pe_period;
			ss_bar_pe <= not ss_bar_pe;
			exit when end_sim = true;
		end loop;
	end process;
	
	--generate load command clock
	load_gen: process 
	begin
		ld_cmnd <= '0';
		for i in 0 to 2 loop
			wait for ld_period;
			ld_cmnd <= not ld_cmnd;
		end loop;
		end_sim <= true; --stop producing clocks
		std.env.finish; --finish our testbench
	end process;
end tb_architecture;
