library IEEE;
use IEEE.std_logic_1164.all;

entity formatador is
    port (
		dados_ascii: in STD_LOGIC_VECTOR(6 downto 0);
        clock: in STD_LOGIC;
        pacote: out STD_LOGIC_VECTOR(10 downto 0)
	);
end;

architecture form_arch of formatador is
begin
	process (dados_ascii, clock)
		variable par: STD_LOGIC;
	begin
	    par := '0';
	    for i in 0 to 6 loop
	        par := par xor dados_ascii(i);
	    end loop;
	    pacote <= "11" & par & dados_ascii & '0';
	end process;
end form_arch;
