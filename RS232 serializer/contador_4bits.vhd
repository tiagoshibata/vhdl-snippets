library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity contador_4bits is
    port (
        zera, clk: in STD_LOGIC;
        cont: out STD_LOGIC_VECTOR(3 downto 0)
    );
end;

architecture contador_arch of contador_4bits is
    signal IC: STD_LOGIC_VECTOR(3 downto 0);
    signal M: STD_LOGIC_VECTOR(3 downto 0) := "1011";
begin
    process (clk, zera, IC)
    begin
        if zera = '1' then IC <= (others => '0'); -- Reset assincrono
        elsif clk'event and clk = '1' then
            if IC < M - '1' then
                IC <= IC +1; -- Caso seja menor que M, incrementa IC
            else
                IC <= (others => '0');
            end if;
        end if;
    end process;
end contador_arch;
