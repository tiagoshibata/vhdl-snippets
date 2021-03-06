library IEEE;
use IEEE.std_logic_1164.all;

entity Uart_UC is port (
    clk, send, new_rx_data, recebe_dado, busy_tx: in STD_LOGIC;
    pulse_send_next, has_rx_data: out STD_LOGIC := '0'
); end;

architecture Uart_UC_arch of Uart_UC is
	signal has_data: STD_LOGIC := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if busy_tx = '0' and send = '1' then
                pulse_send_next <= '1';
            else
                pulse_send_next <= '0';
            end if;

            if new_rx_data = '1' and has_data = '0' then
                has_rx_data <= '1';
            end if;
            if recebe_dado = '1' then
                has_rx_data <= '0';
            end if;
            
            has_data <= new_rx_data;
        end if;
    end process;
end Uart_UC_arch;
