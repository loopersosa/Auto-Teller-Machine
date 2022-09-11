-- MehT

-- 7 bit adder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_7 is
    Port ( N1, N2 : in  STD_LOGIC_VECTOR (6 downto 0);
           C_0 : inout  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (6 downto 0));
end entity;

architecture Behavioral of adder_7 is

signal s0, s1, s2, s3, s4, s5, s6 : std_logic;
signal c0, c1, c2, c3, c4, c5, c6 : std_logic; 

begin

C_0 <= '0';

-- adding first digit
sum_unit_0 : entity work.fa(Behavioral)
port map( a=>N1(0), b=>N2(0), c_0=>C_0, c=>c0, s=>s0);

-- adding second digit
sum_unit_1 : entity work.fa(Behavioral)
port map( a=>N1(1), b=>N2(1), c_0=>c0 , c=>c1, s=>s1);

-- ...
sum_unit_2 : entity work.fa(Behavioral)
port map( a=>N1(2), b=>N2(2), c_0=>c1 , c=>c2, s=>s2);

-- ...
sum_unit_3 : entity work.fa(Behavioral)
port map( a=>N1(3), b=>N2(3), c_0=>c2 , c=>c3, s=>s3);

-- ...
sum_unit_4 : entity work.fa(Behavioral)
port map( a=>N1(4), b=>N2(4), c_0=>c3 , c=>c4, s=>s4);

-- ...
sum_unit_5 : entity work.fa(Behavioral)
port map( a=>N1(5), b=>N2(5), c_0=>c4 , c=>c5, s=>s5);

-- carry of 6th digit would be last digit
s6 <= c5;

-- concatination of every sum 
S <= s6 & s5 & s4 & s3 & s2 & s1 & s0;
end Behavioral;

