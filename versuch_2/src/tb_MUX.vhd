LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_MUX IS
END tb_MUX;
 
ARCHITECTURE behavior OF tb_MUX IS 
 
    COMPONENT MUX
    PORT(
         D3 : IN  std_logic;
         D2 : IN  std_logic;
         D1 : IN  std_logic;
         D0 : IN  std_logic;
         SEL : IN  std_logic_vector(1 downto 0);
         Y : OUT  std_logic
        );
    END COMPONENT;
   --Inputs
   signal D3 : std_logic := '0';
   signal D2 : std_logic := '0';
   signal D1 : std_logic := '0';
   signal D0 : std_logic := '0';
   signal SEL : std_logic_vector(1 downto 0) := (others => '0');
	signal ADDR: std_logic_vector(1 downto 0) := (others => '0');
	signal CNT : std_logic_vector(3 downto 0) := (others => '0');
	signal clk : std_logic := '0';

 	--Outputs
   signal Y : std_logic;

   constant clk_period : time := 10 ns;
	
	-- Increment Std_logic_vector
  procedure p_inc_slv (
    signal r_IN: in std_logic_vector(1 downto 0);
    signal r_OUT: out std_logic_vector(1 downto 0)
  ) is
  begin
    r_OUT <= std_logic_vector(unsigned(r_IN) + 1);
  end p_inc_slv;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX PORT MAP (
          D3 => D3,
          D2 => D2,
          D1 => D1,
          D0 => D0,
          SEL => SEL,
          Y => Y
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

		D0 <= CNT(0);
		D1 <= CNT(1);
		D2 <= CNT(2);
		D3 <= CNT(3);
		
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

		for J in 0 to 4 loop
			for I in 0 to 3 loop
				SEL <= ADDR;
				p_inc_slv(ADDR,ADDR);
				wait for clk_period;
			end loop;
			CNT <= (others => '0');
			CNT(J) <= '1';
		end loop;
      wait;
   end process;

END;
