library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;   

entity AutomatBancar is
	port(
	     unit,zeci,sute,mii: in std_logic; ---pentru introducere suma (switch-uri) (1,2,3,4) 
		 op1,op2,op3,op4:in std_logic; ----1: depunere numerar	   	 (switch5)
		 								  ----2: retragere numerara		  (switch6)
		  								  ----3: interogare sold		 (switch7)
										  ----4: schimbare pin			(switch8)	
		 startstop: in std_logic:='0'; ------------------------------------------------pornire automat switch 
 
		 nextstate: in std_logic:='0';-----------------------------------------------------------buton placa next stare
		  									    
		 enterrr: in std_logic; --------------------------------------------------------------------------------------------button enter placa  
 
		 system_clk: in std_logic; --clk placa 100mhz			

		 catod :out std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare  (pentru netlist)
		 an :out std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare	     (pentru netlist)
		 pinled:out std_logic:='0'; -----------------------------------------------led aprins daca pin e corect;	1 
		 leddep:  out std_logic:='0'; ------------------------------------------------led aprins daca a avut loc depunerea  2 
		 ledret: out std_logic:='0'; ------------------------------------------------led aprins daca a avut loc retragerea	  3 
		 schimbpinled: out std_logic:='0';  ------------------------------------------------led aprins daca a avut loc schimbarea pin-ului   4
		 errled: out std_logic:='0' ------------------------------------------------led aprins in caz ca nu se poate efectua operatiune 5
		 
		
		 );		 		 
end entity;	

architecture BANCOMAT of AutomatBancar is	 
 
 
component introdpin is	 -----------------------------------------------------------------------introducere pin
	port(
	      pinok: in std_logic:='0';
	      clk:in std_logic;
	      mii,sute,zeci,unitati:in std_logic;						 
		   reset:in  std_logic:='0';
		   pin_introdus: out std_logic_vector(15 downto 0) );  
		   
end component;

component verifpin is		-------------------------------------------------------------- --verificare pin
	port(	
	      clk:in std_logic;
	      checkpin:in std_logic;
          pindeverif :in std_logic_vector(15 downto 0);
	      pinsetat: in std_logic_vector(15 downto 0);
          pinegal: out std_logic);
end component; 	 

component afisare_contalegere is
	port(	  
	      enable:in  std_logic; 
		   clk:in  std_logic:='0';	
	      c1: in  std_logic_vector(1 downto 0); 
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0));
end component;

component afisare_introdpin is
	port(	  
	      enable:in std_logic; 
		   clk:in std_logic:='0';
	      c1,c2,c3,c4:in  std_logic_vector(3 downto 0);
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0));
end component;			
  
component FREQ_DIVIDER is			   ------------------------------------------------------------------divizor frecventa 1HZ
	port(system_clk:in std_logic; 
	     clock_out:inout std_logic:='0');
end component;

component cLK_1KHZ is 
	port( system_clk:in std_logic;
       	clk: inout std_logic:='0');
end component;

component debouncer is
	port( clk: in std_logic;
	      d:in std_logic;
		   butout: out std_logic);
end component;

component alegere is
	port(
	     alegere:in  std_logic; 
	     clk: in std_logic;	
		  t: out std_logic_vector(1 downto 0)); 
end component;
component BCD7segm is
	port(	
	      enable:in std_logic; 					
	      clk:in std_logic;
	      c1,c2,c3,c4:in  std_logic_vector(3 downto 0):="0000";
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0):="0111");
end component;
component InterogareSold is
	port( 
	      enb: in std_logic;
	      clk:in std_logic;
	      catod: out std_logic_vector(6 downto 0);
	      an:out std_logic_vector(3 downto 0);
	      sumacont: in std_logic_vector(15 downto 0));
end component;
component introdsuma is		------------------------------------------------------------------introducere suma
	port(  	
	      sumaok: in std_logic:='0';  
		   reset:in std_logic;
	      clk:in std_logic;	   
	      mii,sute,zeci:in std_logic;						 
		   suma:  out std_logic_vector(11 downto 0));  
		   
end component; 
component afisare_introdsuma is
	port(	  
	      enable:in  std_logic; 
		   clk:in   std_logic;
		   c1,c2,c3:in  std_logic_vector(3 downto 0);
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0));
end component;
component DEPUNERE is
	port(	  		
	     sumaintr: in  std_logic_vector(11 downto 0);
		  cont: in   std_logic_vector(15 downto 0);
		  sumfinal: out std_logic_vector(15 downto 0));
