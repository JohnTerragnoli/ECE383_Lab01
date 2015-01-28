# ECE383_Lab1
==============


#Introduction

The purpose of this lab was to program the ATLYS (FPGA) in VHDL code so that it would output an HDMI as an output signal.  This output signal was of an oscilloscope, which included the grid design, the time and voltage trigger markers, which respond to button clicks on the FPGA, as well as two input channels, although these have not been fully implemented yet.  

#Implementation

To start off this design, the following files were given: 

[lab1.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/lab1.vhdl)

[lab1.ucf](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/lab1.ucf)

[video.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/video.vhdl)

[vga_tb.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/vga_tb.vhdl)

[dvid.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/dvid.vhdl)

[tdms.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/tdms.vhdl)



Also, this schematic was given in the instructions: 

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/Original%20Schematic.PNG "original schematic")

Then, this picture was made to give overview and insight to how the overall program would run.  This was done with the proper names according to the signals used in the actual coding.  

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/Total%20Schematic.JPG "total schematic")

The Double Counter box is expanded below, as it was too complex to fit in a small space: 
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/DoubleCounterSchematic.JPG "double counter schematic")

*Note: some of the elements on the schematic given in the directions were excluded from the final drawing.  This it because those parts were implemented in a different module where their function was taken care of.  This includes the Muxes at the ouput of scopeface and the OBUFDS on the output of DVID.   

The description of each part in the picture can be seen below: 


##Lab1.vhd
**Overall Purpose** Contains all of the files necessary to convert an electrical input, or signal, to a visual display on an LCD screen.  It does this by outputting the signal in HDMI format.  Also, it accepts input from buttons the ATLYS to move time and voltage triggers on the screen.  Comes with a reset button to place triggers back to center. 

**Inputs** btn (5 bits), clk, and reset.  Eventually, in later labs, this may be modified to that it can intake an actual electrical signal.  

**Outputs** tmds and tmdsb.  These outputs are in HDMI form and can be accepted by the LCD monitor used in class.  It is a visual signal draw desired images on the screen.  

**Behavior** 


##Button Decoder
**Overall Purpose** Convert the signals from the 5 different buttons on the ATLYS board to reset and shift the location of the trigger time and trigger volt up and down on the screen.  

**Inputs** clk, reset, and btn (5 bit)

**Outputs** tigger_time (12 bits) and trigger_volt (12 bits).  

**Behavior**  First of all, this was not actually done in its own module, but instead was just done in two processes inside the lab 1 module.  The first process worked so that the trigger_time and trigger_volt only changed when a complete click of the button (down AND up) took place.  Otherwise, the triggers would zip across the screen with only a small press.  The second process contained the logic for decoding which buttons were actually hit.  The middle button was the soft reset, so that when it was hit, the location of the trigger_time and trigger_volt was reset to be centered on the screen.  The top and botton buttons were wired so that they would move the trigger_volt icon up and down the screen.  The left and right buttons were wired so that they would move the trigger_time icon left and right on the screen. The icons moved by incrememts of 10 (aside from bouncing), and only did so when a complete click was made.  Unfortunately nothing was done for the debouncing problem.  


##Video
**Overall Purpose** Create the actual HDMI signal while following a clock and accepting the location of the triggers from lab 1. 

**Inputs** clk, reset, trigger_time, trigger_volt, ch1, ch1_enb, ch2, ch2_enb

**Outputs** tmds, tmdsb

**Behavior**
Responsible for all of the work going on in the lab1 module, except for the deciphering of the buttons and the changing of the location of the triggers.  

##DCM(1)
**Overall Purpose** Creates the 12.5MHz pixel clock from the given 100MHz clock.  Like a divider.  

**Inputs** clk, reset

**Outputs** pixel_clk

**Behavior** Just an entity of it is created in the video.vhd module. I did not create this file it was just used. 


##DCM(2)
**Overall Purpose** Creates the 12.5MHz pixel clock from the given 100MHz clock.  Like a divider.  

**Inputs** clk, reset

**Outputs** serialize_clk, serialize_clk_n

**Behavior** Just an entity of it is created in the video.vhd module. I did not create this file it was just used. 


##VGA
**Overall Purpose** Counts all of the pixels on the screen and assigned them different RGB values according to the desicred image.  

**Inputs** pixel_clk, reset, trigger_time, trigger_volt, ch1, ch1_enb, ch2, and ch2_enb.  

**Outputs** h_synch, v_synch, blank, R, G, and B. 

**Behavior** The counting takes place in double counter, which utilized process.  H_synch and V_synch are done using combinatonal logic.  The row and column numbers generated in the counter are used to determine the color of the pixel at that point, taken care in scopeFace.  The H_synch and V_synch models are useful for ensuring the visual signal is output properly.


##Double Counter
**Overall Purpose**  Count through all the pixel on the screen, one at a time, and output the current value of the row and column focusing on.  

**Inputs** clk (which is really the pixel_clk), reset, and crtl (hung at a '1' so that it is always counting)

**Outputs** countA0 and countA1, which are the column and row respectively.  

**Behavior** Created using 2 instantiations of a single counter, which can count up to a single number and then pass a roll over number out as well.  The two were linked together so that the rollover of the first, faster counting, counter, was the control signal of the second one.  Therefore, the second counter could only keep counting when there was a rollover in the faster moving counter.  


##H_Synch
**Overall Purpose** 
**Inputs**
**Outputs**
**Behavior**


##V_Synch
**Overall Purpose** 
**Inputs**
**Outputs**
**Behavior**


##ScopeFace
**Overall Purpose** 
**Inputs**
**Outputs**
**Behavior**


##DVID
**Overall Purpose** 
**Inputs**
**Outputs**
**Behavior**



#Test/Debug


#Documentation: 
