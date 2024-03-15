library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity InterogareSold is
	port( 
	      enb: in std_logic;
	      clk:in  std_logic;
	      catod: out std_logic_vector(6 downto 0):="0000000";
	      an:out std_logic_vector(3 downto 0):="0111";
	      sumacont: in  std_logic_vector(15 downto 0):="1000100000010000");
end entity;

  architecture seesum of InterogareSold is

component BCD7segm is
	port(	
	      enable:in std_logic; 					
	      clk:in std_logic:='0';
	      c1,c2,c3,c4:in  std_logic_vector(3 downto 0):="0000";
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0):="0111");
end component;

begin	 
	Interogare: BCD7segm port map(enb, clk,sumacont(15 downto 12),sumacont(11 downto 8),sumacont(7 downto 4) ,sumacont(3 downto 0),catod,an);	
	
end architecture;