end component;	

component RETRAGERE is
	port(	
	     sumaintr: in std_logic_vector(11 downto 0);
		  cont:  in std_logic_vector(15 downto 0);
		  sumfinal: out std_logic_vector(15 downto 0));
end component;

component introdsumaret is
	port(  	
	       sumaok: in  std_logic;
	       reset:in std_logic;
	       clk:in std_logic;
	       mii,sute,zeci:in std_logic;						 
		    suma: out std_logic_vector(11 downto 0));  
		   
end component;
 
component afisare_introdsumaret is
	port(	  
	      enable:in  std_logic; 
		   clk:in   std_logic:='0';
		   c1,c2,c3:in  std_logic_vector(3 downto 0);
	      catod: out std_logic_vector(6 downto 0);	
		   an: out std_logic_vector(3 downto 0));
end component; 

component introdpinschmb is
	port(
	      pinok: in std_logic:='0';
	      clk:in std_logic;
	      mii,sute,zeci,unitati:in std_logic;						 
		   reset:in  std_logic:='0';
		   pin_introdus: out std_logic_vector(15 downto 0));  
		   
end component;


component afisare_introdschmbpin is
	port(	  
	      enable:in  std_logic; 
		  clk:in   std_logic:='0';
	      c1,c2,c3,c4:in  std_logic_vector(3 downto 0);
	      catod: out std_logic_vector(6 downto 0);	
		  an: out std_logic_vector(3 downto 0));
end component;
component givebanc is
	port(
	     clk:in std_logic;
	     enb:in std_logic;
		 give100:inout std_logic_vector(3 downto 0);
		 give50:inout std_logic_vector(3 downto 0);
		 give10:inout std_logic_vector(3 downto 0);	
		 nr100:inout std_logic_vector(6 downto 0):="1100100";
		 nr50: inout std_logic_vector(7 downto 0):="10010110";
		 nr10: inout std_logic_vector(7 downto 0):="11001000";
		 suma:in std_logic_vector(11 downto 0));
end component;	
  
--signal startstop: std_logic:='1'; ------------------------------------------------pornire automat 
signal clk_1hz: std_logic; --clk 1 hz		  
signal clk_afisare:  std_logic; ---clk afisare 1KHZ	  
signal enterps: std_logic:='0'; 	----enter  (1 pentru automat)	  (button)  sau enter pentru introducere suma	sau introducere pin	(dupa debounce)

type DATE is array(7 downto 0) of std_logic_vector(15 downto 0);
signal BAZA: DATE:=(
 0=>"0100011100100001", --4721
 1=> "0101100000110010", --5832
 2=> "0110100101000011", --6943
 3=> "0001100101100111", --1967		   
		 
 4=>  "0000011010111010", --1722 E
 5=>  "0000100100110100", --2356E
 6=>   "0000000101000100", --324E
 7=>   "1100010001111111", --50 303E 	  
  others => "0000000000000000");

signal a1,a2,a3,a4:std_logic:='0';	---------------------decidere alegere cont/card	   
signal pinintrodus:std_logic_vector(15 downto 0):="0000000000000000";  --------------------	 pin de introdus  
signal nextstare:  std_logic:='0';------------------------------------------------------------next stare dupa operatiuni(button dreapta)
  
signal contales:  std_logic_vector(15 downto 0):="0000000000000000";	    --------------------   suma de introdus	
signal pinales: std_logic_vector(15 downto 0):="0000000000000000";  --------------------	 pin de introdus
signal catod1:std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare
signal an1: std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare
signal catod2:std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare
signal an2: std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare		  	 
signal catod3:std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare
signal an3:std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare		 
signal catod4: std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare
signal an4:std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare	   
signal catod5: std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare
signal an5:std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare				
signal catod6: std_logic_vector(6 downto 0):="0000000"; ---------------------catozi afisare
signal an6:std_logic_vector(3 downto 0):="0111"; ---------------------anozi afisare	  
signal countcont:  std_logic_vector(1 downto 0):="00"; ---------------pentru alegere (numarare)		 

signal stare:  std_logic_vector(2 downto 0):="000"; --prima stare a automatului		
signal give100:std_logic_vector(3 downto 0):="0000";
signal give50:std_logic_vector(3 downto 0):="0000";
signal give10: std_logic_vector(3 downto 0):="0000";	
signal nr100:  std_logic_vector(6 downto 0):="1100100"; --100 de bancnote de 100e  
signal nr50: std_logic_vector(7 downto 0):="10010110"; --150 de bancnote de 50e
signal nr10: std_logic_vector(7 downto 0):="11001000"; --200 de bancnote de 10e 
signal n1: std_logic_vector(6 downto 0);
signal n2: std_logic_vector(7 downto 0);
signal n3: std_logic_vector(7 downto 0); 
signal verifpinn: std_logic;	--------enable la verificare pin  
signal pinegal:   std_logic; ----daca pin egal		 
signal interogares: std_logic;	   		  

