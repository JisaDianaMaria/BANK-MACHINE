library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cLK_1KHZ is 
	port( system_clk:in std_logic;
	      clk: inout std_logic);
end entity;

architecture arh of cLK_1KHZ is

begin
	
process(system_clk)		   --clk 1KHZ
    variable x: std_logic_vector(15 downto 0):="0000000000000000";
   begin
	   if(system_clk='1' and system_clk'event) then
		  x:=x+1;
		  if(x="1100001101010000") then
			 clk<=not clk; x:="0000000000000000";
	      end if;
	   end if;
   end process;
end architecture;