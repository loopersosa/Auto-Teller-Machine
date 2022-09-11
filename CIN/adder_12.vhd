-- MehT

-- 12 bit adder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FBFA is
    Port ( N1, N2 : in  STD_LOGIC_VECTOR (11 downto 0);
           C_0 : inout  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (11 downto 0));
end FBFA;

architecture Behavioral of FBFA is

signal s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11 : std_logic;
signal c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11 : std_logic; 

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

-- ...
sum_unit_6 : entity work.fa(Behavioral)
port map( a=>N1(6), b=>N2(6), c_0=>c5 , c=>c6, s=>s6);

-- ...
sum_unit_7 : entity work.fa(Behavioral)
port map( a=>N1(7), b=>N2(7), c_0=>c6 , c=>c7, s=>s7);

-- ...
sum_unit_8 : entity work.fa(Behavioral)
port map( a=>N1(8), b=>N2(8), c_0=>c7 , c=>c8, s=>s8);

-- ...
sum_unit_9 : entity work.fa(Behavioral)
port map( a=>N1(9), b=>N2(9), c_0=>c8 , c=>c9, s=>s9);

-- ...
sum_unit_10 : entity work.fa(Behavioral)
port map( a=>N1(10), b=>N2(10), c_0=>c9 , c=>c10, s=>s10);

-- carry of 6th digit would be last digit
s11 <= c10;

-- concatination of every sum 
S <= s11 & s10 & s9 & s8 & s7 & s6 & s5 & s4 & s3 & s2 & s1 & s0;
end Behavioral;