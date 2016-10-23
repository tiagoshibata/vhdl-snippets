library IEEE;
use IEEE.std_logic_1164.all;

entity Transmissor_UC is port (
    clk, send: in STD_LOGIC;
    bit_count: in STD_LOGIC_VECTOR(4 downto 0);
    busy_tx: out STD_LOGIC
); end;

architecture Transmissor_UC_arch of Transmissor_UC is
    signal Sbusy_tx: STD_LOGIC := '0';
begin
    busy_tx <= Sbusy_tx;

    process (clk)
    begin
        if rising_edge(clk) then
            case Sbusy_tx is
                when '0' =>
                if send = '1' then
                    Sbusy_tx <= '1';
                end if;

                when '1' =>
                if bit_count = "01011" then
                    Sbusy_tx <= '0';
                end if;
            end case;
        end if;
    end process;
end Transmissor_UC_arch;
