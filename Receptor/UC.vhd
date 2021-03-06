library IEEE;
use IEEE.std_logic_1164.all;

entity UC is
	port (
		cont: in STD_LOGIC_VECTOR(3 downto 0);
		serial, clk: in STD_LOGIC;
	    ready_to_receive: out STD_LOGIC;
		start_receiving, output_ready: out STD_LOGIC := '0'
	);
end;

architecture UC_ARCH of UC is
	signal Sreg: STD_LOGIC := '1';
begin
	ready_to_receive <= Sreg;

	process (clk) -- Logica de proximo estado
	begin
		if rising_edge(clk) then
			if Sreg = '1' and serial = '0' then
				start_receiving <= '1';
				Sreg <= '0';
			elsif Sreg = '0' then
				start_receiving <= '0';
				if cont = "1011" then
					output_ready <= '1';
					Sreg <= '1';
				end if;
			end if;
		end if;
	end process;
end UC_ARCH;
