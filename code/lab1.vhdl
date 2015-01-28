----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Paul Terragnoli
-- 
-- Create Date:    13:58:31 01/22/2015 
-- Module Name:    Lab1 - structural 
-- Project Name: 	 lab01
-- Target Devices: ATLYS Spartan 6
-- Tool versions: 1.0
-- Description: Creates the output for the oscilloscope, including channels 1 and 2, 
--					the triggers for voltage and time, and the grid itself.  Should be able 
--					to accept an input and draw it on the screen.  Output is through HDMI.  
--
-- Dependencies: VGA
--
-- Revision: none				
-- Revision 0.01 - File Created
-- Additional Comments: none
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lab1 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  btn: in	STD_LOGIC_VECTOR(4 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end lab1;

architecture structure of lab1 is


--keep track of locations of the triggers
	signal trigger_time, trigger_volt: unsigned(11 downto 0);
	
--keeps track of place we're writing to on the screen
	signal row, column: unsigned(11 downto 0);

--keeps track of the last and new button press so we only move on a click
	signal old_button, button_activity: std_logic_vector(4 downto 0);

--the two inputs for the oscilloscope
	signal ch1_wave, ch2_wave: std_logic;
	

--converts the input channels into a visual signal on the screen. 	
	component video is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  trigger_time: in unsigned(11 downto 0);
			  trigger_volt: in unsigned (11 downto 0);
			  row: out unsigned(11 downto 0);
			  column: out unsigned(11 downto 0);
			  ch1: in std_logic;
			  ch1_enb: in std_logic;
			  ch2: in std_logic;
			  ch2_enb: in std_logic);
	end component;
	

begin


	------------------------------------------------------------------------------
	-- the variable button_activity will contain a '1' in any position which 
	-- has been pressed or released.  The buttons are all nominally 0
	-- and equal to 1 when pressed.
	------------------------------------------------------------------------------


	------------------------------------------------------------------------------
	-- If a button has been pressed then increment of decrement the trigger vars
	------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	
--should take care of the counting, and the conditional statements that determine
--the color of each pixel.  Picture signals output in HDMI form.  
	video_inst: video port map( 
		clk => clk,
		reset => reset,
		tmds => tmds,
		tmdsb => tmdsb,
		trigger_time => trigger_time,
		trigger_volt => trigger_volt,
		row => row, 
		column => column,
		ch1 => ch1_wave,
		ch1_enb => ch1_wave,
		ch2 => ch2_wave,
		ch2_enb => ch2_wave);



---------------------------------------------------------------------------------------------
--BUTTON DECODER START
---------------------------------------------------------------------------------------------
--makes it work with just one click and not a press so it doesn't run across the screen. 	
process(clk)
	begin
	if(rising_edge(clk)) then
		if(reset = '0') then
			old_button <= "00000";
		else
			button_activity <= (not old_button) and btn;
		end if;
			old_button <= btn;
	end if;
end process;



--checks to see if a button has been hit for every clock cycle.  		
	process(clk)
	begin
		if(rising_edge(clk)) then
			--centers the triggers again.  
			if(reset='0') then
				trigger_time <= x"140";
				trigger_volt <= x"0DC";
				
			--moves volt trigger up
			elsif((button_activity = "00001") and (trigger_volt>=30)) then
				trigger_volt <= trigger_volt - x"0A";
				
			--move time trigger left
			elsif((button_activity= "00010") and (trigger_time>=30)) then
				trigger_time <= trigger_time - x"0A";
				
			--moes volt trigger down
			elsif((button_activity = "00100") and (trigger_volt<=410)) then
				trigger_volt <= trigger_volt + x"0A";
			
			--moves time trigger right
			elsif((button_activity = "01000") and (trigger_time<=610))then
				trigger_time <= trigger_time + x"0A";
			
			--moves the triggers back to center.  
			elsif(button_activity = "10000") then
				trigger_time <= x"140";
				trigger_volt <= x"0DC";
				
			end if;
		end if;
	end process;
---------------------------------------------------------------------------------------------
--BUTTON DECODER END
---------------------------------------------------------------------------------------------

end structure;