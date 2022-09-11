-- MehT
-- store data in d flip flop

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity store_data is
    Port ( res,clk : in  STD_LOGIC;
			  d : in std_logic_vector (7 downto 0);
           q : out  STD_LOGIC_vector (7 downto 0));
end entity; 

architecture Behavioral of store_data is

begin

 process(clk,res)
 
	begin
	
	if(res='1') then
		q<= (others=>'0');
		
   elsif(clk' event and clk='1') then
		q<=d;
		
  end if;
  
 end process;


end Behavioral;