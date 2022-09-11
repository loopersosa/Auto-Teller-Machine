--this hardware shows data_in
-- on 4 digits 7_segments that
-- is betwean 0 to 9999

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package AUXILIARY is
  type type_data_out is array  (4 downto 1) of STD_LOGIC_VECTOR (1 downto 8);
  type type_decimal  is array  (4 downto 1) of STD_LOGIC_VECTOR (3 downto 0);

end AUXILIARY;
USE AUXILIARY.ALL;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity segment1 is
    Port
    ( clk        : in  STD_LOGIC;  -- hardware is synchronized with clk
      n_rst      : in  STD_LOGIC;  -- active low reset initilizes everything
      data_in    : in  STD_LOGIC_VECTOR (13 downtto 0);-- data_in is lower than 0x270f
      blink_pin  : in  std_logic;                     -- if it is '1' display is blinking
      --show_pin   : in  std_logic;                     -- word "PIN" is showed
      show_words : in  std_logic_vector(3 downto 0);  -- bal,cout,cin,chec,cpin,pin
      digit_out  : out STD_LOGIC_VECTOR (1 to 4);      -- this output select witch digit is ON , (P17,P18,N15,N16)
      segment_out: out STD_LOGIC_VECTOR (1 to 8)      -- select segment of digit
     );                                               -- a.T17 b.T18 c.U17 d.U18
                                                      -- e.M14 f.N14 g.L14 dp.M13
end segment1;

architecture Behavioral of segment1 is
     signal digits type_data_out;
     signal decimals type_decimal;
     signal aux_blink_enable is std_lgic;
     signal mahdi : aray std_logic_vector
