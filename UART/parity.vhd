library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity parity is port (
    data: in STD_LOGIC_VECTOR(7 downto 0);
    parity: out STD_LOGIC
); end;

architecture parity_arch of parity is
begin
    process (data)
        variable Sparity: STD_LOGIC;
    begin
        Sparity := '1';
        for i in 0 to 7 loop
            Sparity := Sparity xor data(i);
        end loop;
        parity <= Sparity;
    end process;
end parity_arch;
