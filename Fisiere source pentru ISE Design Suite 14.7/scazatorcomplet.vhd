library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity scazator is
	port(x,y:in std_logic;
	     bin:in std_logic; 
     	d:out std_logic;
    	bout:out std_logic);
end entity;
architecture arh of scazator is  
  begin
	  d<=(x XOR y) XOR bin;
	  bout<=(bin and (not(x XOR y))) or ((not x) and y);
end architecture;
