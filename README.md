
# MD6-FPGA-implementation
Name file: README


Project Name:				FPGA implementation of MD6 hash algorithm  
Link to YouTube Video:   https://youtu.be/c6ThYfS_pMA  
Link to Project repository:   https://github.com/aviel207/Final_Project.git 
Link to Full Demonstration Of Implementing The CF MD6 On FPGA video :	https://youtu.be/ZC4aacu0pbw  
University Name:			  Jerusalem College of Technology (JCT)  
Participant 1:				  Aviel Birduaker  
Participant 1 E-mail:			birduake@g.jct.ac.il  
Participant 2:				  Ofek Sharabi  
Participant 2 E-mail:			ofsharab@g.jct.ac.il  
Supervisor:				      Uri Stroh  
Supervisor E-mail:			stroh@jct.ac.il  
  
Board used:			        Basys 3 by Digilent Inc.  
Software Version:			Vivado 2022.1  

# Description of Project:  
Implementation of MD6 Hash algorithm in Verilog language in Artix-7 FPGA of Basys3 board.  


# Description of Archive:

* The "Documents" folder - the documents folder contains the algorithm report submitted as one of the algorithm proposals for the NIST SHA-3 hashing standard competition, the project reports, the project report submitted to the competition on behalf of Xilinx-AMD and the information pages of the basys3 development kit.

* The "MD6_CF_hardware" folder – the design files folder of the algorithm implemented in hardware containing the source files, the mem files, the compilation file, the XDC file, and the test bench files.

* The "MD6_CF_prototype" folder – a folder containing the initial design of the compression function.

* The "MD6_CF_PAR_MODE" folder – a folder containing a hardware implementation of the MD6 algorithm in parallel operation mode with two compression functions.

* The "MD6_Operating_Modes" folder – a folder containing the planning of the algorithm's operating modes.

* The "MD6_CF_software" folder – a folder containing the software implementation of the MD6 algorithm with one compression function.

* The "Executable_files" folder – a folder containing the executable files for the hardware implementation, hardware design verification activation on the development kit and hardware design verification on the ModelSim simulation.

# Implementation of the algorithm on the board:  

**Part 1: Board Setup**  

		1.  Connect the board to the computer using a USB cable.  
		2.  Open Vivado and create a new RTL project.  
		3.  Under 'Add Sources', include all the source codes (.v, .mem, .vh) from MD6_CF_hardware/Code files.   
		4.  In 'Add Constraints', add the xdc file from MD6_CF_hardware/XDC file. 
		5.  In 'Default Part', select the required chip: Artix-7, XC7A35T1CPG236C (speed -1).  
		6.  Run Synthesis, Implementation, and generate the Bitstream.  
		7.  Program the device.  

**Part 2: PC Setup**  

		1.  Check the "COM" number connected to the board in the device manager of your computer.  
		2.  Based on the loaded XDC file, press the reset button "BTNU" on the board (top button).  
		3.  Open the "MD6_CF.exe" from Executable_files/MD6_CF_exe/GUI App. 
		4.  Select the message and key type you want to insert.  
		5.  Enter the message - M.  
		6.  Enter the key - K (optional).   
		7.  Choose the length of the hashed message - d.  
		8.  Choose the mode control - L (optional).  
		9.  Choose the number of rounds - r (optional).  
		10. Enter the COM number.  
		11. Check that all the LD0-LD7 lights are on (This means that the data has been arrived). 
		    and LD8 is on (This means that message has been hashed).  
		12. Press the "BTNC" button on the panel (the middle button) for receiving the hashed message.  


# Instructions for running the test vectors:

		1.  Implementation of the algorithm on the board as described above.
		2.  Open the "Test_vector.exe" Executable_files/Test_Vectors_exe/GUI App.
		3.  Enter the COM number of your computer
		4.  Select the number of test vectors you want to run
		5.  When "reset" instruction appears on the screen, press the reset button BTNU and press the "Enter" shown on the screen
		6.  Check that all the LD0-LD7 lights are on (This means that the data has been arrived) 
		    and LD8 is on (This means that message has been hashed).
		7.  Press the "BTNC" button on the panel (the middle button) for receiving the hashed message
		8.  If you selected more than single test vector, repeat instructions 5-7 for as many selection
		    vectors as you selected
		9.  After finishing running the program, an csv file will be created which contains the
	 	    comparsion results b/w the HW and SW implementations. 

# Python Libraries

The libraries required to run the algorithm by a Python file as follows (Not relevant for the GUI files since they are included automatically):

**For MD6_CF**  

		1. serial
		2. binascii
		3. tkinter

**For Test_vector**  

		1. serial
		2. random
		3. secrets
		4. string
		5. pandas
		
	
