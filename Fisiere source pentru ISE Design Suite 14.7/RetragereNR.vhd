library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RETRAGERE is
	port(	
	     sumaintr: in std_logic_vector(11 downto 0);
		  cont:  in std_logic_vector(15 downto 0);
		  sumfinal: out std_logic_vector(15 downto 0));
end entity;

architecture arh of RETRAGERE is

component scazatorn is
	generic(n: natural:= 15);
	port( x:in std_logic_vector(n  downto 0);
		  y:in std_logic_vector(n  downto 0);
		  bin: in std_logic:='0';
		  d:out std_logic_vector(n  downto 0));
end component;

signal bin: std_logic:='0';				  
signal locsum: std_logic_vector(15 downto 0);
  
begin 
   bin<=cont(1) xor cont(1); 
	locsum<= sumaintr & "0000" ;
   retn: scazatorn port map (cont,locsum,bin,sumfinal);   
    
end architecture; 