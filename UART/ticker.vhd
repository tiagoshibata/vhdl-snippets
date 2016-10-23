library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ticker is port (
    clk: in std_logic;
    tick_rx, tick_tx: out std_logic
); end;

architecture ticker_arch of ticker is
    component timer port (
        clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(15 downto 0);
        pulse: out STD_LOGIC
    ); end component;
begin
    -- 50MHz / 1200 bps ~ 41667 cycles = 1010001011000011 binary
		-- 50MHz / 9600 bps = 5208 cycles = 1010001011000 binary 
    -- 50MHz / 1200 bps / 16 cycles/bit ~ 2604 = 101000101100 binary
		-- 50MHz / 9600 bps / 16 cycles/bit = 325 = 101000101 binary
    rx_divider: timer port map (clk, '1', '0', "0000000101000101", tick_rx);
    tx_divider: timer port map (clk, '1', '0', "0001010001011000", tick_tx);
end ticker_arch;
