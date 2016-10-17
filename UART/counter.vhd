library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is port(
    clk, reset, count: in std_logic;
    value: out std_logic_vector(4 downto 0)
); end counter;

architecture counter_impl of counter is
    signal Svalue: std_logic_vector(4 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Svalue <= "00000";
            elsif count = '1' then
                Svalue <= Svalue + 1;
            end if;
            value <= Svalue;
        end if;
    end process;
end counter_impl;
