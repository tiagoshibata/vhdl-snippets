library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ticker is port (
    clk, load_rx, load_tx: in std_logic;
    tick_rx, tick_tx: out std_logic
); end;

architecture ticker_arch of ticker is
    signal Srx_timer_value: STD_LOGIC_VECTOR(17 downto 0);

    component timer port (
        clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(17 downto 0);
        pulse: out STD_LOGIC
    ); end component;
begin
    -- 50MHz / 1200 bps ~ 41667 cycles = 1010001011000011 binary
    -- 50MHz / 300 bps ~ 101000101100001010 binary
    -- 50MHz / 9600 bps = 5208 cycles = 1010001011000 binary
    process (clk)
    begin
        if load_rx = '1' then
            Srx_timer_value <= "000000101000101100";
        else
            Srx_timer_value <= "000001010001011000";
        end if;
    end process;
    rx_divider: timer port map (clk, '1', load_rx, Srx_timer_value, tick_rx);
    tx_divider: timer port map (clk, '1', load_tx, "000001010001011000", tick_tx);
end ticker_arch;
