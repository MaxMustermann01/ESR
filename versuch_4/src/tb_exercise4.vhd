
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
 
ENTITY tb_exercise4 IS
END tb_exercise4;
 
ARCHITECTURE behavior OF tb_exercise4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT exercise4
    PORT(
         clk_in : IN  std_logic;
         reset_in : IN  std_logic;
         dout : OUT  std_logic_vector(3 downto 0);
         clk_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_in : std_logic := '0';
   signal reset_in : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(3 downto 0);
   signal clk_out : std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
   constant clk_out_period : time := 10 ns;
	
	signal doutput : std_logic_vector(7 downto 0);
	signal flag : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: exercise4 PORT MAP (
          clk_in => clk_in,
          reset_in => reset_in,
          dout => dout,
          clk_out => clk_out
        );

   -- Clock process definitions
   clk_in_process :process
   begin
		clk_in <= '0';
		wait for clk_in_period/2;
		clk_in <= '1';
		wait for clk_in_period/2;
   end process;
	
   -- Stimulus process
   out_proc: process(dout)
	variable logline : line;
   begin
	   doutput <= doutput(3 downto 0) & dout;
	   if(flag = '1') then
        write(logline, doutput);
		  writeline(output, logline);
		end if;
		flag <= not flag;
   end process;

END;
