library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity givebanc is
	port( 
	     clk:in std_logic;
		 enb: in std_logic;
		 give100:inout std_logic_vector(3 downto 0):="0000";
		 give50:inout std_logic_vector(3 downto 0):="0000";
		 give10:inout std_logic_vector(3 downto 0):="0000";	   		 
		 nr100:inout std_logic_vector(6 downto 0):="1100100";
		 nr50: inout std_logic_vector(7 downto 0):="10010110";
		 nr10: inout std_logic_vector(7 downto 0):="11001000";
		 suma:in  std_logic_vector(11 downto 0) );
end entity;
architecture bancgive of givebanc is 

constant osuta: std_logic_vector(6 downto 0):="1100100";	
constant czeci: std_logic_vector(5 downto 0):="110010";
constant zece: std_logic_Vector(3 downto 0):="1010";		 

begin 
	process(enb,clk)	
	variable gs:std_logic_vector(11 downto 0):="000000000000";	
	begin 	
	 if(Clk='0' and clk'event) then	 
	    if(enb='1') then
		   if(gs + osuta <= suma) then
			   give100<= give100+1;	
			   nr100<=nr100-1;
			   gs:=gs+osuta;
		   elsif(gs + czeci <= suma) then
			   gs:=gs+czeci;   
			   nr50<=nr50-1;
			   give50<=give50+1;
		   elsif(gs+ zece<=suma) then
			   gs:=gs+zece;	
			   nr10<=nr10-1;
			   give10<=give10+1;
		  end if;    
	    else
			give100<="0000";
			give50<="0000";
			give10<="0000";
			gs(0):='0';
		end if;
	end if;
	end process;
end architecture;
		