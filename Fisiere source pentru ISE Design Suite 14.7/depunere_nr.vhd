library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_1164.all;

entity DEPUNERE is
	port(		  
	
	    sumaintr: in std_logic_vector(11 downto 0);
		 cont:  in std_logic_vector(15 downto 0);
		 sumfinal: out std_logic_vector(15 downto 0)
		 );
end entity;

  architecture arh of depunere is

component sumatorn is
	generic(n:natural:= 15);
	port(x:in std_logic_vector(11  downto 0);
	     y:in std_logic_vector(n  downto 0);
	     s:out std_logic_vector(n  downto 0));
end component;
  
signal si: std_logic_vector(11 downto 0);  
begin 
   si<=sumaintr;
   depn: sumatorn port map (si,cont,sumfinal);   

end architecture; 