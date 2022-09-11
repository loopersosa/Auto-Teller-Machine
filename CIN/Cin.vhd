-- MehT
-- Cash-in module

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Cin is
    Port ( up, down, right, left, center : in  STD_LOGIC; -- input buttons
			  clk, res : in	STD_LOGIC;
           balance : in  STD_LOGIC_VECTOR (10 downto 0); -- balance 
           c_in_input : in  STD_LOGIC; -- if we are working on this module or going back to 
           odp : inout  STD_LOGIC; -- odp >> balance exceeds the $1500 limit 
           new_balance : out  STD_LOGIC_VECTOR (10 downto 0); -- the new balance to update
			  balance_7seg : out STD_LOGIC_VECTOR (10 downto 0));
end Cin;

architecture Behavioral of Cin is

signal BTNU, BTND, BTNR, BTNL, BTNS : STD_LOGIC;
signal BTNU_v, BTND_V, BTNR_V, BTNL_V, BTNS_V : std_logic_vector(6 downto 0);
signal ten, twenty, fifty, hundred  : STD_LOGIC_vector (6 downto 0);
signal in_adder : STD_LOGIC_vector(6 downto 0);
signal cash_amount_before_dff, cash_amount_after_dff  : std_logic_vector (7 downto 0);
signal flag_button_push : std_logic ;
signal reset_1 : std_logic;
signal new_balance_check : std_logic_vector (10 downto 0);
signal cntr           : STD_LOGIC_VECTOR(22 downto 0)     :=(others=>'0');
signal timer_3_seconds: STD_LOGIC_VECTOR (7 downto 0)     :=x"00";
signal aux : STD_LOGIC_VECTOR (10 downto 0);
signal c_in_active : STD_LOGIC;
begin

c_in_active <= c_in_input;
------------------------------------------ bunz start ------------------

-- bounce for up
unit_bounce_up: entity work.bunz(Behavioral)
port map ( clk=>clk , res=>res , si=>up , s_out=>BTNU);

-- bounce for down
unit_bounce_down: entity work.bunz(Behavioral)
port map ( clk=>clk , res=>res , si=>down , s_out=>BTND);

-- bounce for right
unit_bounce_right: entity work.bunz(Behavioral)
port map ( clk=>clk , res=>res , si=>right , s_out=>BTNR);

-- bounce for left
unit_bounce_left: entity work.bunz(Behavioral)
port map ( clk=>clk , res=>res , si=>left , s_out=>BTNL);

-- bounce for center
unit_bounce_center: entity work.bunz(Behavioral)
port map ( clk=>clk , res=>res , si=>center , s_out=>BTNS);
------------------------------------------ bunz finish ------------------

------------------------------------------ dollar signals start ------------------
-- converting 1 bit to 7 bit for 'and' operation
BTNU_V <= (others=>BTNU);
BTND_V <= (others=>BTND);
BTNL_V <= (others=>BTNL);
BTNR_V <= (others=>BTNR);

-- controlling if it can pass
ten     <= BTNU_V and "0001010";
twenty  <= BTND_V and "0010100";
fifty   <= BTNL_V and "0110010";
hundred <= BTNR_V and "1100100";
------------------------------------------ dollar signals finish ------------------

------------------------------------------ combining dollar signals start ------------------
-- suppose at most one button is pressed in a single time
in_adder <= ten or twenty or fifty or hundred;
------------------------------------------ combining dollar signals finish ------------------

------------------------------------------ adding start ------------------
-- adding amount of inputs so that we can check if it is greater than 250 or not
cash_amount_before_dff <= ('0' & in_adder) + cash_amount_after_dff;																									  
------------------------------------------ adding finish ------------------

------------------------------------------ storing this amount into a PISO start ------------------
-- when one of the buttons is pressed shift register allows 1 seris of data to swipe
flag_button_push <= BTNU or BTND or BTNR or BTNL;

-- mapping signals and storing data in piso
unit_storing_data : entity work.store_data(Behavioral)
port map ( res=>res , clk=>flag_button_push , d=>cash_amount_before_dff , q=>cash_amount_after_dff);
------------------------------------------ storing this amount into a PISO finish ------------------

------------------------------------------ checking conditins start ------------------
--- condition 1 : if it is greater than 250 we will reset that
process (clk)
begin
	if(cash_amount_after_dff > "11111010") then 
		reset_1 <= '1';
	
	-- condition 2 : if no money has given to the atm and customer presses BTNS reset the circuit 	
	elsif( (cash_amount_after_dff = "00000000") and (BTNS = '1'))	then
		reset_1 <= '1';
		c_in_active <= '0';
	end if;
end process;

------------------------------------------ checkin conditins start ------------------

-- showing on the seven segment ----------------------------------------------------start

-- calling 7segment component to display the totoal cash_in amount
--unit_display : entity work.seven_segment_component_name(Architecture_name)
--port map (inputs => , outputs =>);

-- showing on the seven segment ----------------------------------------------------finish

----------start ------------------------- adding the input money to the balance and checknig if it 
----------------------------------- exceeds the 1500 dollar limit or not
aux <= (others=>center); 
balance_7seg <= ("000" & cash_amount_after_dff) and aux;
new_balance_check <= balance + ("000" & cash_amount_after_dff); -- adding -- making the signals the same length
process (clk)
begin
	if timer_3_seconds = x"00" then
		if(new_balance_check > "10111011100") then 
		
		-- over deposit "odp" should be shown
			odp     <= '1'; -- flag to show odp on the 7segment
			reset_1 <= '1'; -- checking the 1500 dollars limit 
			timer_3_seconds <=x"20";
		else
			odp     <= '0';
			new_balance <= new_balance_check ; -- giving the output the new balance

		end if;
	else
		timer_3_seconds <= timer_3_seconds - 1;
	end if ;
	
end process;

process(clk)
            begin
                if (clk'event and clk='1') then 
                    cntr <= cntr + "1";
                end if;
end process;
------------------- end ----------------------------------------------------------------------


end Behavioral;

