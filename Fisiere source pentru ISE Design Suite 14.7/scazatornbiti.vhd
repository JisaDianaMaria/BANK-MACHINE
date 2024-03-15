library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity scazatorn is
	generic(n: natural:= 15);
	port( x:in std_logic_vector(n  downto 0);
		  y:in std_logic_vector(n  downto 0);
		  bin: in std_logic:='0';
		  d:out std_logic_vector(n  downto 0));
end entity;

architecture arh1 of scazatorn is
signal t: std_logic_vector(n downto 0):="0000000000000000";
component scazator is
	port(x,y:in std_logic;
	     bin:in std_logic; 
     	d:out std_logic;
    	bout:out std_logic);
end component;

begin
	 t(0)<=bin; 
	 etic: for i in 0 to n-1  generate
		 etic: scazator port map(x(i),y(i),t(i),d(i),t(i+1));
	 end generate etic;
     d(n)<=(x(15) and y(15)) and bin;
	 
end architecture;