library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity read_pin is
    port(
        clk       : in STD_LOGIC;                    -- clock
        n_rst     : in STD_LOGIC;                    -- reset
        push_btns : in STD_LOGIC_VECTOR (5 downto 1);-- push buttons
        switches  : in STD_LOGIC_VECTOR (7 downto 0);-- switches
        password  : in STD_LOGIC_VECTOR (7 downto 0);-- password
        LED0      : out STD_LOGIC;                   -- LED 0
        show_pin  : out STD_LOGIC;                   -- show pin on 7seg
        blinking  : out STD_LOGIC;                   -- blinking Pin on 7seg
        Pass_is_ok: out STD_LOGIC                    -- if the pass that was entered is correct
    );
end read_pin;
architecture behavioral of read_pin is
    signal cntr:        STD_LOGIC_VECTOR(22 downto 0)    :=(others=>'0'); --counter
    signal aux_btn1:    STD_LOGIC_VECTOR (1 downto 0)    :="00" ;         --auxiliary btn center 0: now 1: last
    alias enter_pin:    STD_LOGIC is push_btns(1);                        -- if btn center is pressed
    signal timer_3_seconds: STD_LOGIC_VECTOR (7 downto 0):=x"00";         -- counter of timer
	signal zero_holder : STD_LOGIC_VECTOR(22 downto 0)  :=(others=>'0'); -- cous counter of timer being zero

    begin
        process(clk)
            begin
                if (clk'event and clk='1') then 
                    cntr <= cntr + "1";
                end if;
        end process;

    main_process: Process(clk, n_rst, push_btns)
        begin
            if (n_rst='0') then --reset
                show_pin <= '1';
                blinking <= '0';
                LED0     <= '0';
                Pass_is_ok <= '0';
                timer_3_seconds <= x"00";
            else
				aux_btn1(1)<=aux_btn1(0);
                aux_btn1(0)<=enter_pin;
                if timer_3_seconds = x"00" then
                    if(aux_btn1 = "01") then
                        if(switches=password) then
                            LED0        <='1';
                            show_pin    <='0';
                            blinking    <='0';
                            Pass_is_ok  <='1';
                            timer_3_seconds <= x"00";
                        else
                            LED0        <='0';  
                            show_pin    <='1';
                            blinking    <='1';
                            Pass_is_ok  <='0';
                            timer_3_seconds <=x"20";
                         end if;
                    elsif (aux_btn1="00") then
                        show_pin     <='1';
                        blinking     <='0';
                        LED0         <='0';
                        Pass_is_OK   <='0';
                        timer_3_seconds <=x"00";
                    end if;
                else
                    if timer_3_seconds > x"00" then
                        timer_3_seconds <= timer_3_seconds-x"01";
                    end if;
                end if;
            end if;
    end process main_process;
end behavioral;