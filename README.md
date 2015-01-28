# ECE383_Lab1
==============


#Introduction

The purpose of this lab was to program the ATLYS (FPGA) in VHDL code so that it would output an HDMI as an output signal.  This output signal was of an oscilloscope, which included the grid design, the time and voltage trigger markers, which respond to button clicks on the FPGA, as well as two input channels, although these have not been fully implemented yet.  

#Implementation

To start off this design, the following files were given: 

1. [lab1.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/lab1.vhdl)
2. [lab1.ucf](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/lab1.ucf)
3. [video.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/video.vhdl)
4. [vga_tb.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/vga_tb.vhdl)
5. [dvid.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/dvid.vhdl)
6. [tdms.vhdl](http://ecse.bd.psu.edu/cenbd452/lab/lab1/code/tdms.vhdl)



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

**Behavior** The counting takes place in double counter, which utilized process.  H_synch and V_synch are done using combinatonal logic and then output.  The row and column numbers generated in the counter are used to determine the color of the pixel at that point, taken care in scopeFace.  


##Double Counter
**Overall Purpose**  Count through all the pixel on the screen, one at a time, and output the current value of the row and column focusing on.  

**Inputs** clk (which is really the pixel_clk), reset, and crtl (hung at a '1' so that it is always counting)

**Outputs** countA0 and countA1, which are the column and row respectively.  

**Behavior** Created using 2 instantiations of a single counter, which can count up to a single number and then pass a roll over number out as well.  The two were linked together so that the rollover of the first, faster counting, counter, was the control signal of the second one.  Therefore, the second counter could only keep counting when there was a rollover in the faster moving counter.  


##H_Synch
**Overall Purpose** To recreate the waveform shown below in accorance to the pixel in the row currently being drawn, which synchs up everything after completing a row to ensure that the image is not misaligned.    

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/h_synch_waveform.PNG "H synch/blank")

Doing this allows the image to be presented correctly on the screen.  

**Inputs** clk, columnNumber, reset

**Outputs** h_synch_signal, h_blank_signal

**Behavior** This is just a bunch of combinational logic describing when the synch and blank signals are high and low, in accorance to the picture above.  It is created in it's own module. 


##V_Synch
**Overall Purpose** To recreate the waveform shown below in accorance to the pixel in the row currently being drawn. Done to check if everything is still synched up at the end of the screen being printed.  

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/v_synch_waveform.PNG "V synch/blank")

**Inputs** rowNumber, clk, reset

**Outputs** v_synch_signal, v_blank_signal

**Behavior** This is just a bunch of combinational logic describing when the synch and blank signals are high and low, in accorance to the picture above.  It is created in it's own module. 


##ScopeFace
**Overall Purpose** Responsible for assigning the RGB values to each pixel that the computer works on.  

**Inputs** columnNumber, trigger_volt, trigger_time, rowNumber, ch1, ch1_enb, ch2, and ch2_enb

**Outputs** R, G, and B, for the two hex-digit values for red, green, and blue for every specific pixel.  

**Behavior**  Within this module is a lot of simplification.  It has signals which describe the grid patter, the trigger patter, and the channel patterns to be drawn on the screen.  This was done to keep track of all then when statements used in it, which quickly became overwhelming.  


##DVID
**Overall Purpose** To output the desired image in HDMI format and ensuring that all of the rows and columns are synched together for a cohesive picture.  Converts VGA signals into DVID bitstreams.

**Inputs** Red, Green, Blue

**Outputs** tmds, tmdsb

**Behavior** This module was given to us and nothing was changed.  However, it is given the RGB values for each pixel, as well as the blank, h_synch, and v_synch signals, which ensures that the picture can be output in DVID bitstreams 



#Test/Debug


#Documentation: 
