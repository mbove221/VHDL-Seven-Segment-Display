-- Testbench for Laboratory 11 Spring 2024

--Description : This is the testbench for ESE 382 Spring 2024 for Design Task 6.
--The goal of this testbench is to generate the signals required for our structural design for the top level entity (spi_mux_digit_driver).
--This test was provided by Professor Short with some possible slight edits.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity spi_mux_digit_driver_tb is
end spi_mux_digit_driver_tb;

architecture TB_ARCHITECTURE of spi_mux_digit_driver_tb is	
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal rst_bar : std_logic;
	signal clk : std_logic;
	signal mosi : std_logic;
	signal sck : std_logic;
	signal ss_bar : std_logic;
	signal sel : std_logic_vector(1 downto 0) := "00";
	-- Observed signals - signals mapped to the output ports of tested entity
	-- Signal data_out : std_logic_vector(7 downto 0);
	signal seg_drive : std_logic_vector(7 downto 0);
	
	-- system clock period is being specified relative to shift
	-- clock period so that effect of changing the system clock
	-- on system's operation can be observed
	constant sck_period : time := 4.0 us;
	constant period : time := sck_period/4.0;
	signal end_sim : boolean := false;
	
	
begin
	
	-- Unit Under Test port map
	UUT : entity spi_mux_digit_driver
	port map (
		rst_bar => rst_bar,
		clk => clk,
		mosi => mosi,
		sck => sck,
		ss_bar => ss_bar,
		sel => sel,
		seg_drive => seg_drive
		);
	
	
	-- generate system reset
	rst_bar <= '0', '1' after period*10;		
	
	
	-- system clock runs until end_sim = false   
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
	
	
	-- Generate SPI Shift Clock and MOSI data
	send_spi_byte: process
		variable data_in : std_logic_vector(7 downto 0);
		variable addr : unsigned(7 downto 0) := "00000000";
		
	begin
		for k in 0 to 15 loop
			data_in := "10000000" or std_logic_vector(addr) or std_logic_vector(to_unsigned(k, 8));
			ss_bar <= '1';	-- select slave
			sck <= '0';     -- starting shift clock value CPOL = 0
			mosi <= '0'; 
			
			wait for 2 * sck_period;
			ss_bar <= '0';
			wait for sck_period;
			for i in 7 downto 0 loop    -- generate 8 data bits                
				mosi <= data_in(i);     -- and shift clock pulses
				wait for sck_period/2;
				sck <= not sck;
				wait for sck_period/2;
				sck <= not sck;                
			end loop;		-- i index
			wait for sck_period;
			ss_bar <= '1';	-- deselect slave
						
			for n in 0 to 3 loop 
				wait for 10 * sck_period;
				sel <= std_logic_vector(to_unsigned(n, 2));
				
			end loop;	-- n indexed loop
						
			addr := (addr + "00010000") and "00110000";
		end loop;	-- k indexed loop
		end_sim <= true;     -- stop system clock
		std.env.finish;		-- stop simulation
	end process;
	
end tb_architecture;



