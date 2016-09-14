library IEEE;
use IEEE.std_logic_1164.all;

entity UC is
	port (
		dado_s, parada, clk: in STD_LOGIC;
	    PRONTO: out STD_LOGIC
	);
end;

architecture UC_ARCH of UC is
	type State_type is (ESPERANDO, RECEBENDO, EXIBINDO);
	signal Sreg , Snext: State_type := ESPERANDO; -- Estado atual e proximo estado
begin

	process (clk) -- Reset assincrono e memoria de estado
	begin
		if rising_edge(clk) then Sreg <= Snext; end if;
	end process;

	process (clk) -- Logica de proximo estado
	begin
		case Sreg is
			when ESPERANDO   => if dado_s = '1' then Snext <= ESPERANDO;
			                    else                 Snext <= RECEBENDO;
			                    end if;
			when RECEBENDO   => if parada = '0' then Snext <= RECEBENDO;
								else				 Snext <= EXIBINDO;
								end if;
			when EXIBINDO    => Snext <= ESPERANDO;
			when others      => Snext <= ESPERANDO;
		end case;
	end process;

	process (Sreg) -- Logica de saida
	begin
		case Sreg is
			when ESPERANDO   => PRONTO<= '1';
			when RECEBENDO   => PRONTO<= '0';
			when EXIBINDO    => PRONTO<= '0';
		end case;
	end process;
end UC_ARCH;
