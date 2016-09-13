library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity inicio is
	port ( pronto, clk: in STD_LOGIC;
	       CKs: out STD_LOGIC );
end;

architecture inicio_arch of inicio is
signal M: STD_LOGIC_VECTOR(3 downto 0);
begin

process (clk, pronto)
begin
	if clk'event and clk = '1' and pronto = '0' then
		if (M > "0") then
			M <= M - '1';
			CKs <= '0';
		else
			M <= "0111";
			CKs <= '1';
		end if;
	end if;
end process;

process (pronto)
begin
	if pronto = '1' then
		M <= "0100";
	end if;
end process;
	
end inicio_arch;