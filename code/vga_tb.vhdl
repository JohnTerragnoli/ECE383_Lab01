----------------------------------------------------------------------------------
-- Company:   USAFA 
-- Engineer:  Dr. Coulston
-- USer: 		C2C John Paul Terragnoli 
-- 
-- Create Date:    13:57:28 01/22/2015 
-- Module Name:    vga - Behavioral 
-- Project Name:   Lab01
-- Target Devices: ATLYS Spartan 6
-- Tool versions: 1.0
-- Description: Tests the vga module.  Ensures that it can output all of the required 
--					signals correctly.  
--
-- Dependencies: cascadeCounter, counter, h_synch, v_synch, scopeFace, and vga.  
--
-- Revision:     none
-- Revision 0.01 - File Created
-- Additional Comments: This module was written by my instructors and I have only added
--						comments when necessary. 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY lab1_tb IS
END lab1_tb;
 
ARCHITECTURE behavior OF lab1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			h_sync : out  STD_LOGIC;
			v_sync : out  STD_LOGIC; 
			blank : out  STD_LOGIC;
			r: out STD_LOGIC_VECTOR(7 downto 0);
			g: out STD_LOGIC_VECTOR(7 downto 0);
			b: out STD_LOGIC_VECTOR(7 downto 0);
			trigger_time: in unsigned(11 downto 0);
			trigger_volt: in unsigned (11 downto 0);
			row: out unsigned(11 downto 0);
			column: out unsigned(11 downto 0);
			ch1: in std_logic;
			ch1_enb: in std_logic;
			ch2: in std_logic;
			ch2_enb: in std_logic);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal trigger_volt : unsigned(11 downto 0) := (others => '0');
   signal trigger_time : unsigned(11 downto 0) := (others => '0');
   signal row : unsigned(11 downto 0) := (others => '0');
   signal column : unsigned(11 downto 0) := (others => '0');
	signal ch1, ch1_enb, ch2, ch2_enb: std_logic := '0';
	
 	--Outputs
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal blank : std_logic;

   signal r : std_logic_vector(7 downto 0);
   signal g : std_logic_vector(7 downto 0);
   signal b : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 40 ns;
 
BEGIN
 
	--making an instantiation of vga so it can be tested.  
   uut: vga PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          v_sync => v_sync,
          blank => blank,
          r => r,
          g => g,
          b => b,
          trigger_volt => trigger_volt,
          trigger_time => trigger_time,
			row => row,
			column => column,
			ch1 => ch1,
			ch1_enb => ch1_enb,
			ch2 => ch2,
			ch2_enb => ch2_enb			 
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	reset <= '0', '1' after 30nS;


END;