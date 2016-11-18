library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor_FD is port (
    clk, serial, busy_rx, tick: in STD_LOGIC;
    rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    data: out STD_LOGIC_VECTOR(7 downto 0);
    parity_ok: out STD_LOGIC;
    sample: out STD_LOGIC
); end;

architecture Receptor_FD_arch of Receptor_FD is
    signal Sdata: STD_LOGIC_VECTOR(10 downto 0);
    signal one_count, zero_count: STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
    signal Sparity, Sserial_value: STD_LOGIC;

    component counter port (
        clk, reset, count: in std_logic;
        value: out std_logic_vector(4 downto 0)
    ); end component;

    component shifter port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(10 downto 0);
        data_out: out STD_LOGIC_VECTOR(10 downto 0)
    ); end component;

    component parity port (
        clk: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        parity: out STD_LOGIC
    ); end component;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if busy_rx = '0' or tick = '1' then
                zero_count <= (others => '0');
                one_count <= (others => '0');
            elsif serial = '1' then
                one_count <= one_count + '1';
            else
                zero_count <= one_count + '1';
            end if;
            if zero_count > one_count then
                Sserial_value <= '0';
            else
                Sserial_value <= '1';
            end if;
        end if;
    end process;

    data <= '0' & Sdata(7 downto 1);
    sample <= tick;
    parity_ok <= Sparity xor Sdata(10);

    Iparity: parity port map (clk, Sdata(8 downto 1), Sparity);
    bit_counter: counter port map (clk, not busy_rx, tick, rx_bit_count);
    Ishifter: shifter port map (clk, tick and busy_rx, Sserial_value, '0', open, (others => '0'), Sdata);
end Receptor_FD_arch;
