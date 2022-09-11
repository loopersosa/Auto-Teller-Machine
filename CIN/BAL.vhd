library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BAL is
    Port ( balance : in  STD_LOGIC_VECTOR (10 downto 0);
           led_2  : out  STD_LOGIC;
           bal_active : in  STD_LOGIC;
           balance_out : out  STD_LOGIC_VECTOR (10 downto 0));
end BAL;

architecture Behavioral of BAL is

begin

-- out
if (bal_active = '1') then 
		balance_out <= balance;	
		led_2 = '1';
	
else 
		balance_out <= (others =>'0');
		led_2 = '0';
		
end if;

unit_show_balance: entity work.seven_seg_component(Behavorial)
-- port map(in : out);

end Behavioral;

