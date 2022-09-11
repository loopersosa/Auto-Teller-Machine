library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main_entity is
    port (
        clk         : in std_logic;                       -- clock
        n_rst       : in std_logic;                       -- reset (Active low)
        --------------------------------------------
        digit_out   : out STD_LOGIC_VECTOR (1 to 4);      -- this output select witch digit is ON , (P17,P18,N15,N16)
        segment_out : out STD_LOGIC_VECTOR (1 to 8);      -- select segment of digit
        led_out     : out std_logic_vector (0 to 7);      -- LEDs ON simulation board
        --------------------------------------------
        switches    : in  STD_LOGIC_VECTOR (1 to 8);      -- switches of simulation board
        PUSH_BUTTONS: in  STD_LoGIC_VECTOR (1 to 5)       -- push buttons of simulation board
                                                          -- 1: center 2: up 3: right 4: down 5: left
    );
end entity;

architecture Behavioral of main_entity is
    type state_machine is (Entering_a_PIN_number,menu,Balance_Inquiry,Cash_Withdrawal,Cash_Deposit,Check_Deposit,Change_PIN);
    
    signal state         : state_machine := Entering_a_PIN_number;
    
    signal Change_state  : std_logic                := '0'  ; -- when the state not selected
    signal Selected_state: STD_LOGIC_VECTOR (0 to 2):="000" ; -- 000:BAL 001:COUT 010:CIN 011:CHEC 100:CPIN
    signal Pass_is_ok     : std_logic                := '0'  ; -- when the PIN is correct
    signal show_pin      : STD_LOGIC;
    signal blinking      : STD_LOGIC;
    signal password      : STD_LOGIC_VECTOR (7 downto 0);
    signal aux_LED0      : std_logic := '0';
    signal switches_in_pass : STD_LOGIC_VECTOR (1 to 8); 
    signal PUSH_BUTTONS_start : STD_LoGIC_VECTOR (1 to 5);

    -----------------------read_pin component -----------------------
    component read_pin is
        port (
            clk: in STD_LOGIC;
            n_rst: in STD_LOGIC;
            push_btns: in STD_LOGIC_VECTOR (5 downto 1);
            switches: in STD_LOGIC_VECTOR (7 downto 0);
            password: in STD_LOGIC_VECTOR (7 downto 0);
            LED0    : out STD_LOGIC;
            show_pin: out STD_LOGIC;
            blinking: out STD_LOGIC;
            Pass_is_ok: out STD_LOGIC
            
        );
    end component;
    -----------------------read_pin component -----------------------

begin
    rpc : read_pin 
        port map (
            clk       => clk,
            n_rst     => n_rst,
            push_btns => PUSH_BUTTONS_start,
            switches  => switches_in_pass,
            password  => password,
            LED0      => aux_LED0,
            show_pin  => show_pin,
            blinking  => blinking,
            Pass_is_ok=> Pass_is_ok
        ); 
    
    process (all)
    begin
        if (n_rst ='0') then
            state    <= Entering_a_PIN_number;
            aux_LED0 <= '0';
        elsif clk'event and clk='1' then
           
            case state is
            when Entering_a_PIN_number =>
                led_out(0) <=aux_LED0;
                PUSH_BUTTONS_start <= PUSH_BUTTONS;
                switches_in_pass <= switches;
                if Pass_is_ok = '1' then
                    state <= menu;
                end if ;
                
            when menu                 =>
                
                
                if Change_state = '1' then
                    
                    if Selected_state = "000" then
                        state <= Balance_Inquiry;
                    elsif Selected_state = "001" then
                        state <= Cash_Withdrawal; 
                    elsif Selected_state = "010" then
                        state <= Cash_Deposit   ;
                    elsif Selected_state = "011" then
                        state <= Check_Deposit  ;
                    elsif Selected_state = "100" then
                        state <= Change_PIN     ;
                    end if ; 

                end if ;

            when Balance_Inquiry       =>
     
            when Cash_Withdrawal       =>
     
            when Cash_Deposit          =>

            -- if flag cash deposit = 1 => state <= menu
            when Check_Deposit         =>
     
            when Change_PIN            =>
     
            when others                =>
                state <=  Entering_a_PIN_number;
            end case;
        end if;
    end process;
end Behavioral;