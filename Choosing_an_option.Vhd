library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Choosing_an_option is
Port(
    	clk         	: in  STD_LOGIC;  -- hardware is synchronized with clk
    	n_rst       	: in  STD_LOGIC;  -- active low reset initilizes everything
    	PUSH_BOTONMS	: in  STD_LoGIC_VECTOR (5 downto 1);
    	selected_service: out STD_LoGIC_VECTOR (2 downto 0)
    );
end Choosing_an_option;

architecture Behavioral of Choosing_an_option is
	signal cntr :STD_LoGIC_VECTOR (22 downto 1);
    signal aux_selected : STD_LoGIC_VECTOR (2 downto 0);
begin
    timer_process: process(clk)
    begin
    	if clk'event and clk='1' then
    		cntr<= cntr+"1";
    	end if;
    end process timer_process;

	selection_process: process(clk,n_rst,PUSH_BOTONMS)
    begin
    	if n_rst='0' then
        	selected_service <= "00"; -- read pin
            aux_selected <= "000";
        elsif clk'event and clk='1' and cntr=(others=>'0') then
        	case PUSH_BOTONMS is
            	when "00001" =>
                    if aux_selected < "101" then
                	aux_selected <= aux_selected +"001";
                    end if;
                --when "00010" =>

                when "00100" =>
                    if aux_selected > "001" then
                	aux_selected <= aux_selected -"001";
                    end if;
                --when "01000" =>

                when "10000" =>
                    selected_service <= aux_selected;
                when others =>
                    selected_service <= aux_selected;
            end case;
        end if;

    end process selection_process;

end Behavioral;


