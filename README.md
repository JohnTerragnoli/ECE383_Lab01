# ECE383_Lab1
==============


#Introduction

The purpose of this lab was to program the ATLYS (FPGA) in VHDL code so that it would output an HDMI as an output signal.  This output signal was of an oscilloscope, which included the grid design, the time and voltage trigger markers, which respond to button clicks on the FPGA, as well as two input channels, although these have not been fully implemented yet.  

#Implementation

To start off this design, the following files were given: 


Also, this schematic was given in the instructions: 

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/Original%20Schematic.PNG "original schematic")

Then, this picture was made to give overview and insight to how the overall program would run.  This was done with the proper names according to the signals used in the actual coding.  

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/Total%20Schematic.JPG "total schematic")

The Double Counter box is expanded below, as it was too complex to fit in a small space: 
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab01/master/pictures/DoubleCounterSchematic.JPG "double counter schematic")

The description of each part in the picture can be seen below: 

##Lab1.vhd

##Button Decoder

##Video

##DCM

##VGA

##Double Counter

##H_Synch

##V_Synch

##ScopeFace

##DVID

*Note: some of the elements on the schematic given in the directions were excluded from the final drawing.  This it because those parts were implemented in a different module where their function was taken care of.  This includes the Muxes at the ouput of scopeface and the OBUFDS on the output of DVID.   

#Test/Debug
