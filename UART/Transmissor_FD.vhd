library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Transmissor_FD is port (
    tk, clk, send: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    serial, ready: out STD_LOGIC
); end;

architecture Transmissor_FD_arch of Transmissor_FD is
    signal bit_count: STD_LOGIC_VECTOR(3 downto 0);

	component shifter port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(9 downto 0);
        data_out: out STD_LOGIC_VECTOR(9 downto 0)
	); end component;

    component counter port(
        clk, reset, count: in std_logic;
        value: out std_logic_vector(3 downto 0)
    ); end component;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if bit_count = "1011" then
                ready <= '1';
            else
                ready <= '0';
            end if;
        end if;
    end process;

    Ishifter: shifter port map (clk, tk, '1', send, serial, "1" & data & "0", open);
    Icounter: counter port map (clk, send, tk, bit_count);
end Transmissor_FD_arch;
