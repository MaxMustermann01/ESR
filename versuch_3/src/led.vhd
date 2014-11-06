
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led is
port( clk_deb, clk_in, reset, din: in std_logic; LED_REG: out std_logic_vector(3 downto 0));
end led;

architecture Behavioral of led is

	COMPONENT debounce
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		din : IN std_logic;          
		dout : OUT std_logic
		);
	END COMPONENT;
	
signal INT_REG: std_logic_vector(3 downto 0) := (others => '0');
type states is (S0, S1, S2, S3);
signal state: states := S0;
signal clk: std_logic;

begin

	Inst_debounce: debounce 
	PORT MAP(
		clk => clk_deb,
		rst => reset,
		din => clk_in,
		dout => clk
	);
	
	process(clk, reset)
	begin
		if reset = '1' then 
			INT_REG <= (others => '0');
			LED_REG <= (others => '0');
			state <= S0;
		elsif rising_edge(clk) then
			case state is
				when S0 =>
					LED_REG <= INT_REG;
					INT_REG <=  INT_REG(2 downto 0) & din;
					state <= S1;
				when S1 =>
					INT_REG <= INT_REG(2 downto 0) & din;
					state <= S2;
				when S2 =>
					INT_REG <= INT_REG(2 downto 0) & din;
					state <= S3;
				when S3 =>
					INT_REG <= INT_REG(2 downto 0) & din;
					state <= S0;
			end case;
		end if;
	end process;
end Behavioral;

