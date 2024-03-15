library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;   

entity sumator is
	port(A,B,CIN: in std_logic;
	S,COUT: out std_logic);
end entity;
architecture flux of sumator is	
begin
	S<= A xor B xor CIN;
	COUT<= (A and B) or (A and CIN) or (B and CIN);
end architecture;

