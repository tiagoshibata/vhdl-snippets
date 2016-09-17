library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity FD is
    port (
        serial, pronto, clk, starting_rx, output_ready: in STD_LOGIC;
        paridade_ok: out STD_LOGIC;
        rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0);
        display_1: out STD_LOGIC_VECTOR(6 downto 0);
        display_2: out STD_LOGIC_VECTOR(6 downto 0)
    );
end;

architecture FD_ARCH of FD is
    signal serial_data: STD_LOGIC_VECTOR(10 downto 0);
    signal divided_clk: STD_LOGIC;

    component timer port (
        data_in: in STD_LOGIC_VECTOR(3 downto 0);
        load, enable, clk: in STD_LOGIC;
        pulse: out STD_LOGIC
    ); end component;

    component counter port(
        reset: in std_logic;
        count: in std_logic;
        clk: in std_logic;
        value: out std_logic_vector(3 downto 0)
    ); end component;

    component deslocador port (
        serial, clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(10 downto 0);
        data_out: out STD_LOGIC_VECTOR(10 downto 0)
    ); end component;

    component hex7seg port (
        x: in STD_LOGIC_VECTOR(3 downto 0);
        enable: in STD_LOGIC;
        hex_output: out STD_LOGIC_VECTOR(6 downto 0)
    ); end component;
begin
    process (pronto)
        variable parity_tmp: STD_LOGIC := '0';
    begin
        if rising_edge(pronto) then
            parity_tmp := '1';
            for i in 0 to 7 loop
                parity_tmp := parity_tmp xor serial_data(i);
            end loop;
        end if;
        paridade_ok <= parity_tmp;
    end process;

    clock_divider: timer port map ("0111", starting_rx, not pronto, clk, divided_clk);
    rx_bit_counter: counter port map (pronto, divided_clk, clk, rx_bit_count);
    serial_shifter: deslocador port map (serial, clk, divided_clk, starting_rx, (others => '0'), serial_data);
    hex1: hex7seg port map ("0" & serial_data(6 downto 4), output_ready, display_1);
    hex2: hex7seg port map (serial_data(3 downto 0), output_ready, display_2);
end FD_ARCH;
