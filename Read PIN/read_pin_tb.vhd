--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:58:44 07/04/2022
-- Design Name:   
-- Module Name:   C:/Users/ayroz/Desktop/ISE/finalprj/menu_test/read_pin_tb3.vhd
-- Project Name:  menu_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: read_pin
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY read_pin_tb3 IS
END read_pin_tb3;
 
ARCHITECTURE behavior OF read_pin_tb3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT read_pin
    PORT(
         clk : IN  std_logic;
         n_rst : IN  std_logic;
         push_btns : IN  std_logic_vector(5 downto 1);
         switches : IN  std_logic_vector(7 downto 0);
         password : IN  std_logic_vector(7 downto 0);
         LED0 : OUT  std_logic;
         show_pin : OUT  std_logic;
         blinking : OUT  std_logic;
         Pass_is_ok : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal n_rst : std_logic := '0';
   signal push_btns : std_logic_vector(5 downto 1) := (others => '0');
   signal switches : std_logic_vector(7 downto 0) := (others => '0');
   signal password : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal LED0 : std_logic;
   signal show_pin : std_logic;
   signal blinking : std_logic;
   signal Pass_is_ok : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: read_pin PORT MAP (
          clk => clk,
          n_rst => n_rst,
          push_btns => push_btns,
          switches => switches,
          password => password,
          LED0 => LED0,
          show_pin => show_pin,
          blinking => blinking,
          Pass_is_ok => Pass_is_ok
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		n_rst<='0';
		password <="00010001";
		push_btns<="00000";
		switches <="00000001";
      wait for 100 ns;
		
		n_rst<='1';
		password <="00010001";
		push_btns<="00000";
		switches <="00110001";
		wait for 100 ns;
		
		n_rst<='1';
		password <="00010001";
		push_btns<="11111";
		switches <="00110001";
		wait for 100 ns;
		
		n_rst<='1';
		password <="00010001";
		push_btns<="00000";
		switches <="00010001";
		wait for 100 ns;
		
		n_rst<='1';
		password <="00010001";
		push_btns<="11111";
		switches <="00010001";
		wait for 100 ns;
--		
--		n_rst<='0';
--		password <="00010001";
--		push_btns<="00001";
--		switches <="00010001";
--		wait for 100 ns;
--		
      wait;
   end process;

END;
