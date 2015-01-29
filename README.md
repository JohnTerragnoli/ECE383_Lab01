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






**The modules below were used but not created or edited.  **





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


##DVID
**Overall Purpose** To output the desired image in HDMI format and ensuring that all of the rows and columns are synched together for a cohesive picture.  Converts VGA signals into DVID bitstreams.

**Inputs** Red, Green, Blue

**Outputs** tmds, tmdsb

**Behavior** This module was given to us and nothing was changed.  However, it is given the RGB values for each pixel, as well as the blank, h_synch, and v_synch signals, which ensures that the picture can be output in DVID bitstreams.  Also, notice that in the picture DVID and the OBUFDS were mixed together, since neither of them were touched in the creation process.  



#Test/Debug

##Construction Process:
1. First, I decided to modify my counter from HW4 to work for arbitrary numbers.  This could then be used to count the number of rows and columns on the screen.  To do this I simply just created another input in the counter.vhd module.  An issue which drove me crazy was that my counter would not work for decimal numbers.  I tried a number of different things, but eventually gave up.  It worked with binary, but that got annoying fast.  So I decided to use hex, and then just increase the number of bits in row and column from 10 to 12 so I could just use three hex digits.  This seemed to work well, and of course I changed all of the other modules to work for 12 bit row and column addresses.  
2. Used HW4 to find the numbers to count to in the counters.  This turned out to be 799 and 524, for columns and rows, respectively.  I ran my testbench from HW4 to verify that the counters glued together worked correctly.  
3. Then the h and v synch and blank modules were created.  This was done fairly quickly as it required only a few lines of code.  
4. I followed the directions for the lab online to create the appropriate instantiations of VGA in video, and scopeFace in VGA.  No issues here, other than having to make the trigger, row, and column lengths to be 12 bits.  
5. ScopeFace was then made, at first without any combinational logic.  I simply made the RGB value to be 0xFFFFFF, or an all white screen.  When I ran the program, I got a sort of hazy white signal.  I decided to take another look at my code, figuring that the h_synch and/or v_synch must be off in some place.  It turns out that when I was converting values to hex, copied some of the numbers down wrong when writing the when statements for the h and v synch modules.
6. I tried running the code again, and this time, nothing showed up on the monitor.  I wasn't sure what to check so I just turned the monitor off and on again, and then a white screen appeared.  I had to do this same trick several times later in the lab to get the appropriate image to show up.  
7. Then, I made the grid in baby steps.  First the when statements for the verticle lines, then the horizontal lines, then the vertical tic marks, then the horizontal tick marks.  Everything was going swell up until making the horizontal tic marks, but then, they were showing up sporatically in random spots.  When I tried to go back to the when statement to fix this, I just got lost in the numerous logic statements.  I decided to clean this up by creating intermediary signals like "grid" where I wrote the logic to draw the grid and then simply called the grid signal in then when statements for R, G, and B instead of huge mess.  When doing this, I discoved my small error in the mod I was using for the horizontal tic marks.  The gird was built accorind to the drawing below: 

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/Oscilloscope%20Display.JPG "O-Scope Plan")


8. After this, I created more intermediary signals for channel 1, channel 2, and the triggers, which I defined using the directions for how the stationary lines should look.  At this point they all showed up on the screen but nothing moved.  
9. After listening to Dr. York's lecture on how to use two processes and an old and new button, I decided to do exactly what he did to use the buttons to move the trigger markers around.  The processes were used so that movement would only occur when a complete click occured.  The last button click was then made to be the old button, and to check whether to move again, the new button was compared with the old button as ((not old_button) and btn).  This did not get rid of debouncing, but it made the buttons respond much better.
10. Once I got the buttons working, I was playing with the triggers, and then I moved them off the oscilloscope screen.  To fix this, I added some combinational logic in Lab1.vhdl to ensure that the trigger position would move off the oscilloscope screen.  Once this was done, a functionality was completed.  


##Testbench Proofs

Here are the desired snapshots:

Show the h_synch going high, low, high, and related h count.
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/h_synch_tb.PNG "h_synch tb")


It is hard to tell from the diagram, but the pertinent measurements are below:
Fall Time:26.3us 
Rise Time: 30.1us

Show the h count rolling over causing the v count to increment
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/rollOver.PNG "roll over")

It is hard to tell from the diagram, but the pertinent measurements are below:
rollover time: 32.02us


Show the v_synch going high, low, high, and related v count.
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/v_synch_tb.PNG "v_synch tb")

It is hard to tell from the diagram, but the pertinent measurements are below:
Fall Time:15.86ms 
Rise Time: 15.744ms

Also, in addition to the VGA testbench, I also used a testbench for the double counter to ensure that it was working properly.  Below are the screenshots proving the rollover of the first and second place in the double counter.  

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/first_place_rollover.PNG "first place rollover")

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/second_place_rollover.PNG "second place rollover")


#Files

All of the files used in the lab can be seen below: 

1. [cascadeCounter.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/cascadeCounter.vhd)
2. [cascadeCounter_tb.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/cascadeCounter_tb.vhd)
3. [counter.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/counter.vhd)
4. [dvid.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/dvid.vhdl)
5. [h_synch.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/h_synch.vhd)
6. [lab1.ucf](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/lab1.ucf)
7. [lab1.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/lab1.vhdl)
8. [scopeFace.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/scopeFace.vhd)
9. [tdms.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/tdms.vhdl)
10. [v_synch.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/v_synch.vhd)
11. [vga.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/vga.vhd)
12. [vga_tb.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/vga_tb.vhdl)
13. [video.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/video.vhdl)
14. [VGA waveform](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/code/vga_testbench_waveform.wcfg)
15. [bit file](https://github.com/JohnTerragnoli/ECE383_Lab01/blob/master/code/lab1.bit)




#Documentation: 
C2C Sabin Park said that it was really hard to use decimal digits within the modules, so he Recommended using hexidecimal.  To make this alright, I then had to increase the length of the signal
Coming into the cascade counter so that it could be written in hexidecimal/have the right number of bits.  

