library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;	

entity sumatorn is
	generic(n:natural:= 15);
	port(
	     x:in std_logic_vector(11  downto 0);
		  y:in std_logic_vector(n downto 0);
	     s:out std_logic_vector(n  downto 0));
end entity;

architecture arh2 of sumatorn is
component sumator is
	port(A,B,CIN: in std_logic;
	S,COUT: out std_logic);
end component;	
signal t: std_logic_vector(12 downto 0):="0000000000000";
begin
	
   
	etic: for i in 0 to 11 generate
		etic: sumator port map(x(i),y(i),t(i),s(i),t(i+1));
    end generate;
	s(15)<=y(15);
	s(14)<=y(14);
	s(13)<=y(13);
	s(12)<=y(12);
	t(0)<='0';
   t(12)<='0'; 
end architecture;