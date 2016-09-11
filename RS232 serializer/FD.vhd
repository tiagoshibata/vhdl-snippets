library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity FD is
    port (
        BORDA, LOAD, ZERA, RESET, CLOCK: in STD_LOGIC;
        DADOS_ASCII: in STD_LOGIC_VECTOR(6 downto 0);
        Q_debug: out STD_LOGIC_VECTOR(10 downto 0);
        DADO_SERIAL, PRONTO: out STD_LOGIC );
end;

architecture FD_ARCH of FD is
	signal PACOTE: STD_LOGIC_VECTOR(10 downto 0);
	signal CONT: STD_LOGIC_VECTOR(3 downto 0);
	component formatador port (
		dados_ascii: in STD_LOGIC_VECTOR(6 downto 0);
        clock: in STD_LOGIC;
        pacote: out STD_LOGIC_VECTOR(10 downto 0)
	);
	end component;
	component detector_fim port (
		reset, borda, clock: in STD_LOGIC;
        cont: in STD_LOGIC_VECTOR(3 downto 0);
        pronto: out STD_LOGIC
	);
	end component;
	component deslocador port (
		load, clk: in STD_LOGIC;
        dados: in STD_LOGIC_VECTOR(10 downto 0);
        IQ_debug: out STD_LOGIC_VECTOR(10 downto 0);
        DADO_SERIAL: out STD_LOGIC
	);
	end component;
	component contador_4bits port (
		zera, clk: in STD_LOGIC;
        cont: out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
begin
    form: formatador port map (DADOS_ASCII, CLOCK, PACOTE);
    fim: detector_fim port map (RESET, BORDA, CLOCK, CONT, PRONTO);
    dsl: deslocador port map (LOAD, CLOCK, PACOTE, Q_debug, DADO_SERIAL);
    con: contador_4bits port map (ZERA, CLOCK, CONT);
end FD_ARCH;
