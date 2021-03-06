library IEEE;
use IEEE.std_logic_1164.all;

entity Receptor_UC is port (
	cont: in STD_LOGIC_VECTOR(3 downto 0);
	serial, clk, reset: in STD_LOGIC;
	ready_to_receive, start_receiving, ended_receiving: out STD_LOGIC := '0'
); end;

architecture Receptor_UC_arch of Receptor_UC is
	signal Sreg: STD_LOGIC := '1';
begin
	ready_to_receive <= Sreg;

	process (clk) -- Logica de proximo estado
	begin
		if rising_edge(clk) then
			if reset = '1' then
				start_receiving <= '0';
				ended_receiving <= '0';
				Sreg <= '1';
			elsif Sreg = '1' and serial = '0' then
				start_receiving <= '1';
				ended_receiving <= '0';
				Sreg <= '0';
			elsif Sreg = '0' then
				start_receiving <= '0';
				if cont = "1001" then
					Sreg <= '1';
					ended_receiving <= '1';
				end if;
			end if;
		end if;
	end process;
end Receptor_UC_arch;
