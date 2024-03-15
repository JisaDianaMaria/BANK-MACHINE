library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debouncer is
	port( clk: in std_logic;
	      d:in std_logic;
		  butout: out std_logic);
end entity;

 architecture debounce of debouncer is
begin
	process(clk) 
	begin
	if(clk='1' and clk'event) then
	    butout<=d;
	end if;
	end process;
  
end architecture;