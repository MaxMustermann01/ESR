
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
 
ENTITY tb_SP_Decoder IS
END tb_SP_Decoder;
 
ARCHITECTURE behavior OF tb_SP_Decoder IS

    COMPONENT SP_Decoder
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         din : IN  std_logic;
         LED_REG : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal din : std_logic := '0';

 	--Outputs
   signal LED_REG : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   procedure clk_procedure(
	   signal clk_IN: in std_logic;
	   signal clk_OUT: out std_logic
   )is
   begin
		clk_OUT <= not clk_IN;
		wait for clk_period/2;
   end clk_procedure;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SP_Decoder PORT MAP (
          clk => clk,
          reset => reset,
          din => din,
          LED_REG => LED_REG
        );
       
   -- Stimulus process
   stim_proc: process
   
   begin		
		reset <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		reset <= '0';
		-- first sequenz: 1101
		assert false report "INFO: Starting sequence '1101'" severity note;
		din <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '0';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		-- second sequenz: 1001
		din <= '1';
		clk_procedure(clk,clk);
		assert (LED_REG = "1101") report "ERROR: Output is not equal '1101', failure!" severity error;
		assert (LED_REG /= "1101") report "INFO: Output is equal '1101', ok!" severity note;
		assert false report "INFO: Starting sequence '1001'" severity note;
		clk_procedure(clk,clk);
		din <= '0';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '0';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		-- third sequenz: 0101
		din <= '0';
		clk_procedure(clk,clk);
		assert (LED_REG = "1001") report "ERROR: Output is not equal '1001', failure!" severity error;
		assert (LED_REG /= "1001") report "INFO: Output is equal '1001', ok!" severity note;
		assert false report "INFO: Starting sequence '0101'" severity note;
		clk_procedure(clk,clk);
		din <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '0';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		din <= '1';
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		-- end din = 0
		din <= '0';
		clk_procedure(clk,clk);
		assert (LED_REG = "0101") report "ERROR: Output is not equal '0101', failure!" severity error;
		assert (LED_REG /= "0101") report "INFO: Output is equal '0101', ok!" severity note;
		assert false report "INFO: Stop testsequence" severity note;
		clk_procedure(clk,clk);
		
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
		
		clk_procedure(clk,clk);
		clk_procedure(clk,clk);
      wait;
   end process;

END;
