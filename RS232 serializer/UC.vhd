library IEEE;
use IEEE.std_logic_1164.all;

entity UC is
	port (
		BORDA, RESET, CLOCK: in STD_LOGIC;
	    LOAD, ZERA: out STD_LOGIC;
	    Sreg_debug: out STD_LOGIC
	);
end;

architecture UC_ARCH of UC is
	type State_type is (INICIAL, CARREGA);
	signal Sreg , Snext: State_type := INICIAL; -- Estado atual e proximo estado
begin
	process (CLOCK, RESET) -- Reset assincrono e memoria de estado
	begin
		if RESET = '1' then
			Sreg <= INICIAL;
		elsif CLOCK'event and CLOCK = '1' then
			Sreg <= Snext;
		end if;
	end process;

	process (BORDA) -- Logica de proximo estado
	begin
		case Sreg is
			when INICIAL     => if BORDA = '0' then Snext <= INICIAL;
			                    else                Snext <= CARREGA;
			                    end if;
			when CARREGA     => Snext <= INICIAL;
			when others      => Snext <= INICIAL;
		end case;
	end process;

	process (Sreg) -- Logica de saida
	begin
		case Sreg is
			when INICIAL     => LOAD <= '0'; ZERA  <= '0'; Sreg_debug <= '0';
			when CARREGA     => LOAD <= '1'; ZERA  <= '1'; Sreg_debug <= '1';
		end case;
	end process;
end UC_ARCH;
