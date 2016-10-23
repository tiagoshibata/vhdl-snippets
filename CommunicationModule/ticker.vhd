library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ticker is port (
    clk, load_rx: in std_logic;
    tick_rx, tick_tx: out std_logic
); end;

architecture ticker_arch of ticker is
    signal Srx_timer_value: STD_LOGIC_VECTOR(15 downto 0);

    component timer port (
        clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(15 downto 0);
        pulse: out STD_LOGIC
    ); end component;
begin
    Srx_timer_value <= "0101000101100001" when load_rx = '1' else "1010001011000011";
    -- 50MHz / 1200 bps ~ 41667 cycles = 1010001011000011 binary
    -- 50MHz / 9600 bps = 5208 cycles = 1010001011000 binary
    rx_divider: timer port map (clk, '1', load_rx, Srx_timer_value, tick_rx);
    tx_divider: timer port map (clk, '1', '0', "1010001011000011", tick_tx);
end ticker_arch;
