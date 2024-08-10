-------------------------------------------------------------------------------
--
-- Title       : slv_spi_rx_shifter
-- Design      : lab10
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 10\lab10\lab10\src\task2.vhd
-- Generated   : Tue Apr 23 12:55:34 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This design description is for Design Task 2 for ESE 382 Lab 10
	--this description is for the slv_spi_rx_shifter, which left shifts
	--the current contents over, as well as obtaining the new rxd data 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {slv_spi_rx_shifter} architecture {behavior}}

library ieee;
use ieee.std_logic_1164.all;
entity slv_spi_rx_shifter is
	port(
	rxd : in std_logic;		--data received from master
	rst_bar : in std_logic;	--asynchronous reset
	sel_bar : in std_logic; 	--selects shifter for operation
	clk : in std_logic;	    --system clock
	shift_en : in std_logic; 	--enable shift
	rx_data_out : out std_logic_vector(7 downto 0) --received data
	);
end slv_spi_rx_shifter;

--}} End of automatically maintained section

architecture behavior of slv_spi_rx_shifter is
begin
	process(rst_bar, clk)
	variable dout_var : std_logic_vector(7 downto 0); --variable used for slicing
	begin 
		if rst_bar = '0' then --if rst_bar is 0, then reset rx_data_out
			dout_var := (others => '0');
		else
			if (rising_edge(clk)) then
				if sel_bar = '0' then
					if shift_en = '1' then --check if it is selected
						dout_var := dout_var(6 downto 0) & rxd; --perform left shift to shift in MSB downto LSB
					end if;
				end if;	
			end if;
		end if;
		rx_data_out <= dout_var;	--update signal to variable
	end process;  --end process

end behavior;
