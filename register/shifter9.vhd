library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity shifter9 is
    port (
        dados : in std_logic_vector (8 downto 0);
        carrega, desloca, clock, reset_shifter : in std_logic;
        dado_serial : out std_logic
    );
end shifter9;

architecture shifter9_arch of shifter9 is
    signal IQ : std_logic_vector (8 downto 0);
begin
    process (clock, IQ, desloca, carrega) -- shift
    begin
        if rising_edge(clock) then
                if desloca = '1' then
                    IQ <= '1' & IQ(8 downto 1); -- circular shift right
                end if;
                if carrega = '1' then
                    IQ <= dados;
                end if;
                if reset_shifter = '1' then
                    IQ <= (others => '1');
                end if;
        end if;
        dado_serial <= IQ(0);
    end process;
end shifter9_arch;
