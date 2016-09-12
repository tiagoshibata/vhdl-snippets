library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity paridade is
	port ( PRONTO, ck: in STD_LOGIC;
	       dado: in STD_LOGIC_VECTOR(10 downto 0);
	       PARIDADE_OK: out STD_LOGIC );
end;

architecture paridade_arch of paridade is
begin

process (ck, PRONTO, dado) -- Reset síncrono e carregamento
variable par: STD_LOGIC;
begin
	par := '0';
	for i in 0 to 6 loop
		par := par xor dado(i+4);
	end loop;
	if (par = dado(3) and PRONTO = 1) then
		PARIDADE_OK <= 1;
	else
		PARIDADE_OK <= 0;
end process;
end process;
	
end paridade_arch;