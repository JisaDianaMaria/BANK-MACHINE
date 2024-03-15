library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity introdpinschmb is
	port(
	      pinok: in std_logic ;
	      clk:in std_logic;
	      mii,sute,zeci,unitati:in std_logic;						 
		   reset:in  std_logic:='0';
		   pin_introdus: out std_logic_vector(15 downto 0));  
		   
end entity;

architecture citirepin of introdpinschmb  is

begin
	process(unitati,clk,mii,sute,zeci,reset,pinok)	 
	  variable carrier1: std_logic_vector(3 downto 0):="0000";	   
	  variable carrier2: std_logic_vector(3 downto 0):="0000";
	  variable carrier3: std_logic_vector(3 downto 0):="0000"; 
	  variable carrier4: std_logic_vector(3 downto 0):="0000"; 
	begin	   
	    if(reset='1') then
		   carrier1:="0001";
		   carrier2:="0001";
		   carrier3:="0001";
		   carrier4:="0001";
		   pin_introdus<="0000000000000000";
		else   
		  if(pinok='1') then
	        if(unitati='1') then			  --introducere unitati	  
			  if(clk='1' and clk'event) then
		     	  if(carrier1<"1010") then	
		              pin_introdus(3 downto 0)<=carrier1; 
					  carrier1:=carrier1+1; 
			      else   carrier1:="0001";  pin_introdus(3 downto 0)<="0000"; 
				  end if;
			   end if;
		  end if;	  --unitati
		  if(zeci='1') then				   --introducere zeci  
			  if(clk='1' and clk'event) then
			       if(carrier2<"1010") then	  
					  pin_introdus(7 downto 4)<=carrier2;
					  carrier2:=carrier2+1; 
				   else    carrier2:="0001";  pin_introdus(7 downto 4)<="0000"; 
			       end if;	 
				end if; 
		  end if;	 --zeci  
		  if(sute='1') then					 --introducere sute		 
			  if(clk='1' and clk'event) then
			     if(carrier3<"1010") then 
					pin_introdus(11 downto 8)<=carrier3;  
					carrier3:=carrier3+1; 
					
			     else   carrier3:="0001";  	pin_introdus(11 downto 8)<="0000";
			     end if;  
			  end if;
	      end if; 	  --sute
		  if(mii='1') then					 --introducere mii	
			  if(clk='1' and clk'event) then
			    if(carrier4<"1010") then	
				   pin_introdus(15 downto 12)<=carrier4;  
				   carrier4:=carrier4+1;
				 
			    else    carrier4:="0001";	 pin_introdus(15 downto 12)<="0000";  
			    end if;
			  end if;
		  end if;	 --mii   
	 	 else
			  carrier1:="0001";
		     carrier2:="0001";
		     carrier3:="0001";
		     carrier4:="0001";
		     pin_introdus<="0000000000000000"; 
	     end if; --pinok (confirmare pin)
       end if; --reset
    
	end process;
end architecture;
			 