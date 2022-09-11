--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cin_testbench IS
END cin_testbench;
 
ARCHITECTURE behavior OF cin_testbench IS 
 
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
         c_in_input : IN std_logic;
         odp : INOUT  std_logic;
         new_balance : OUT  std_logic_vector(10 downto 0);
		   balance_7seg : out STD_LOGIC_VECTOR (10 downto 0)
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

	--BiDirs
   signal c_in_active : std_logic;

 	--Outputs
   signal odp : std_logic;
   signal new_balance : std_logic_vector(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	c_in_active <= c_in_input;
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
          c_in_active => c_in_active,
          odp => odp,
          new_balance => new_balance
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
		c_in_input<='1';
		balance<="00001100100";
		left<='0';
		right<='0';
		res<='0';
		up<='1';
		wait for 20 ns;
		up<='0';
		wait for 20 ns;
		down<='1';
		wait for 20 ns;
		down <='0';
		wait for 20 ns;
		center<='1';
		
      wait;
   end process;

END;
