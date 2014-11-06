----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:37:56 02/28/2014 
-- Design Name: 
-- Module Name:    debounce - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

-- triple stage data synchronizer 

entity debounce is
    generic (
	simulation : boolean := false;
	delay: integer:= 100000
		);
		Port ( 
	 clk : in  STD_LOGIC;
         rst : in  STD_LOGIC;
         din : in  STD_LOGIC;
         dout : out  STD_LOGIC
		);
end debounce;

architecture Behavioral of debounce is

	-- intermediate data
	signal dt1 : std_logic;
	signal dt2 : std_logic;
	-- make sure this signals doesn't get optimized away
	attribute keep : string;
	attribute keep of dt1 : signal is "TRUE";
	attribute keep of dt2 : signal is "TRUE";

	-- first stage is async
	attribute ASYNC_REG : string;
	attribute ASYNC_REG of inFf  : label is "TRUE";

	-- rloc the ffs to sit in the samle slice
	attribute rloc: string;
	attribute rloc of inFf : label is "X0Y0";
	attribute rloc of outFf : label is "X0Y0";

	-- output
	signal dout_i : std_logic;
	
	--  
	function getMaxDelay return integer is
	begin
		if not simulation then
			return delay;
		else
			return (delay / 1000) + 2;
		end if;
	end function;
		
begin

	-- initial synchronisation stage
	

	inFf : FDCE
	generic map (
		INIT => '0') 
	port map (
		Q => dt1, 
		C => clk, 
		CE => '1', 
		CLR => rst,
		D => din
	);

		outFf : FDCE
			generic map (
				INIT => '0') 
			port map (
				Q => dt2, 
				C => clk, 
				CE => '1', 
				CLR => rst,
				D => dt1
			);


	-- delay stage		
	-- when the pulse period is identical to the debounce delay we get a one cycle spike on the output.
	-- this cannot be avoided. Delay must be set large enough to prevent this situation
	
	noDelay: if delay = 0 generate
	begin
		dout_i <= dt2;
	end generate;
	
	withDelay: if delay /= 0 generate
	begin
		process(clk,rst)
			variable cnt: natural range 0 to delay;
		begin
			if rst = '1' then
				dout_i <= '0';
			elsif rising_edge(clk) then
				-- check value
				if (dt2 = dout_i) then 
					cnt := 0;	-- reset counter if match
				elsif cnt < getMaxDelay then
					cnt := cnt + 1;	-- count if no match
				else 
					dout_i <= dt2;	-- update on timeout
				end if;
			end if;
		end process;
	end generate;

	dout <= dout_i;
	
end Behavioral;

