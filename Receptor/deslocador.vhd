library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity deslocador is
	port ( dado_serial, clk, enable: in STD_LOGIC;
	       dado_debug: out STD_LOGIC_VECTOR(10 downto 0);
	       dig1, dig2: out STD_LOGIC_VECTOR(3 downto 0);
	       PRONTO, enable_display: out STD_LOGIC );
end;

architecture deslocador_arch of deslocador is
signal M: STD_LOGIC_VECTOR(3 downto 0) := "1011";
signal cont: STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal dado_int: STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
signal iniciado: STD_LOGIC := '0';
begin

process (clk, dado_serial, enable)
begin
	if clk'event and clk = '1' and enable'event and enable = '1' then
		if (cont < M-1 and cont > "1") then
			cont <= cont + '1';
		    dado_int <= dado_serial & dado_int(10 downto 1); -- Shift para a esquerda
		end if;
	end if;
end process;

process (cont)
begin
	if cont = M then
		PRONTO <= '1';
		cont <= "0000";
		dig1 <= '0' & dado_int(7 downto 5);
		dig2 <= dado_int(4 downto 1);
		enable_display <= '1';
	else
		PRONTO <= '0';
		enable_display <= '0';
	end if;
end process;

end deslocador_arch;