library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor is port (
    clk, serial, reset, tick: in STD_LOGIC;
    busy_rx, has_rx_data: out STD_LOGIC;
    data: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Receptor_arch of Receptor is
    signal Srx_bit_count: STD_LOGIC_VECTOR(4 downto 0);
    signal Shas_data, Sbusy_rx, Sparity_ok: STD_LOGIC;

    component Receptor_UC port (
        clk, reset, serial, parity_ok: in STD_LOGIC;
        rx_bit_count: in STD_LOGIC_VECTOR(4 downto 0);
        busy_rx, has_rx_data: out STD_LOGIC
	); end component;

    component Receptor_FD port (
        clk, serial, busy_rx, tick: in STD_LOGIC;
        rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
        data: out STD_LOGIC_VECTOR(7 downto 0);
        parity_ok: out STD_LOGIC
    ); end component;
begin
    busy_rx <= Sbusy_rx;
    dbg_rx_bit_count <= Srx_bit_count;
    IUC: Receptor_UC port map (clk, reset, serial, Sparity_ok, Srx_bit_count, Sbusy_rx, has_rx_data);
    IFD: Receptor_FD port map (clk, serial, Sbusy_rx, tick, Srx_bit_count, data, Sparity_ok);
end Receptor_arch;
