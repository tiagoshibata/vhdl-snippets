library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity detector_fim is
    port (
        reset, borda, clock: in STD_LOGIC;
        cont: in STD_LOGIC_VECTOR(3 downto 0);
        pronto: out STD_LOGIC );
end;

architecture detec_arch of detector_fim is
	signal transmitindo: STD_LOGIC := '0';
begin
	process (reset, borda, clock, cont)
	begin
    	if reset = '1' then
			transmitindo <= '0'; -- Reset assincrono
    	elsif rising_edge(clock) then
        	if (transmitindo = '1' and cont = "1010") then
	            pronto <= '1';
	            if (borda = '1') then
	                transmitindo <= '1';
	            else
	                transmitindo <= '0';
	            end if;
	        else
	            pronto <= '0';
	            if (borda = '1') then
	                transmitindo <= '1';
	            end if;
	        end if;
    	end if;
	end process;
end detec_arch;
