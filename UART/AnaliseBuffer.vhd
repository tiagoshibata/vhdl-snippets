library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity AnaliseBuffer is
    port (
		clk, analisa: in STD_LOGIC;
		dado1, dado2: in STD_LOGIC_VECTOR(7 downto 0);
		iguais: out STD_LOGIC
	);
end;

architecture ana_arch of AnaliseBuffer is
signal ana_todos: STD_LOGIC := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if analisa = '1' then
				ana_todos <= '1';
            end if;
            if ana_todos = '1' then
				if (dado1 /= dado2) then
					iguais <= '1';
				else
					iguais <= '0';
                end if;
            end if;
            if (ana_todos = '0') and (analisa = '0') then
				iguais <= '0';
			end if;
        end if;
    end process;
end ana_arch;
