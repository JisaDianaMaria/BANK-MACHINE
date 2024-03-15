library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity verifpin is
	port(
	       clk:in std_logic; 
	       checkpin:in std_logic;
          pindeverif :in std_logic_vector(15 downto 0):="0000000000000000";
	       pinsetat: in std_logic_vector(15 downto 0):="0000000000000000";
          pinegal: out std_logic);
end entity;

architecture pincheck of verifpin is
begin
	process(checkpin,pindeverif,pinsetat,clk)
	begin
	  if(clk='1' and clk'event) then
		if(checkpin='1') then
		   if(pindeverif=pinsetat) then
			   pinegal<='1';
		   else
			   pinegal<='0';
		   end if;
		 else
			 pinegal<='0';
		end if;
	  end if;
   end process;
end architecture;