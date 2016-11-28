library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity parity is port (
    clk: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    parity: out STD_LOGIC
); end;

architecture parity_arch of parity is
begin
    process (clk)
        variable Sparity: STD_LOGIC;
    begin
        if rising_edge(clk) then
            Sparity := '1';
            for i in 0 to 7 loop
                Sparity := Sparity xor data(i);
            end loop;
            parity <= Sparity;
        end if;
    end process;
end parity_arch;
