library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor is
	port ( dado_serial, CK: in STD_LOGIC;
	       PRONTO_led, PARIDADE_OK_LED, A1, A2, B1, B2, C1, C2, D1, D2, E1, E2, F1, F2, G1, G2: out STD_LOGIC;
	       -- Debug
	       dado_debug: out STD_LOGIC_VECTOR(10 downto 0) );
end;

architecture receptor_arch of Receptor is
signal pronto: STD_LOGIC;
signal pronto_led_aux: STD_LOGIC;
component UC port 	   ( dado_s, parada, CLOCK: in STD_LOGIC;
					     PRONTO: out STD_LOGIC ); end component;
component FD port      ( dado_s, PRONTO, CLOCK: in STD_LOGIC;
					     dado_d: out STD_LOGIC_VECTOR(10 downto 0);
				         parada, PARIDADE_OK, a1, a2, b1, b2, c1, c2, d1, d2, e1, e2, f1, f2, g1, g2: out STD_LOGIC ); end component;

begin
	uct: UC port map (dado_serial, pronto, CK, pronto_led);
	fdt: FD port map (dado_serial, pronto_led_aux, CK, dado_debug, pronto, PARIDADE_OK_led, A1, A2, B1, B2, C1, C2, D1, D2, E1, E2, F1, F2, G1, G2);

process(pronto_led_aux)
begin
	PRONTO_led <= pronto_led_aux;
end process;
end receptor_arch;