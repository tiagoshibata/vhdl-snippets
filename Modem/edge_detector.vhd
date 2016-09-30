library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity edge_detector is port (
    clk, signal_in: in std_logic;
    edge_out: out std_logic
); end;

architecture edge_detector_arch of edge_detector is
    signal prev_state : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if signal_in = '1' and prev_state = '0' then
                edge_out <= '1';
            else
                edge_out <= '0';
            end if;
            prev_state <= signal_in;
        end if;
    end process;
end edge_detector_arch;
