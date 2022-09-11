	-- Kasra Hassani
	
	-- Cash-out module
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Cout is
    Port ( up ,down, right, left, center: in  STD_LOGIC;		--input buttons
			  clk: in  STD_LOGIC;
           balance : in  STD_LOGIC_VECTOR (10 downto 0);		--input memory
           c_out_active, res : inout  STD_LOGIC;							--working state
           NP,INS,done : out  STD_LOGIC;
           new_balance : out  STD_LOGIC_VECTOR (10 downto 0));	--output memory
end Cout;

architecture Behavioral of Cout is

signal BTNU, BTND, BTNR, BTNL, BTNS: STD_LOGIC;
signal BTN_CLICKED, multiply20: STD_LOGIC;
signal BTNU_V, BTND_V, BTNR_V, BTNL_V, BTNS_V : STD_LOGIC_VECTOR	(6 downto 0);
signal ten, twenty, fifty, hundred : STD_LOGIC_VECTOR	(6 downto 0); --dollars
signal in_adder: STD_LOGIC_VECTOR	(6 downto 0);
signal cash_amount_before_dff, cash_amount_after_dff: STD_LOGIC_VECTOR(8 downto 0);
signal Sel : STD_LOGIC_VECTOR (1 downto 0);

begin

-------------------------bounce--------------------------
-- bounce up
unit_bounce_up: entity work.bunz(Behavioral)
port map (clk=>clk , res=>res , si=>up , s_out=>BTNU);

-- bounce down
unit_bounce_down: entity work.bunz(Behavioral)
port map (clk=>clk , res=>res , si=>down , s_out=>BTND);

-- bounce right
unit_bounce_right: entity work.bunz(Behavioral)
port map (clk=>clk , res=>res , si=>right , s_out=>BTNR);

-- bounce left
unit_bounce_left: entity work.bunz(Behavioral)
port map (clk=>clk , res=>res , si=>left , s_out=>BTNL);

-- bounce center
unit_bounce_center: entity work.bunz(Behavioral)
port map (clk=>clk , res=>res , si=>center , s_out=>BTNS);
-----------------------------------------------------------

----------------------dollar signal------------------------
--convert 1 bit to 7 bit to be compatible with signals
BTNU_V <= (others=>BTNU);
BTND_V <= (others=>BTND);
BTNL_V <= (others=>BTNL);
BTNR_V <= (others=>BTNR);

ten     <= BTNU_V and "0001010";
twenty  <= BTND_V and "0010100";
fifty   <= BTNL_V and "0110010";
hundred <= BTNR_V and "1100100";

---------------------adding the inputs---------------------
--D Flip Flop for going to the next number
BTN_CLICKED <= BTNU or BTND or BTNL or  BTNR;

process(BTN_CLICKED)
begin

if(BTNU='1')     then     Sel<="00";
elsif(BTND='1')   then     Sel<="01";
elsif(BTNL='1')  then    Sel<="10";
elsif(BTNR='1')  then     Sel<="11";
end if;

if(res='1')	then	
cash_amount_before_dff<=(others=>'0');
cash_amount_after_dff<=(others=>'0');
c_out_active <= '0';
elsif(BTN_CLICKED' event and BTN_CLICKED='1') then
	cash_amount_before_dff <= ('0' & '0' & in_adder) + cash_amount_after_dff;

end if;
-----------------------------------------------------------

-------------------------Multiply 20-----------------------
multiply20<= cash_amount_after_dff(7) or cash_amount_after_dff(8);

if(BTN_CLICKED='1')	then

if(multiply20='0')	then	
	NP<='0';
	res<='1';
	cash_amount_before_dff<=(others=>'0');
	cash_amount_after_dff<=(others=>'0');
	c_out_active <= '0';
elsif(multiply20='1')	then
	NP<='1';
end if;
------------------------------------------------------------

----------------------Insufficient--------------------------
if(cash_amount_after_dff>"111110100" or balance<('0' & '0' & cash_amount_after_dff))	then
	INS<='1';
	res<='1';
	cash_amount_before_dff<=(others=>'0');
	cash_amount_after_dff<=(others=>'0');
	c_out_active <= '0';
elsif(cash_amount_after_dff<"111110101")	then
	INS<='0';
end if;
-------------------------------------------------------------

--------subtracting the cash amount from the balance---------
if(cash_amount_after_dff<"111110101" and multiply20='1' and balance>('0' & '0' & cash_amount_after_dff))	then
	INS<='0';
	NP<='0';
	new_balance<=balance-('0' & '0' & cash_amount_after_dff);
	c_out_active <= '0';
end if;

end if;

end process;

with Sel select
in_adder <= ten when "00",
        twenty when "01",
        fifty when "10",
        hundred when others;
--------------------------------------------------------------
end Behavioral;

