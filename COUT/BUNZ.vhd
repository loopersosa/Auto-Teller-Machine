-- Kasra Hassani
-- bounce

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bunz is
    Port ( clk,res,si : in  STD_LOGIC;
           s_out : out  STD_LOGIC);
end entity;

architecture Behavioral of bunz is

signal x: std_logic_vector(7 downto 0);
signal d: STD_LOGIC_VECTOR (7 downto 0);

begin
d<=x;

process(clk,res)
 begin
 
 if(res='1') then 
	x<=(others=>'0');
	
 elsif(clk' event and clk='1') then
	x<=si&x(7 downto 1);
	
 end if;
 end process;

s_out <= d(0) and d(1) and d(2) and d(3) and d(4) and d(5) and d(6) and d(7);


end Behavioral;