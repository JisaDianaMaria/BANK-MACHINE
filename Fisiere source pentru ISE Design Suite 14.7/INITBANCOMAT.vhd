library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity INIT is
	port(  
	     enb: in std_logic;
	     pin1,pin2,pin3,pin4: out std_logic_vector(15 downto 0);
	     cont1,cont2,cont3,cont4:out std_logic_vector(15 downto 0);	
		  nr100:  out std_logic_vector(6 downto 0); --100 de bancnote de 100e  
		  nr50: out std_logic_vector(7 downto 0); --150 de bancnote de 50e
	     nr10: out std_logic_vector(7 downto 0); --200 de bancnote de 10e  	
		 
		 n1:in std_logic_vector(6 downto 0);
		 n2,n3:in std_logic_Vector(7 downto 0);
		 clk: in std_logic;
		 a1,a2,a3,a4:in std_logic;
		 pinales: in std_logic_vector(15 downto 0);
		 contales: in std_logic_vector(15 downto 0));
end entity;				 

architecture arhin of INIT is

begin
	process(clk,enb,a1,a2,a3,a4) 
	begin
		if(clk='1' and clk'event) then
		   if(enb='0') then		 --------------------daca se da reset la simulator
			    pin1<="0100011100100001"; --4721
		       pin2<="0101100000110010"; --5832
		       pin3<="0110100101000011"; --6943
		       pin4<="0001100101100111"; --1967		   
		 
		       cont1<="0000011010111010"; --1722 E
		       cont2<="0000100100110100"; --2356E
		       cont3<="0000000101000100"; --324E
		       cont4<="1100010001111111"; --50 303E 	 
			   
		  	    nr100<="1100100"; --100 de bancnote de 100e  
		       nr50<="10010110"; --150 de bancnote de 50e
	          nr10<="11001000"; --200 de bancnote de 10e 
		   else
			   if(a1='1') then	 
				pin1<=pinales;
				cont1<=contales;
			   elsif(a2='1') then
				pin2<=pinales;
				cont2<=contales;
			   elsif(a3='1') then
				pin3<=pinales;
				cont3<=contales;
			   elsif(a4='1') then
				pin4<=pinales;
				cont4<=contales;
			   end if; 
			   nr100<=n1;
			   nr50<=n2;
			   nr10<=n3;
		   end if;
	   end if;
end process;
end architecture;