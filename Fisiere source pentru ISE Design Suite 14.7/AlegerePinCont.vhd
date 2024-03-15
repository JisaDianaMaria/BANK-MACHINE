library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alegere is
	port(
	     alegere:in std_logic; 
	     clk: in std_logic;	
		  t: out std_logic_vector(1 downto 0):="00"); 
		  
end entity;

architecture arh of alegere is

begin 
	 
	process(clk,alegere)   
	   variable counter: std_logic_vector(1 downto 0):="00";
	begin
		
		if(clk='1' and clk'event and alegere='1' ) then
			counter:= counter +1; t<=counter;
	    end if;
	end process;
end architecture;
		 											 