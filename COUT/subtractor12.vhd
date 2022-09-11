-- Kasra Hassani
-- Subtractor 12
library IEEE;use IEEE.STD_LOGIC_1164.ALL;use IEEE.STD_LOGIC_unsigned.ALL;
entity FBFA is    Port ( N1, N2 : in  STD_LOGIC_VECTOR (10 downto 0);           C_0 : inout  STD_LOGIC;           S : out  STD_LOGIC_VECTOR (11 downto 0));end FBFA;architecture Behavioral of FBFA issignal s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11 : std_logic;		-- sum digits 0 to 11signal c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11 : std_logic; 	-- carries 0 to 11signal N2_p: std_logic_vector(10 downto 0);
begin-- input carryC_0 <= '1';N2_p<= not N2 + ";


--digit 0sum_unit_0 : entity work.fa(Behavioral)port map( a=>N1(0), b=>N2(0), c_0=>C_0, c=>c0, s=>s0);
--digit 1sum_unit_1 : entity work.fa(Behavioral)port map( a=>N1(1), b=>N2(1), c_0=>c0 , c=>c1, s=>s1);
--digit 2sum_unit_2 : entity work.fa(Behavioral)port map( a=>N1(2), b=>N2(2), c_0=>c1 , c=>c2, s=>s2);
--digit 3sum_unit_3 : entity work.fa(Behavioral)port map( a=>N1(3), b=>N2(3), c_0=>c2 , c=>c3, s=>s3);
--digit 4sum_unit_4 : entity work.fa(Behavioral)port map( a=>N1(4), b=>N2(4), c_0=>c3 , c=>c4, s=>s4);
--digit 5sum_unit_5 : entity work.fa(Behavioral)port map( a=>N1(5), b=>N2(5), c_0=>c4 , c=>c5, s=>s5);
--digit 6sum_unit_6 : entity work.fa(Behavioral)port map( a=>N1(6), b=>N2(6), c_0=>c5 , c=>c6, s=>s6);
--digit 7s7 <= c6;
--concate to one 8 bit output
S <= s7 & s6 & s5 & s4 & s3 & s2 & s1 & s0;
end Behavioral;