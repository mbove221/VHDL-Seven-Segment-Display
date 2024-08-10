-------------------------------------------------------------------------------
--
-- Title       : edge_det
-- Design      : lab10
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 10\lab10\lab10\src\task1.vhd
-- Generated   : Mon Apr 15 23:01:57 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : The following file is the first part of Design Task 1 for ESE 382 Spring 2024
			--It is a description for the three process FSM code for an edge detector
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {edge_det} architecture {moore_fsm}}


library ieee;
use ieee.std_logic_1164.all;

entity edge_det is
	port(
	rst_bar : in std_logic; --asynchronous system reset
	clk : in std_logic; --system clock
	sig : in std_logic;	--input signal
	pos : in std_logic; --'1' for positive edge, '0' for negative 
	sig_edge : out std_logic); --high for one system clock after edge detected
end edge_det;

--}} End of automatically maintained section

architecture moore_fsm of edge_det is
type state is (waiting_for_0, waiting_for_1, edge_detected); --define states as either
													--waiting for a 0 or a 1, or it's an edge
signal present_state, next_state : state; --use the present state and next state as type states
begin
	state_reg : process(clk, rst_bar) --use to represent the state register (update the states)/reset
	begin
		if(rst_bar = '0') then --for the reset
			if pos = '1' then				 --if pos signal is 1
				present_state <= waiting_for_0; --set initial state (present state) to wait for a 0
			else
				present_state <= waiting_for_1; --otherwise if pos signal is 0,
											--set initial state (present state) to wait for a 1
			end if;
		elsif rising_edge(clk) then	--update state on a rising edge
			present_state <= next_state;
		end if;
	end process;
	
	outputs : process(present_state) --use to output a 1 on a detected edge that we want
	begin
		case present_state is
			when edge_detected => sig_edge <= '1'; --only output 1 when an edge is detected
			when others => sig_edge <= '0';	--otherwise, output a 0
		end case;
	end process;
	
	next_stat : process(present_state, sig)
	begin
		if pos = '1' then  --use for when we're trying to detect a positive edge
			case present_state is
				when waiting_for_0 => --when we're waiting for a 0,
				if sig = '0' then
					next_state <= waiting_for_1; --update to wait for 1 when a 0 detected
				else
					next_state <= waiting_for_0; --otherwise keep waiting for 0
				end if;
				
				when waiting_for_1 => --if we're waiting for a 1
				if sig = '1' then  --then, if we get a 1, we detect an edge
					next_state <= edge_detected;
				else
					next_state <= waiting_for_1; --otherwise, keep waiting for a 1
				end if;
				when others => --when we detected an edge
				if sig = '0' then
					next_state <= waiting_for_1; --if we get a 0, we can then wait for a 1
				else
					next_state <= waiting_for_0; --otherwise, if we get a 1, we have to wait for a 0
				end if;
			end case;
			else
				case present_state is
				when waiting_for_1 => --when we're waiting for a 1,
				if sig = '1' then --if we get a 1, we wait for a 0
					next_state <= waiting_for_0;
				else
					next_state <= waiting_for_1; --otherwise, keep waiting for 1
				end if;
				
				when waiting_for_0 => --when we wait for a 0
				if sig = '1' then	--if we get another 1, we wait for a 0
					next_state <= waiting_for_0;
				else
					next_state <= edge_detected; --otherwise, if we get a 0, we have detected an edge
				end if;
				when others =>	--for edge detection
				if sig = '1' then  --if we get a 1, we can then wait for a 0
					next_state <= waiting_for_0;
				else
					next_state <= waiting_for_1; --otherwise, if we get a 0, we wait for 1
				end if;
			end case;	
		end if;
	end process;
	 -- enter your statements here --

end moore_fsm;
