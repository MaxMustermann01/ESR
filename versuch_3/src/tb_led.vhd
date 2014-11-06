
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_led IS
END tb_led;
 
ARCHITECTURE behavior OF tb_led IS 
 
    COMPONENT led
    PORT(
         clk_deb : IN  std_logic;
         clk_in : IN  std_logic;
         reset : IN  std_logic;
         din : IN  std_logic;
         LED_REG : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
     
   --Inputs
   signal clk_deb : std_logic := '0';
   signal clk_in : std_logic := '0';
   signal reset : std_logic := '0';
   signal din : std_logic := '0';

 	--Outputs
   signal LED_REG : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_deb_period : time := 10 ns;

	procedure pulse (delay: in natural; signal o: out std_logic) is
	begin
		o <= '0';
		wait for delay * 1000 * clk_deb_period;
		o <= '1';
		wait for delay * 1000 * clk_deb_period;
		o <= '0';
	end procedure;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: led PORT MAP (
          clk_deb => clk_deb,
          clk_in => clk_in,
          reset => reset,
          din => din,
          LED_REG => LED_REG
        );

   -- Clock process definitions
   clk_deb_process :process
   begin
		clk_deb <= '0';
		wait for clk_deb_period/2;
		clk_deb <= '1';
		wait for clk_deb_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		

      l1: for i in 0 to 3 loop
			l2: for j in 0 to 10 loop
			pulse((99 + i), clk_in); 
			din <= '1';
			end loop;
		end loop;

      wait;
   end process;

END;
