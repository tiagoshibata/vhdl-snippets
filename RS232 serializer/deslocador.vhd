library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity deslocador is
    port (
        load, clk: in STD_LOGIC;
        dados: in STD_LOGIC_VECTOR(10 downto 0);
        IQ_debug: out STD_LOGIC_VECTOR(10 downto 0);
        DADO_SERIAL: out STD_LOGIC
    );
end;

architecture deslocador_arch of deslocador is
    signal IQ: STD_LOGIC_VECTOR(10 downto 0) := "11111111111";
begin
    process (clk, load, dados, IQ)
    begin
        if rising_edge(clk) then
            if load = '1' then
                IQ <= dados;
            else
                DADO_SERIAL <= IQ(0);
                IQ <= '1' & IQ(10 downto 1); -- Shift para a direita
                IQ_debug <= IQ;
            end if;
        end if;
    end process;
end deslocador_arch;
