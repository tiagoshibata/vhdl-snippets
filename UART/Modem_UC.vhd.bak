library IEEE;
use IEEE.std_logic_1164.all;

entity Modem_UC is port (
    clk, send, ready, nCTS: in STD_LOGIC;
    nRTS, do_send_next: out STD_LOGIC
); end;

architecture Modem_UC_arch of Modem_UC is
    type modem_states is (IDLE, WAITING_CTS, SENDING);
    signal state: modem_states := IDLE;
    signal SnRTS: STD_LOGIC := '1';
    signal Sdo_send_next: STD_LOGIC := '0';
begin
    nRTS <= SnRTS;
    do_send_next <= Sdo_send_next;

    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when IDLE =>
                SnRTS <= '1';
                if send = '1' then
                    state <= WAITING_CTS;
                end if;

                when WAITING_CTS =>
                SnRTS <= '0';
                if nCTS = '0' then
                    Sdo_send_next <= '1';
                    state <= SENDING;
                end if;

                when SENDING =>
                Sdo_send_next <= '0';
                if ready = '1' then
                    state <= IDLE;
                end if;
            end case;
        end if;
    end process;
end Modem_UC_arch;
