library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ticker is port (
    clk, load_rx, load_tx: in STD_LOGIC;
    modulo: in STD_LOGIC_VECTOR(17 downto 0);
    tick_rx, tick_tx: out STD_LOGIC
); end;

-- 50MHz / 9600 bps = 5208 cycles = 000001010001011000 binary
-- 50MHz / 1200 bps ~ 41667 cycles = 001010001011000011 binary
-- 50MHz / 300 bps ~ 101000101100001010 binary

architecture ticker_arch of ticker is
    signal Srx_modulo: STD_LOGIC_VECTOR(17 downto 0);

    component timer port (
        clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(17 downto 0);
        pulse: out STD_LOGIC
    ); end component;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if load_rx = '1' then
                Srx_modulo <= "0" & modulo(17 downto 1);
            else
                Srx_modulo <= modulo;
            end if;
        end if;
    end process;

    rx_divider: timer port map (clk, '1', load_rx, Srx_modulo, tick_rx);
    tx_divider: timer port map (clk, '1', load_tx, modulo, tick_tx);
end ticker_arch;
