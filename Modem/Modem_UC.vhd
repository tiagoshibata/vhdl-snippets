library IEEE;
use IEEE.std_logic_1164.all;

entity Modem_UC is port (
    clk, send, ready, nCTS: in STD_LOGIC;
    nRTS: out STD_LOGIC
); end;

architecture Modem_UC_arch of Modem_UC is
    type modem_states is (IDLE, WAIT_CTS, SEND);
    signal state: modem_states := IDLE;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when IDLE =>
                nRTS <= 1;
                if send = '1' then
                    state <= WAIT_CTS;
                end if;

                when WAIT_CTS =>
                nRTS <= 0;
                if nCTS = '0' then
                    state <= SEND;
                end if;

                when SEND =>
                nRTS <= 0;
                if ready = '1' then
                    state <= IDLE;
                end if;
            end case;
        end if;
    end process;
end Modem_UC_arch;
