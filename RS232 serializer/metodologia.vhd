library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Metodologia is
	port ( BORDA, RESET, CLOCK: in STD_LOGIC;
	       DADOS_ASCII: in STD_LOGIC_VECTOR(6 downto 0);
	       DADO_SERIAL, PRONTO: out STD_LOGIC;
	       -- Debug
	       Sreg_d: out STD_LOGIC;
	       Q_debug: out STD_LOGIC_VECTOR(10 downto 0) );
end;

architecture metodologia_SD_arch of Metodologia is
signal LOAD, ZERA: STD_LOGIC;
component UC port (BORDA, RESET, CLOCK: in STD_LOGIC;
	               LOAD, ZERA: out STD_LOGIC;
				   Sreg_debug: out STD_LOGIC ); end component;
component FD port (BORDA, LOAD, ZERA, RESET, CLOCK: in STD_LOGIC;
				   DADOS_ASCII: in STD_LOGIC_VECTOR(6 downto 0);
				   Q_debug: out STD_LOGIC_VECTOR(10 downto 0);
				   DADO_SERIAL, PRONTO: out STD_LOGIC ); end component;

begin
	uct: UC port map (BORDA, RESET, CLOCK, LOAD, ZERA, Sreg_d);
	fdt: FD port map (BORDA, LOAD, ZERA, RESET, CLOCK, DADOS_ASCII, Q_DEBUG, DADO_SERIAL, PRONTO);
	
end metodologia_SD_arch;