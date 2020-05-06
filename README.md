# Build-Your-Own
All necessary data to build the project and test it on your own FPGA
 

# STEPS FOR BUILDING

# STEP 1: Download necessary files
Download GITHUB REPO & extract into desired location

# STEP 2: Adding Enviroment Variables
Open Powershell
<br /> Run: $env:PATH = $env:PATH + ";C:\Xilinx\Vivado\2019.2\bin"
<br /> Run: echo $env:PATH
<br /> Ensure that Vivado is listed inside enviroment path

# STEP 3: Building Vivado Project
In Powershell change directory to where the GITHUB files were extracted
<br /> Run: cd FPGA
<br /> Run: vivado -mode tcl
<br /> Run: source top.tcl

# STEP 4: Testing Vivado Project
<br /> Open up the Vivado Project in folder dccn_proj
<br /> Can run final_test.vhd for simulated results
<br /> Can build bitstream to test on hardware
