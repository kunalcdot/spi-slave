---------------------------------------------------------------------------------------------
--	 spi_slave module
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity spi_slave is	
--  GENERIC(
--
--    d_width : INTEGER := 8); -- spi shift reg width
	port(

		
	ref_clk				: in std_logic; -- 100MHz ref CLK from external oscillator
	reset_n				: in std_logic; 
	
	cs_n					: in std_logic; 
	mosi					: in std_logic; 
	spi_clk				: in std_logic; 
	miso					: out std_logic; 
	
	
	rx_data				: buffer std_logic_vector(7 downto 0);	-- data latched via mosi
	rx_valid 			: out std_logic; --- if no. of bits latched == 8
	tx_data				: in std_logic_vector(7 downto 0)
	
);
end entity spi_slave;

architecture spi_slave of spi_slave is 


	signal	spi_clk_latched				: std_logic ;
	signal	mosi_latched				: std_logic ;
	signal	cs_n_latched				: std_logic ;
	signal	rx_valid_1				: std_logic ;
	signal	spi_clk_counter				: std_logic_vector(2 downto 0) ;
	
	
	
begin


--	synchronous all incoming signal w.r.t ref_clk
process(ref_clk, reset_n)

 begin
    if (reset_n = '0') then
--      RxdData  '0');
--      bit_counter <= "00";
--      TxData  '0');
--      SCLK_old <= '0';
      spi_clk_latched <= '0';
      mosi_latched <= '0';
		cs_n_latched <= '1';
--      SS_latched <= '0';
--      SPI_DONE <= '0';
--      MOSI_latched <= '0';

    elsif( rising_edge(ref_clk) ) then

      spi_clk_latched <= spi_clk;
      mosi_latched <= mosi;
		cs_n_latched <= cs_n;
--      SS_latched <= SPI_SS;
--      SS_old <= SS_latched;
--      SPI_done <= '0';
--      MOSI_latched <= SPI_MOSI;
	
		end if;
	end process;	

	
--	*********************************************************		
--	samaple mosi on rising edge of spi_clk
	
	process(spi_clk_latched,cs_n_latched,reset_n)
	begin
	
		if(not(cs_n_latched) and reset_n) = '0' then
					rx_data		<=		x"00";
	
		elsif(rising_edge(spi_clk_latched)) then
		
		rx_data <= rx_data(6 downto 0) & mosi_latched;
		
		end if;
		
	end process	;
--	*********************************************************	

----	spi_clk counter to generate rx_valid..
		spi_clk_counter <= 
					(others => '0') 		when (not(cs_n_latched) and reset_n) = '0' else
					spi_clk_counter+'1'			 	when (rising_edge(spi_clk_latched)) else 
					unaffected;

		rx_valid_1 <= '1' when spi_clk_counter = "000" else '0';			

		
		rx_valid <= 
					 '0' 		when (not(cs_n_latched) and reset_n) = '0' else
					rx_valid_1			 	when (falling_edge(spi_clk_latched)) else 
					unaffected;

			
		
	
end architecture spi_slave;	




