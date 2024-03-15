library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity afisare_introdpin is
	port(	  
	      enable:in  std_logic;  
		   clk:in  std_logic:='0';
	      c1,c2,c3,c4:in  std_logic_vector(3 downto 0);
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0));
end entity;

architecture bcdsegm of afisare_introdpin is
signal cifra: std_logic_vector(3 downto 0);
signal counter: std_logic_vector(1 downto 0):="00";
begin												 
	process(cifra)
	begin
		case cifra is
				when "0000" =>  catod<="0000001"; --0
				when "0001" =>	catod<="1001111"; --1
				when "0010" =>	catod<="0010010"; --2
				when "0011" =>  catod<="0000110"; --3
				when "0100" =>	catod<="1001100"; --4
				when "0101" =>	catod<="0100100"; --5
				when "0110" =>	catod<="0100000"; --6
				when "0111" =>	catod<="0001110"; --7
				when "1000" =>	catod<="0000000"; --8
				when "1001" =>	catod<="0000100"; --9
				when "1010" =>	catod<="0001000"; --10-A
				when "1011" =>	catod<="1100000"; --11-b
				when "1100" =>	catod<="0110001"; --12-C
				when "1101" =>	catod<="1000010"; --13-d
				when "1110" =>  catod<="0110000"; --14-E
				when "1111" =>  catod<="0111000"; --15-F
				when others =>  catod<="1111111"; --off
			end case;
	end process;	
	process(clk,enable)
	begin
		if(clk='1' and clk'event and enable='1') then 
		        case counter is 
				    when "00" => cifra<=c3;	 --an3  
			       when "01" => cifra<=c2;	 --an2   
		     	    when "10" => cifra<=c1;	 --an1	 
			       when "11" => cifra<=c4;	 --an4		 
			       when others =>  null;
			 end case;	   
	    	 end if;	     
	end process;   
	  process(clk)
       begin
            if(clk='1' and clk'event) then
               counter<=counter +1;
            end if;     
       end process;
	 process(counter)
       begin
            case counter  is
                when "00" => an<="0111";
                when "01" => an<="1011";
                when "10" => an<="1101";
                when others => an<="1110";
             
            end case;
       end process;
end architecture;