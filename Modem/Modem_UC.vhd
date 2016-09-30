library IEEE;
use IEEE.std_logic_1164.all;

entity Modem_UC is port (
	cont: in STD_LOGIC_VECTOR(3 downto 0);
	serial, clk: in STD_LOGIC;
    ready_to_receive: out STD_LOGIC;
	start_receiving, output_ready: out STD_LOGIC := '0'
); end;

architecture Modem_UC_arch of Modem_UC is
    type State_type is (IDLE, WAIT_CTS, SEND);
	signal Sreg: State_type := IDLE;
begin

end Modem_UC_arch;
