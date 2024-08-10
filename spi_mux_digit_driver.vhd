-------------------------------------------------------------------------------
--
-- Title       : spi_mux_digit_driver
-- Design      : lab11
-- Author      : Michael
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Michael\Desktop\Stony Brook University\Spring 2024\ESE 382\Lab 11\lab12\lab12\src\spi_mux_digit_driver.vhd
-- Generated   : Tue Apr 30 00:42:15 2024
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This is Design Task 6 for ESE 382 Spring 2024 Lab 11
	--The goal of this VHDL source file is to utilize port mapping to map the other entities created thus far
	--This will create out top level design entity, spi_mux_digit_driver which will be our fully connected top level design (except for lab 12, which we aren't doing).
	--We will use a structural architecture to achieve this.
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {spi_mux_digit_driver} architecture {structural}}


library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity spi_mux_digit_driver is
	port(
	rst_bar : in std_logic; -- asynchronous system reset
	clk : in std_logic; -- system clock
	mosi : in std_logic; -- master out slave in SPI serial data
	sck : in std_logic; -- SPI shift clock to slave
	ss_bar : in std_logic; -- slave select signal
	sel : in std_logic_vector(1 downto 0);
	seg_drive : out std_logic_vector(7 downto 0)
);
end spi_mux_digit_driver;

--}} End of automatically maintained section

architecture structural of spi_mux_digit_driver is
signal u1_out : std_logic; --output bit sig_edge from u1
signal u2_out : std_logic_vector(7 downto 0); --map output vector rx_data_out from u2
signal u3_out : std_logic; --map output bit sig_edge from u3
signal hex_out : std_logic_vector(7 downto 0); --map output vector from u4 as hex_out
signal load1_sig : std_logic_vector(3 downto 0); --map output vector from u5 as load1_sig for first load signal
signal load2_sig : std_logic; --output signal from load_digit fsm u12 to act as a valid load signal (second one)
signal hex_digout0 : std_logic_vector(3 downto 0); --used to map output from u6 (first hex digit)
signal hex_digout1 : std_logic_vector(3 downto 0); --used to map output from u7 (second hex digit)
signal hex_digout2 : std_logic_vector(3 downto 0); --used to map output from u8 (third hex digit)
signal hex_digout3 : std_logic_vector(3 downto 0); --used to map output from u9 (fourth hex digit)
signal hex_sel : std_logic_vector(3 downto 0); --used for output of u10, which is the selected hex digit
begin	  
	--u1 simple
	u1 : entity edge_det 
		port map(rst_bar => rst_bar, clk => clk, sig => sck, pos => '1', sig_edge => u1_out);
		
	--u2 simple
	u2 : entity slv_spi_rx_shifter 
		port map(rxd => mosi, rst_bar => rst_bar, sel_bar => ss_bar, clk => clk, shift_en => u1_out, rx_data_out => u2_out);
		
	--u3 sig=>ss_bar for positive edge on slave select
	u3 : entity edge_det
		port map(rst_bar => rst_bar, clk => clk, sig => ss_bar, pos => '1', sig_edge => u3_out);
		
	--u4 rx_buff_reg depends on u3, u2
	u4 : entity rx_buff_reg
		port map(rst_bar => rst_bar, clk => clk, load_en => u3_out, rx_buff_in => u2_out, rx_buff_out => hex_out); 
		
	--u5 depends on u4 output 
	u5 : entity decoder_2to4
		port map(b => hex_out(5), a => hex_out(4), y => load1_sig);	  
		
	--u12 depends on u3 output, and u4 output(7)
	u12 : entity load_digit_fsm
		port map(rst_bar => rst_bar, clk => clk, ss_bar_pe => u3_out, ld_cmnd => hex_out(7), load_dig => load2_sig);  
		
	--u6, u7, u8, and u9 are all essentially the same thing. however, we use different load_en1 signals, and we map to 4 different outputs (which I called hex_digoutn, where n is an integer from 0 to 3 inclusive)
	u6 : entity hex_digit_reg
		port map(rst_bar => rst_bar, clk => clk, load_en1 => load1_sig(0), load_en2 => load2_sig, hex_dig_in => hex_out(3 downto 0), hex_dig_out => hex_digout0);
		
	u7 : entity hex_digit_reg
		port map(rst_bar => rst_bar, clk => clk, load_en1 => load1_sig(1), load_en2 => load2_sig, hex_dig_in => hex_out(3 downto 0), hex_dig_out => hex_digout1);
		
	u8 : entity hex_digit_reg
		port map(rst_bar => rst_bar, clk => clk, load_en1 => load1_sig(2), load_en2 => load2_sig, hex_dig_in => hex_out(3 downto 0), hex_dig_out => hex_digout2);
		
	u9 : entity hex_digit_reg
		port map(rst_bar => rst_bar, clk => clk, load_en1 => load1_sig(3), load_en2 => load2_sig, hex_dig_in => hex_out(3 downto 0), hex_dig_out => hex_digout3);
	
	--u10 is where we take in the 4 different hex values and pick which one we want with the select signal
	u10 : entity hex_dig_mux
		--hex_dig_out_0 is output of u6, hex_dig_out1 is output of u7, ...
		port map(hex_dig_0 => hex_digout0, hex_dig_1 => hex_digout1, hex_dig_2 => hex_digout2, hex_dig_3 => hex_digout3, sel => sel, hex_dig_out => hex_sel);
		
	--u11 is where we take in the signal selected using u10 and put it through the hex_seven entity to map it to the corresponding digit using a seven-segment display
	u11 : entity hex_seven
		port map(hex => hex_sel, seg_drive => seg_drive);
end structural;
