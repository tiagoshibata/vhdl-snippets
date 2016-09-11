library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter8 is
    port(
        count : in std_logic;
        clk : in std_logic;
        reset : in std_logic;
        ended : out std_logic;
        data_o : out std_logic_vector(3 downto 0)
    );
end counter8;

architecture counter8_impl of counter8 is
    signal temp    : std_logic_vector(3 downto 0);
begin
    process(count, temp, clk, reset)
    begin
        if reset='1' then
            temp <= "0000";
            ended <= '0';
        elsif rising_edge(clk) and count='1' then
            if temp="1000" then
                temp <= "0000";
                ended <= '1';
            else
                temp <= temp + 1;
                ended <= '0';
            end if;
        end if;
        data_o <= temp;
    end process;
end counter8_impl;
