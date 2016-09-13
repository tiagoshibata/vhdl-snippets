library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity FD is
	port ( dado_s, PRONTO, CLOCK: in STD_LOGIC;
	       dado_d: out STD_LOGIC_VECTOR(10 downto 0);
	       parada, PARIDADE_OK, a1, a2, b1, b2, c1, c2, d1, d2, e1, e2, f1, f2, g1, g2: out STD_LOGIC );
end;

architecture FD_ARCH of FD is
signal clock_2: STD_LOGIC := '0';
signal enablehex: STD_LOGIC := '0';
signal digaux1: STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal digaux2: STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal dadodebug: STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
component inicio         port ( pronto, clk: in STD_LOGIC;
								CKs: out STD_LOGIC ); end component;
component deslocador     port ( dado_serial, clk, enable: in STD_LOGIC;
							    dado_debug: out STD_LOGIC_VECTOR(10 downto 0);
							    dig1, dig2: out STD_LOGIC_VECTOR(3 downto 0);
							    pronto, enable_display: out STD_LOGIC ); end component;
component paridade		 port ( pronto, ck: in STD_LOGIC;
							    dado: in STD_LOGIC_VECTOR(10 downto 0);
							    paridade_ok: out STD_LOGIC ); end component;
component hex7seg1		 port (	x3, x2, x1, x0 : in std_logic;
								enable : in std_logic;
								a,b,c,d,e,f,g : out std_logic ); end component;
component hex7seg2		 port (	x3, x2, x1, x0 : in std_logic;
								enable : in std_logic;
								a,b,c,d,e,f,g : out std_logic ); end component;							
begin
	ini:  inicio	     port map (PRONTO, CLOCK, clock_2);
	desl: deslocador	 port map (dado_s, CLOCK, clock_2, dadodebug, digaux1, digaux2, parada, enablehex);
	par:  paridade		 port map (PRONTO, CLOCK, dadodebug, PARIDADE_OK);
	hex1: hex7seg1		 port map (digaux1(3), digaux1(2), digaux1(1), digaux1(0), enablehex, a1, b1, c1, d1, e1, f1, g1);
	hex2: hex7seg2		 port map (digaux2(3), digaux2(2), digaux2(1), digaux2(0), enablehex, a2, b2, c2, d2, e2, f2, g2);
end FD_ARCH;