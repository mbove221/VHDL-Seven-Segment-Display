-------------------------------------------------------------------------------
--
-- Title       : load_digit_fsm
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\load_digit_fsm.vhd
-- Generated   : Tue Apr 30 00:16:30 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is the VHDL source file for ESE 382 Spring 2024 Design Task 4.
	--The goal of this design task is to acts in the following sequence:
	--detect a pos edge from ss_bar, implying it was deselected
	--then, we check if the ld_cmd input is a 1. If it is, then that means we should output a 1 from load_dig to enable
	-- a hex digit to be loaded
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {load_digit_fsm} architecture {moore_fsm}}


library ieee;
use ieee.std_logic_1164.all;
entity load_digit_fsm is
port(
	rst_bar : in std_logic; -- asynchronous system reset
	clk : in std_logic; -- system clock
	ss_bar_pe : in std_logic; -- positive edge of ss_bar detected
	ld_cmnd : in std_logic; -- bit 7 is '1' for load command
	load_dig : out std_logic -- enable a hex_digit to be loadded
);
end load_digit_fsm;

--}} End of automatically maintained section

architecture moore_fsm of load_digit_fsm is
type state is (wait_for_pos_edge, wait_for_command, enable);
signal present_state, next_state : state;
begin
	state_reg : process(clk, rst_bar) --state_reg changes state either when  async rst_bar = '0' or rising clock edge
	begin
		if rst_bar = '0' then
			present_state <= wait_for_pos_edge; --initialize state to wait for a positive edge
		elsif rising_edge(clk) then
			present_state <= next_state; --otherwise, just update the state on a positive clock edge to next state
		end if;
	end process;
	
	outputs : process(present_state)
	begin
		case present_state is 
			when enable => load_dig <= '1'; --only output 1 when in state "enable" 
			when others => load_dig <= '0';
		end case;
	end process;
	
	nxt_state : process(present_state,ss_bar_pe, ld_cmnd)
	begin
		case present_state is
			when wait_for_pos_edge => --when we're waiting for a positive edge
			if ss_bar_pe = '1' then	--check if we receieve a positive edge from the slave
				next_state <= wait_for_command; --if we did, change the state to wait for command
			else --otherwise, if we don't receieve a 1 saying we got a positive edge,
				next_state <= wait_for_pos_edge; --stay in the same state to wait for it
			end if;
			
			when wait_for_command => --when we wait for a command,
			if ld_cmnd = '1' then  --if it's a command,
				next_state <= enable; --we can output a 1 to enable a hex digit load
			else
				next_state <= wait_for_pos_edge; --otherwise, if we get a 0, it's not a command, so go back to waiting for a positive edge
			end if;
			
			when others => --when we are in enable mode,
			if ss_bar_pe = '1' then --if we get a positive edge, we wait for a command
				next_state <= wait_for_command;
			else
				next_state <= wait_for_pos_edge; --otherwise, we wait for a positive edge from ss_bar
			end if;
		end case;
	end process;

end moore_fsm;
