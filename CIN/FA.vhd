library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fa is
    Port ( a, b, c_0 : in  STD_LOGIC;
           c, s : out  STD_LOGIC);
end fa;

architecture Behavioral of fa is

begin

 s <= a xor b xor c_0;
 c <= (a and b) or (b and c_0) or (a and c_0) ;
 
end Behavioral;