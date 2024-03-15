library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity introdsumaret is
	port(  	
		   sumaok: in  std_logic; 
	       reset:in std_logic;
	       clk:in std_logic;
	       mii,sute,zeci:in std_logic;						 
		   suma: out std_logic_vector(11 downto 0));  
		   
end entity;

architecture citiresum of introdsumaret is
 
begin
	process(clk,mii,sute,zeci,sumaok,reset)	 
	  variable carrier2: std_logic_vector(3 downto 0):="0001";
	  variable carrier3: std_logic_vector(3 downto 0):="0001"; 
	  variable carrier4: std_logic_vector(3 downto 0):="0001"; 	
	begin		
    if(clk='1' and clk'event) then	
	  if(reset='1') then
		  suma<="000000000000"; 
		  carrier2:="0001";
		  carrier3:="0001";
		  carrier4:="0001";
	  else
		if(sumaok='0') then
		   suma<="000000000000";
		else 
		  if(zeci='1') then				   --introducere zeci 
			    if(carrier2<"1010") then	  
				 	  suma(3 downto 0)<=carrier2;
					  carrier2:=carrier2+1; 
				 else    carrier2:="0001";  suma(3 downto 0)<="0000"; 
			    end if;	 
		  end if; 
		  	 --zeci  
		  if(sute='1') then					 --introducere sute		 
			     if(carrier3<"1010") then 
					suma(7 downto 4)<=carrier3;  
					carrier3:=carrier3+1; 
			     else   carrier3:="0001";  	suma(7 downto 4)<="0000";
			     end if;  
		   end if;
	      	  --sute
		  if(mii='1') then					 --introducere mii	
			    if(carrier4<"1010") then	
				   suma(11 downto 8)<=carrier4;  
				   carrier4:=carrier4+1;
				 
			    else    carrier4:="0001";	 suma(11 downto 8)<="0000";  
	           end if;
		  end if; 
			 --mii   
	    end if;	  
	  end if;
	end if;   	   
	end process;
end architecture;
			 