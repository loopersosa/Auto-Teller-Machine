--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:05:26 07/04/2022
-- Design Name:   
-- Module Name:   C:/Users/ayroz/Desktop/team/meht/testbench.vhd
-- Project Name:  final_prj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Cin
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
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Cin
    PORT(
         up : IN  std_logic;
         down : IN  std_logic;
         right : IN  std_logic;
         left : IN  std_logic;
         center : IN  std_logic;
         clk : IN  std_logic;
         res : IN  std_logic;
         balance : IN  std_logic_vector(10 downto 0);
         c_in_input : IN  std_logic;
         odp : INOUT  std_logic;
         new_balance : OUT  std_logic_vector(10 downto 0);
         balance_7seg : OUT  std_logic_vector(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal up : std_logic := '0';
   signal down : std_logic := '0';
   signal right : std_logic := '0';
   signal left : std_logic := '0';
   signal center : std_logic := '0';
   signal clk : std_logic := '0';
   signal res : std_logic := '0';
   signal balance : std_logic_vector(10 downto 0) := (others => '0');
   signal c_in_input : std_logic := '0';

	--BiDirs
   signal odp : std_logic;

 	--Outputs
   signal new_balance : std_logic_vector(10 downto 0);
   signal balance_7seg : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Cin PORT MAP (
          up => up,
          down => down,
          right => right,
          left => left,
          center => center,
          clk => clk,
          res => res,
          balance => balance,
          c_in_input => c_in_input,
          odp => odp,
          new_balance => new_balance,
          balance_7seg => balance_7seg
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
		left<='0';
		right<='0';
		center<='0';
		down<='0';
		up<='0';
		balance <="00001100100";
		c_in_input<='1';
		
		res<='0';
		wait for 20 ns;
		left<='1';
		wait for 5 ns;
		left<='0';
		wait for 5 ns;
		right<='1';
		wait for 5 ns;
		right<='0';
      wait;
   end process;

END;
