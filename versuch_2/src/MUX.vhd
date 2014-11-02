
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX is
port(D3, D2, D1, D0: in std_logic; SEL: in std_logic_vector(1 downto 0); Y: out std_logic);
end MUX;

architecture Behavioral of MUX is
begin
	process(SEL, D3, D2, D1, D0)
	begin
		case SEL is
			when "00" => Y <= D0;
			when "01" => Y <= D1;
			when "10" => Y <= D2;
			when "11" => Y <= D3;
			when others => NULL;
		end case;
	end process;
end Behavioral;