signal depunerenr: std_logic; --------enable la depunere 	   
signal introdsumd: std_logic; --------enable la intrd suma(depunere)  					
signal sumadep: std_logic_vector(11 downto 0):="000000000000" ; ------------------suma introdusa la depunere 
signal sumadepfinal: std_logic_vector(15 downto 0):="0000000000000000";---------------------------suma finala dupa depunere

signal introdsumr: std_logic;	--------enable la introd suma  (retragere)
signal sumaret: std_logic_vector(11 downto 0):="000000000000" ; ------------------suma introdusa la retragere
signal sumaretfinal: std_logic_vector(15 downto 0):="0000000000000000";---------------------------suma finala dupa depunere
signal retragerenr: std_logic;--------enable la retragere 
signal distret: std_logic; -----------enable distr bancnote 
 

signal introdpinschimb: std_logic;	--------enable la introd suma  (schimbare pin)
signal pinschimb: std_logic_vector(15 downto 0):="0000000000000000" ; ------------------suma introdusa la depunere
signal schimbanr: std_logic;--------enable la retragere 															 
  
signal introdpinc: std_logic;  --enable introducere pin
signal choosepinc: std_logic;	--enable afisare pin introdus
signal introdpc: std_logic; --enable alegere cont
signal afispc: std_logic;  --enable afisare cont
signal resetsumap: std_logic; --resetare  pin introducere( dupa debounce)
signal resetsumad: std_logic; --resetare  pin introducere( dupa debounce)
signal resetsumar: std_logic; --resetare  pin introducere( dupa debounce)    	 
signal resetsumasp: std_logic; --resetare  pin introducere( dupa debounce)
begin				