begin

	----------------------------------------------------------------------------
    change_data_2_decimal: process(n_rst,clk,data_in)   -- aty the frist, exchange data_in form binery to decimal!
        type state_machine is (state0;state1,state2,state3,state4);
        variable state : state_machine:= state1;
        variable aux_deci : type_decimal;
        variable aux_data_in : STD_LOGIC_VECTOR (13 downtto 0);
    begin
         if n_rst = '0' then
            decimals[4] <= (others=>"0"); -- 1000
            decimals[3] <= (others=>"0"); -- 100
            decimals[2] <= (others=>"0"); -- 10
            decimals[1] <= (others=>"0"); -- 1

            state := state1;
            aux_data_in := data_in;
            aux_deci[4] := (others=>"0"); -- 1000
            aux_deci[3] := (others=>"0"); -- 100
            aux_deci[2] := (others=>"0"); -- 10
            aux_deci[1] := (others=>"0"); -- 1

         else
             if CLK'event and CLK='1' then
                case state is
                when state0=>
                    state := state1;
                    aux_data_in := data_in;
                    aux_deci[4] := (others=>"0"); -- 1000
                    aux_deci[3] := (others=>"0"); -- 100
                    aux_deci[2] := (others=>"0"); -- 10
                    aux_deci[1] := (others=>"0"); -- 1
                when state1=>
                    if aux_data_in>= "00001111101000" then  -- x"3e8" is 1000
                        aux_data_in := aux_data_in - "00001111101000";
                        aux_deci[4] := aux_deci[4] + "1";
                     else
                       state := state2;
                     end if;
                when state2=>
                     if aux_data_in>= "00000001100100" then  -- x"64" is 100
                        aux_data_in := aux_data_in - "00000001100100";
                        aux_deci[3] := aux_deci[3] + "1";
                     else
                       state := state3;
                     end if;
                 when state3=>
                     if aux_data_in>= "00000000001010" then  -- x"0a" is 10
                        aux_data_in := aux_data_in -  "00000000001010";
                        aux_deci[2] := aux_deci[2] + "1";
                     else
                       state := state4;
                       aux_deci[1] :=aux_data_in[3 downto 0];
                     end if;
                 when others=>
                     decimals[4] <= aux_deci[4]; -- 1000
                     decimals[3] <= aux_deci[3]; -- 100
                     decimals[2] <= aux_deci[2]; -- 10
                     decimals[1] <= aux_deci[1]; -- 1
                     state := state0;
                end case;
              end if;
         end if;
    end process  change_data_2_decimal;
    ----------------------------------------------------------------------------
    change_all_data_2_7segment: process(n_rst,CLK,decimals,show_words)
    begin
             if CLK'event and CLK='1' then
                case show_words is    --- show word PIN or digits ?
                when "0000" =>
                    if data_in>x"270f"
                        digits[4] <= "01100001"; -- E
                        digits[3] <= "11110101"; -- r
                        digits[2] <= "11000101"; -- o
                        digits[1] <= "11110101"; -- r
                    else
                    ----------------------------------------
                    -- all segment is active low , then for showing
                    -- related pin must be zero.
                        case (decimals[4]) is
                            when x"0"=>
                                digits[4]<="00000011"; --a to f are active , g and dp are inactive
                            when x"1"=>                 --                      A
                                digits[4]<="10011111"; --                 ===============
                            when x"2"=>                 --               ||            ||
                                digits[4]<="00100101"; --               ||            ||
                            when x"3"=>                 --          F  ||            || B
                                digits[4]<="00001101"; --             ||            ||
                            when x"4"=>                 --           ||    G       ||
                                digits[4]<="10011001"; --            ===============
                            when x"5"=>                 --          ||            ||
                                digits[4]<="01001001"; --          ||            ||
                            when x"6"=>                 --     E  ||            || C
                                digits[4]<="01000001"; --        ||            ||     H
                            when x"7"=>                 --      ||            ||   =====
                                digits[4]<="00011111"  --      ===============    |||||
                            when x"8"=>                 --          D             =====
                                digits[4]<="00000001"  --
                            when x"9"=>                 --         digits[x] = "ABCDEFGH"
                                digits[4]<="00011001"; --
                            when x"A"=>   -- 10 for P
                                digits[4]<= "00110001";
                            when others =>              --
                                digits[4]<="01100001";--E
                            end case;
                            ----------------------------------------
                            case (decimals[3]) is
                            when x"0"=>
                                                  digits[3]<="00000011";
                            when x"1"=>
                                                  digits[3]<="10011111";
                            when x"2"=>
                                                  digits[3]<="00100101";
                            when x"3"=>
                                                  digits[3]<="00001101";
                            when x"4"=>
                                                  digits[3]<="10011001";
                            when x"5"=>
                                                  digits[3]<="01001001";
                            when x"6"=>
                                                  digits[3]<="01000001";
                            when x"7"=>
                                                  digits[3]<="00011111"
                            when x"8"=>
                                                  digits[3]<="00000001"
                            when x"9"=>
                                                  digits[3]<="00011001";
                            when x"A" =>   -- 10 for I
                                                  digits[3] <= "11110011";
                            when others =>
                                                  digits[3]<="01100001";--E
                            end case;
                                       ----------------------------------------
                            case (decimals[2]) is
                            when x"0"=>
                                                  digits[2]<="00000011";
                            when x"1"=>
                                                  digits[2]<="10011111";
                            when x"2"=>
                                                  digits[2]<="00100101";
                            when x"3"=>
                                                  digits[2]<="00001101";
                            when x"4"=>
                                                  digits[2]<="10011001";
                            when x"5"=>
                                                  digits[2]<="01001001";
                            when x"6"=>
                                                  digits[2]<="01000001";
                            when x"7"=>
                                                  digits[2]<="00011111"
                            when x"8"=>
                                                  digits[2]<="00000001"
                            when x"9"=>
                                                  digits[2]<="00011001";
                            when x"A"=>   -- 10 for n
                                                  digits[3] <= "11110011";
                            when others =>
                                                  digits[2]<="01100001";--E
                            end case;
                                       ----------------------------------------
                            case (decimals[1]) is
                            when x"0"=>
                                                  digits[1]<="00000011";
                            when x"1"=>
                                                  digits[1]<="10011111";
                            when x"2"=>
                                                  digits[1]<="00100101";
                            when x"3"=>
                                                  digits[1]<="00001101";
                            when x"4"=>
                                                  digits[1]<="10011001";
                            when x"5"=>
                                                  digits[1]<="01001001";
                            when x"6"=>
                                                  digits[1]<="01000001";
                            when x"7"=>
                                                  digits[1]<="00011111"
                            when x"8"=>
                                                  digits[1]<="00000001"
                            when x"9"=>
                                                  digits[1]<="00011001";
                            when x"A"=> -- 10 for OFF
                                                  digits[1]<="11111111";
                            when others =>
                                                  digits[1]<="01100001";--E
                            end case;
                        end if;
                when "0001" => --pin
                    digits[4]<= "00110001"; --P
                    digits[3]<= "11110011"; --I
                    digits[2]<= "11110011"; --n
                    digits[1]<= "00000011"; --nothing
                when "0010" => --bal
                    digits[4]<= "11000001"; --b
                    digits[3]<= "00010001"; --A
                    digits[2]<= "11100011"; --L
                    digits[1]<= "00000011"; --nothing
                when "0011" => --cout
                    digits[4]<= "01100011"; --C
                    digits[3]<= "00000011"; --O
                    digits[2]<= "10000011"; --U
                    digits[1]<= "11100001"; --t
                when "0100" => --cin
                    digits[4]<= "01100011"; --C
                    digits[3]<= "11110011"; --I
                    digits[2]<= "11110011"; --n
                    digits[1]<= "00000011"; --nothing
                when "0101" => -- chec
                    digits[4]<= "01100011"; --C
                    digits[3]<= "11010001"; --h
                    digits[2]<= "01100001"; --E
                    digits[1]<= "01100011"; --C
                when "0110" => -- cpin
                    digits[4]<= "01100011"; --C
                    digits[3]<= "00110001"; --P
                    digits[2]<= "11110011"; --I
                    digits[1]<= "11110011"; --n
                when others=>  ------
                    digits[4]<= "11111101"; ---
                    digits[3]<= "11111101"; ---
                    digits[2]<= "11111101"; ---
                    digits[1]<= "11111101"; ---
               end case;
             end if;
    end process change_all_data_2_7segment;
    ----------------------------------------------------------------------------
    show_digits_on_segments: process(n_rst,clk,digits)
        type state_machine is (state1,state2,state3,state4,state5,state6,state7,state8);
        variable state : state_machine:= state1;
        variable cntr : STD_LOGIC_VECTOR (16 downtto 0); -- if clk=100MHz, then dogotts are showing 100 times per second
    begin
         if n_rst='0' then
            state := state1;
            cntr := (others=>"0"); -- segments can not show in high freqency
         else                      -- the number of refreshing must   be decreased
			if clk'event and clk='1' then
				if aux_blink_enable = '0' then
	                if cntr=(others=>"0") then
	                    case state is
							when state1 =>
								digit_out  <= "0111"; --1000 P17
								segment_out<= digits[4];
								state:= state5;
							when state2 =>
								digit_out  <= "1011"; --100 P18
								segment_out<= digits[3];
								state:= state6;
	                        when state3 =>
								digit_out  <= "1101"; --10 N15
								segment_out<=  digits[2];
								state:=  state7;
                            when state4=>
                                digit_out  <= "1110"; --  1 N16
                                segment_out<= digits[1];
                                state:= state8;
                            when state5 =>
                                digit_out  <= "1111";
                                segment_out<= (others=>"1");
                                state:= state2;
                            when state6 =>
                                digit_out  <= "1111";
                                segment_out<= (others=>"1");
                                state:= state3;
                            when state7 =>
                                digit_out  <= "1111";
                                segment_out<= (others=>"1");
                                state:=  state4;
                            when others=>
                                digit_out  <= "1111";
                                segment_out<= (others=>"1");
                                state:= state1;
                            end case;
                    else
	                    digit_out  <= "1111";
	                    segment_out<= (others=>"1");
                    end if;
                end if;
                cntr := cntr +"1";
            end if;
         end if;
    end process  show_digits_on_segments;
    ----------------------------------------------------------------------------
    blinking_Process:process(n_rst,clk,blink_pin)
    type state_machine is (blink_ON,blink_OFF);
        variable state : state_machine:= blink_OFF;
    variable blink_cntr : std_logic_vector(2 downto 0);
    variable blink_tmr : std_logic_vector(31 downto 0);
    begin
         if n_rst='0' then
            state:=blink_OFF;
            aux_blink_enable <= '0';
            blink_cntr := (others=>"0");
            blink_tmr  := (others=>"0");
         elsif clk'event and clk='1' then
         	aux_blink_enable <=  blink_pin;
--            case state is
--            when blink_OFF =>
--                 if ( blink_pin='1' ) then
--                    state:=blink_ON;
--                    blink_cntr := (others=>"0");
--                    blink_tmr  := (others=>"0");
--                    aux_blink_enable <= '1';
--                 end if;
--            when blink_ON =>
--                 blink_tmr := blink_tmr + "1";
--                 if(blink_tmr> x"2faf080") then   -- 50M for 0.5 second
--                        aux_blink_enable <= not aux_blink_enable;
--                        blink_tmr  := (others=>"0");
--                        blink_cntr := blink_cntr + "1";
--                 end if;
--                 if blink_cntr>= "110" then
--                    state:=blink_OFF;
--                    blink_tmr  := (others=>"0");
--                    blink_cntr := (others=>"0");
--                 end if;
--            when others =>
--                 state:=blink_OFF;
--                 aux_blink_enable <= '0';
--                 blink_cntr := (others=>"0");
--                 blink_tmr  := (others=>"0");
--            end case;
         end if;
    end process blinking_Process;
end Behavioral;

