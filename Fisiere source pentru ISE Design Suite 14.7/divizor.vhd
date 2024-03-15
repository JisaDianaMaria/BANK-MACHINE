library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
entity FREQ_DIVIDER is
	port(system_clk:in std_logic; 
	     clock_out: inout std_logic:='0');
end entity;
	

architecture arh of FREQ_DIVIDER is	

begin

process(system_clk)

variable t: std_logic_vector(25 downto 0):="00000000000000000000000000";
begin	
  if(system_clk='1' and system_clk'event) then
	   t:=t+1;
      if(t="10111110101111000001111111") then 
		      clock_out<=not clock_out; t:="00000000000000000000000000"; --numara de la 0 la 49 999 999 jumate din factorul de umplere
	   end if; 
  end if;
	
end process;

end architecture arh;
	     