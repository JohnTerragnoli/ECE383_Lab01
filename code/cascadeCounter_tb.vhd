--------------------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 10, 2015
-- File:	lec04_tb.vhdl
-- HW:	Lecture 4
--	Crs:	ECE 383
-- Purp:	testbench for lec4.vhdl
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--	Edited: by C2C John Paul Terragnoli
-- Changes: Removed junk signals.  1/15/15
-- Purpose: to link two mod-5 digit counters, with one to operate as the least
--	significan digit and the other as the most significant digit.  
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--	Edited: by C2C John Paul Terragnoli
-- Changes: Redesigned for counters which can count up to arbitrary values
-- Purpose: Wanted to test the module cascade counter when the counters inside
--				were given different values
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--necessary to use unsigned numbers and the math operations that go with them.  
use IEEE.NUMERIC_STD.ALL;
--setting up the inputs and outputs of the system.  
 
ENTITY hw4_tb IS
END hw4_tb;
 
ARCHITECTURE behavior OF hw4_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cascadeCounter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         crtl : IN  std_logic;
			countA1 : out unsigned (11 downto 0);
			countA0 : out unsigned (11 downto 0));
    END COMPONENT;
    
   --Initializing Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal crtl : std_logic := '0';

 	--Outputs from the double digit counter
   signal countA1  : unsigned(11 downto 0);
   signal countA0  : unsigned(11 downto 0);

   -- Clock period adjusted to 40ns from 10ns.  
   constant clk_period : time := 40 ns;
 
BEGIN
 
	--instantiation to test
   uut: cascadeCounter PORT MAP (
          clk => clk,
          reset => reset,
          crtl => crtl,
          countA1 => countA1,
          countA0 => countA0
        );

   --Defines the clock (up and down time)
		--this is just going to make an infinite square wave for the clock
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
      --hold the reset state for a bit so that everything settles down.  
      wait for 100 ns;	

		reset <= '0';
		wait for clk_period*2;
		reset <= '1';
		wait for clk_period*2;

		crtl <= '1';
		wait for clk_period*100;

      wait;
   end process;

END;