-------------------------------------------------------clk_1hz---------------------------------------------   
	  clk_1hzz: FREQ_DIVIDER port map( system_clk,clk_1hz); 								   
	  -------------------------------------------------------clk_1hz---------------------------------------------
	   -------------------------------------------------------clk_afisare----------------------------------------------
	  clk_1khzm: cLK_1KHZ port map(system_clk,clk_afisare);
		-------------------------------------------------------clk_afisare----------------------------------------------	   
	  
	  -------------------------------------------------------debouncer but 1 ms---------------------------------------------  	
	  debouncebutenter: debouncer port map(clk_afisare,enterrr,enterps);
	  debouncebutnext: debouncer port map(clk_afisare,nextstate,nextstare);	 
	  --debouncebutup1: debouncer port map(clk_afisare,resetsum,resetsumap); 
	  -------------------------------------------------------debouncer but 1 ms---------------------------------------------  
	   
     -------------------------------------------alegere cont---------------------------------------------------
	  alegerepc: alegere port map(introdpc,clk_1hz,countcont);	--------------------------------------clk_1hz 
	  afisarealergere: afisare_contalegere port map(afispc, clk_afisare, countcont,catod1,an1);  
	 -------------------------------------------alegere cont---------------------------------------------------	   
	 
	 -------------------------------------------introducere pin---------------------------------------------------	   
	 introducerepin: introdpin port map(choosepinc,clk_1hz,mii,sute,zeci,unit,resetsumap,pinintrodus);	-------------------------------------------------------clk_1hz
	 --afisareintroducere: afisare_introdpin port map(introdpinc, clk_afisare,contales(15 downto 12),contales(11 downto 8), contales(7 downto 4),contales(3 downto 0), catod2,an2);  
	 afisareintroducere: afisare_introdpin port map(introdpinc, clk_afisare,pinintrodus(15 downto 12),pinintrodus(11 downto 8), pinintrodus(7 downto 4),pinintrodus(3 downto 0), catod2,an2);  
	 -------------------------------------------introducere pin---------------------------------------------------	   
	 
	 -------------------------------------------verificare pin---------------------------------------------------
	  verificpin: verifpin port map(system_clk,verifpinn,pinintrodus,pinales,pinegal);
	 -------------------------------------------verificare pin---------------------------------------------------  
	 
	  -------------------------------------------interogare sold---------------------------------------------------
	  Interogare: BCD7segm port map(interogares, clk_afisare,contales(15 downto 12),contales(11 downto 8),contales(7 downto 4) ,contales(3 downto 0),catod3,an3);
    						   
	   -------------------------------------------interogare sold--------------------------------------------------- 
		
		
	  ---------------------------------------------depunere------------------------------------------------------------ 
		 introdsumadep: introdsuma port map(introdsumd,resetsumad,clk_1hz,mii,sute,zeci,sumadep);		-----------------------------clk_1hz
	    afisaresumdep: afisare_introdsuma port map(depunerenr,clk_afisare,sumadep(11 downto 8),sumadep(7 downto 4),sumadep(3 downto 0),catod4,an4); 
	    depune: DEPUNERE port map(sumadep,contales,sumadepfinal);
	 ---------------------------------------------depunere------------------------------------------------------------ 
	 
	 ---------------------------------------------retragere--------------------------------------------------------
	   introdsumarett: introdsumaret port map(introdsumr,resetsumar,clk_1hz,mii,sute,zeci,sumaret);		--------------------------clk_1hz
	   afisaresumret: afisare_introdsumaret port map(retragerenr,clk_afisare,sumaret(11 downto 8),sumaret(7 downto 4),sumaret(3 downto 0),catod5,an5); 
	   retrage: RETRAGERE port map(sumaret,contales,sumaretfinal);						
	   distbanc: givebanc port map(clk_afisare,distret,give100,give50,give10,n1,n2,n3,sumaret);	 
	   ---------------------------------------------retragere--------------------------------------------------------
	   
	 --------------------------------------------schimba pin------------------------------------------------------ 
	  introdpinscm: introdpinschmb port map(introdpinschimb,clk_1hz,mii,sute,zeci,unit,resetsumasp,pinschimb);	  --------------------------clk_1hz
	  afisareschimbpin: afisare_introdschmbpin port map(schimbanr,clk_afisare,pinschimb(15 downto 12),pinschimb(11 downto 8),pinschimb(7 downto 4),pinschimb(3 downto 0),catod6,an6);
	 --------------------------------------------schimba pin------------------------------------------------------ 										
	 												 
		 process(stare,clk_afisare,enterps,op1,op2,op3,op4,startstop) --countcont,pinegal,sumadep,sumaret,nextstare,sumretcop,
	begin
	 if(clk_afisare='1' and clk_afisare'event) then
	   if(startstop='0') then
		   catod<="1111111"; an<="1111";   
			stare<="000";   
			resetsumap<='1'; --resetare vector pin introdus
			resetsumad<='1'; --resetare vector suma depusa 
			resetsumar<='1'; --resetare vector suma retrasa
			resetsumasp<='1'; --resetare vector schimbare pin
			--enable alegere pin
		   introdpinc<='0';  
			choosepinc<='0';		
			--/enable alegere pin 
			--enable alegere cont
		   introdpc<='0';
			afispc<='0';
			--/enable alegere cont
		   verifpinn<='0';	--------enable la verificare pin    
         interogares<='0';	    --enable interogare sold
			--enable depunere
			introdsumd<='0'; 
	      depunerenr<='0';
			--/enable depunere
			--enable retragere
			introdsumr<='0'; 
		   retragerenr<='0';	
			--/enable retragere
			--enable schimba pin
			introdpinschimb<='0';
		   schimbanr<='0';	
			--/enable schimba pin
			--led-uri
			errled<='0';	
			pinled<='0';	
			leddep<='0';
			schimbpinled<='0';
			ledret<='0';
		   contales<="0000000000000000";	    --------------------   suma de introdus	
         pinales<="0000000000000000";  --------------------	 pin de introdus	
		 
	   else
		    case stare is
			when "000"=>  
			         introdpc<='1'; 
						afispc<='1';			
			         catod<=catod1; 
						an<=an1;
			         if(enterps='1') then	 --------------------------------------------------- --alegere pin/cont 
							stare<="001";	---introd pin
							resetsumap<='1';
					   else
						   contales<="0000000000000000";
		               pinales<="0000000000000000";
					   end if;	
					   
			when "001"=>   
								resetsumap<='0';
								introdpinc<='1'; 
								choosepinc<='1'; ------------introducem pin-ul  
								introdpc<='0';
								afispc<='0';	----am terminat de ales contul deci nu mai afisam  
								catod<=catod2;
								an<=an2;	 
						 case countcont(1 downto 0) is  
						 	when "00" => pinales<=baza(0); contales<=baza(4); a1<='1'; a2<='0'; a3<='0'; a4<='0';
						 	when "01" => pinales<=baza(1); contales<=baza(5); a2<='1'; a1<='0'; a3<='0'; a4<='0';
						 	when "10" => pinales<=baza(2); contales<=baza(6); a3<='1'; a2<='0'; a1<='0'; a4<='0';
						 	when "11" => pinales<=baza(3); contales<=baza(7); a4<='1'; a3<='0'; a2<='0'; a1<='0';
		   			   when others=>  contales<="0000000000000000";
		                              pinales<="0000000000000000";
					 		end case;
 
			            if(enterps='1') then   
							  verifpinn<='1';	
						     if(pinegal='1') then  ---verificare pin
						       stare<="010"; 
							    pinled<='1';  
								 resetsumad<='1';
								 resetsumap<='1';
								 resetsumasp<='1';
					        else
						       errled<='1';
							  end if;
						   end if;
					     		
						
			when "010"=>----------------interogare sold(afisare) 	
								 choosepinc<='0';
			                introdpinc<='0';  
								 errled<='0';
								 catod<=catod3;
			                an<=an3;	
							if(nextstare='0') then
			              if(op1='1') then		 
							    interogares<='1';
								 resetsumad<='1';
								 resetsumap<='1';
								 resetsumasp<='1';								 
							  end if;
							else
							   if(op1='0') then
							      stare<="011";
								end if;
							end if;
					   ----------------interogare sold(afisare)
			when "011"=>  
							 resetsumad<='0';
							 interogares<='0'; 
							 catod<=catod4;
			             an<=an4; 	 
							 introdsumd<='1'; 
					       depunerenr<='1';
							 ----------------depunere nr(afisare) 
						 if(nextstare='0') then
                    if(op2='1') then  
							 if(enterps='1') then 
							   if(sumadep<="0000001111101000" and sumadep>0) then 
											if(a1='1') then	  
											baza(4)<=sumadepfinal;
											elsif(a2='1') then 
											baza(5)<=sumadepfinal;
											elsif(a3='1') then 
											baza(6)<=sumadepfinal;
											elsif(a4='1') then 
											baza(7)<=sumadepfinal;
											end if; 
								  leddep<='1';
								  stare<="100";   
								  errled<='0';	
							   else
								  errled<='1';
							   end if;
							 end if;  
					     end if;				
						 else
						    if(op2='0') then
							   stare<="100"; --urmatoarea stare
							 end if;
						 end if;
			 when "100" => ----------------retragere nr(afisare)
								 resetsumar<='0';
								 introdsumd<='0'; 
								 depunerenr<='0';
								 catod<=catod5;
			                an<=an5; 	
								 introdsumr<='1'; 
								 retragerenr<='1';
							if(nextstare='0') then
			             if(op3='1') then	 
							   if(enterps='1') then  
							     if(sumaret&"0000"<="0000001111101000" and sumaret&"0000">="1010" and nr100>"1010" and nr50>"1010" and nr10>"1010" and sumaret&"0000"<contales) then   
											if(a1='1') then
											baza(4)<=sumaretfinal;
											elsif(a2='1') then 
											baza(5)<=sumaretfinal;
											elsif(a3='1') then 
											baza(6)<=sumaretfinal;
											elsif(a4='1') then 
											baza(7)<=sumaretfinal;
											end if; 
									  distret<='1';
								     ledret<='1';
									  errled<='0';
								     stare<="101"; 
									   
							     else 
								    ledret<='0';	
								    errled<='1'; 
							     end if;
								 end if; 
							  end if;
							else
								 if(op3='0')then
									stare<="101";
								 end if;
                     end if;							 
			when "101" => 
							resetsumasp<='0';
			            distret<='0';  
							catod<=catod6;
						   an<=an6;
							introdpinschimb<='1';
				         schimbanr<='1';	
						  if(nextstare='0')then
							if(op4='1') then	 ----------------schimbare pin(afisare) 
							 if(enterps='1') then 
											if(a1='1') then	 
											baza(0)<=pinschimb; 
											elsif(a2='1') then
									      baza(1)<=pinschimb; 
											elsif(a3='1') then
											baza(2)<=pinschimb; 
											elsif(a4='1') then
											baza(3)<=pinschimb; 
											end if;  
								schimbpinled<='1';  
							  end if;
							end if; 
						 end if;---------------------------------------------------end operatiuni  
		  when others=> null;
		   end case; 
     end if;
	  end if;
   end process;

    
  

end architecture;