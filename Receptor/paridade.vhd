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

process (PRONTO, dado) -- Reset s�ncrono e carregamento
variable par: STD_LOGIC := '0';
begin
	for i in 0 to 10 loop
		par := par xor dado(i);
	end loop;
	if (par = '0' and PRONTO = '1') then
		PARIDADE_OK <= '1';
	else
		PARIDADE_OK <= '0';
	end if;
end process;
	
end paridade_arch;