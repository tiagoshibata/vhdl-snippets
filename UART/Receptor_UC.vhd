library IEEE;
use IEEE.std_logic_1164.all;

entity Receptor_UC is port (
    clk, reset, serial, parity_ok: in STD_LOGIC;
    rx_bit_count: in STD_LOGIC_VECTOR(3 downto 0);
    busy_rx, has_rx_data: out STD_LOGIC := '0'
); end;

architecture Receptor_UC_arch of Receptor_UC is
	signal Sbusy_rx: STD_LOGIC := '0';
begin
	busy_rx <= Sbusy_rx;

	process (clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				Sbusy_rx <= '0';
			elsif Sbusy_rx = '0' and serial = '0' then
				Sbusy_rx <= '1';
			elsif Sbusy_rx = '1' then
				if rx_bit_count = "1011" then
					Sbusy_rx <= '0';
                    has_rx_data <= parity_ok;
				end if;
			end if;
		end if;
	end process;
end Receptor_UC_arch;
