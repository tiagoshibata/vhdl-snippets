library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity timer is
	port (
		data_in: in STD_LOGIC_VECTOR(3 downto 0);
		load, enable, clk: in STD_LOGIC;
	    pulse: out STD_LOGIC
	);
end;

architecture timer_arch of timer is
	signal count: STD_LOGIC_VECTOR(3 downto 0);
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if load = '1' then
				count <= data_in;
			elsif enable = '1' then
				if count = "0" then
					count <= "0111";
					pulse <= '1';
				else
					count <= count - "1";
					pulse <= '0';
				end if;
			end if;
		end if;
	end process;
end timer_arch;
