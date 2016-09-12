library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity deslocador is
	port ( dado_serial, inicio,  clk: in STD_LOGIC;
	       dado_debug, dado: out STD_LOGIC_VECTOR(10 downto 0);
	       PRONTO: out STD_LOGIC );
end;

architecture deslocador_arch of deslocador is
signal M: STD_LOGIC_VECTOR(3 downto 0) := "1011";
signal cont: STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin

process (clk, inicio, dados_serial) -- Reset síncrono e carregamento
begin
	if clk'event and clk = '1' then
		if (cont < M-1 and cont > '1') or inicio = '1' then
			cont <= cont + '1';
		    dado <= dado(9 downto 0) & dado-serial; -- Shift para a esquerda
		    dado_debug <= dado;
		end if;
		if cont = M then
			PRONTO <= '1';
		else
			PRONTO <= '0';
	end if;
end process;
	
end deslocador_arch;