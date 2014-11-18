library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity exercise4 is
  port(
    clk_in , reset_in   : in std_logic;
	 dout : out std_logic_vector(3 downto 0);
	 clk_out : out std_logic
         );
end exercise4;

architecture Behavioral of exercise4 is
-- 2-Dimensional array type for ROM
  subtype word_t is std_logic_vector(7 downto 0);
  type memory_t is array(127 downto 0) of word_t;

  function init_rom
    return memory_t is
	 variable tmp : memory_t := (others => (others => '0'));
	 variable count_value : integer := 1;
	 begin
	   for addr_pos in 0 to 127 loop
		  tmp(addr_pos) := std_logic_vector(to_unsigned(count_value,8));
		  count_value := count_value + 1;
      end loop;
    return tmp;
  end init_rom;
  
  constant rom : memory_t := init_rom;

-- signals for FSM
type fsm_t is (IDLE,  RDWT);
signal cstate_1, nstate_1 : fsm_t;
signal cstate_2, nstate_2 : fsm_t;

signal clk_1, clk_2 : std_logic := '0';
signal addr : natural range 0 to 127 := 0;
signal din : std_logic_vector(7 downto 0);
signal wr_en, rd_en : std_logic := '0';
signal full, empty : std_logic := '0';
-- signals for clocked output
signal clk_int : std_logic;
signal not_clk_2 : std_logic;
signal clk_fwd_out : std_logic;
signal dout_int : std_logic_vector(3 downto 0);
	
component clk
  port
   (-- Clock in ports
    CLK_IN1           : in     std_logic;
    -- Clock out ports
    CLK_OUT1          : out    std_logic;
    CLK_OUT2          : out    std_logic;
    -- Status and control signals
    RESET             : in     std_logic);
end component;

COMPONENT fifo
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;

begin

  clk_instance : clk
  port map
   (-- Clock in ports
    CLK_IN1 => clk_in,
    -- Clock out ports
    CLK_OUT1 => clk_1,
    CLK_OUT2 => clk_2,
    -- Status and control signals
    RESET  => reset_in);
	 
  fifo_instance : fifo
  PORT MAP (
    rst => reset_in,
    wr_clk => clk_1,
    rd_clk => clk_2,
    din => din,
    wr_en => wr_en,
    rd_en => rd_en,
    dout => dout_int,
    full => full,
    empty => empty
  );

  oddr2_clk_inst : ODDR2
  generic map (
    DDR_ALIGNMENT  => "C0",
    INIT           => '0',
    SRTYPE         => "ASYNC")
  port map
    (D0             => '1',
    D1             => '0',
    C0             => not_clk_2,
    C1             => clk_2,
    CE             => '1',
	 Q              => clk_fwd_out,
    R              => reset_in,
    S              => '0'
	 );
		  
  obuf_clk_inst : OBUF
  generic map (
    IOSTANDARD => "LVCMOS33")
  port map (
    O          => clk_out,
     I          => clk_fwd_out
	  );
  
  -- state register 1
  sreg_1 : process
  begin
    wait until rising_edge(clk_1);
	 if reset_in = '1' then
	   cstate_1 <= IDLE;
	 else
	   cstate_1 <= nstate_1;
    end if;
  end process;
  
  -- state register 2
  sreg_2 : process
  begin
    wait until rising_edge(clk_2);
	 if reset_in = '1' then
	   cstate_2 <= IDLE;
	 else
	   cstate_2 <= nstate_2;
    end if;
  end process;
  
  -- write register
  wreg : process(clk_1)
  begin
		if(rising_edge(clk_1)) then
		  din <= rom(addr);
		end if;
  end process;
  -- read register
  rreg : process(clk_2)
  begin
      not_clk_2 <= not clk_2;
		if(rising_edge(clk_2)) then
		  dout <= dout_int;
		end if;
  end process;
 
  --state logic
  sproc_1 : process(clk_1, cstate_1, full)
  begin
    nstate_1 <= cstate_1;
	 wr_en <= '0';
    case cstate_1 is
	   when IDLE =>
		  if(full = '0') then
		    nstate_1 <= RDWT;
		    wr_en <= '1';
		  else
		    nstate_1 <= IDLE;
		    wr_en <= '0';
		  end if;
		when RDWT =>
		  if(full = '0') then
		    nstate_1 <= RDWT;
		    wr_en <= '1';
		  else
		    nstate_1 <= IDLE;
		    wr_en <= '0';
		  end if;
		when others =>
		  nstate_1 <= IDLE;
    end case;
  end process;
  
    --state logic
  sproc_2 : process(clk_2, cstate_2, empty)
  begin
    nstate_2 <= cstate_2;
	 rd_en <= '0';
    case cstate_2 is
	   when IDLE =>
		  if(empty = '0') then
		    nstate_2 <= RDWT;
		    rd_en <= '1';
		  else
		    nstate_2 <= IDLE;
		    rd_en <= '0';
		  end if;
		when RDWT =>
		  if(empty = '0') then
		    nstate_2 <= RDWT;
		    rd_en <= '1';
		  else
		    nstate_2 <= IDLE;
		    rd_en <= '0';
		  end if;
		when others =>
		  nstate_2 <= IDLE;
    end case;
  end process;
  
  cproc : process
  begin
    wait until rising_edge(clk_1);
	 if(reset_in = '1') then
	   addr <= 0;
	 else
	   if(addr < 127 and wr_en = '1') then
		  addr <= addr + 1;
		elsif(addr=127 and wr_en = '1') then
		  addr <= 0;
		end if;
	end if;
  end process;
  
end Behavioral;

