# About

This archive contains the artifact for the paper Evaluating High-Level SystemC Formal Verification Compared to RTL Verification. 
It contains the following:

*******
## Content 
 1. [Organization](#org)
 2. [Replication Paper's Experiments](#replic)
 3. [Installation](#install)

*******

<div id='org'/>  

# GitHub Organization


The files are organized under the `src` directory, with each subdirectory serving a specific purpose related to the thesis work:

- **src/examples/**: Contains the SystemC files that were used as examples throughout the thesis.
- **src/pvl_convert/**: Includes scripts and resources for reproducing the conversion of SystemC code to PVL.
- **src/verif_vercors/**: Stores the final PVL codes that were subjected to formal verification using VerCors, High Level verification.
- **src/sv_convert/**: Contains the SystemC files prepared for conversion using the ICSC converter.
- **src/verif_sby/**: Directory dedicated to the formal verification process at the low level (LL), using the SBY tool.



<div id='replic'/>  

# Replication Paper's Experiments

In this section will be explained the steps to reproduce the verification of the robot design.

## SystemC Verification: Converter to PVL

- Open the *src/plv_convert* folder
- Execute the makefiles commands.

      make robot

## SystemC Verification: HL tool

- Open the *src/verif_vercors* folder
- Execute the VerCors command, for the robot with assertions: 

      vercors --silicon robot/robot_assert.pvl

- For visualize the progress information can be use the follow command:

      vercors --silicon --progress robot/robot_assert.pvl

## SystemC to SV conversion

- Open the ICSC installation path and define, where /home/username/project is the ICSC home folder
        
      export ICSC_HOME=/home/username/project

- Open the *CMakeLists.txt* file, at the end of the file add a new line:

      add_subdirectory(designs/robot)

- Copy the *src/sv_convert/robot* folder to the folder *$ICSC_HOME/designs* 
- On the terminal execute the follow commands:

      cd $ICSC_HOME
      source setenv.sh
    
      cd build   
      cmake ../ 
      ctest -R robot  

- (Optional) For debug:

      ctest -R robot --rerun-failed --output-on-failure 

- On the folder *$ICSC_HOME/build/designs/robot* is the SV file obtained. Note that the SV files obtained are already on the *src/sv_convert* folder


## SV Verification: LL Verification

- Open the folder *src/verif_sby*

- Execute the comman, for the robot with assertions:

      sby -f robot/FPV_assert.sby

- (Optional) When the SBY reproduce prover error, this error can be visualize and possible debug it with the follow command:

	  gtkwave robot/FPV_prv/engine_0/trace.vcd


<div id='install'/>  

# Installation

This section explains all the procedures for installing the tools used. 
For the SystemC standards and implementation all the information is available [here](https://systemc.org/resources/standards/).

## WSL
The steps for the installation are the follow, more information can be found on the official website [here](https://learn.microsoft.com/en-us/windows/wsl/install). 


- Open the Windows Command Prompt as administrator and enter the command 
  
      wsl --install

- Install Debian Distribution with the command 

      wsl --install -d Debian 

## VerCors
The official VerCors website can be found [here](https://vercors.ewi.utwente.nl/).
The steps are the follow:


- Open the Debian Terminal
- Install the requires pre-installation, namely Java (=>17) and Clang

      sudo apt install clang openjdk-17-jre

- Download the 1.4.1 VerCors version from the GitHub from [here](https://github.com/utwente-fmt/vercors/releases/tag/v1.4.1). File named *Vercors_1.4.1_all.deb*. 
- Then install the VerCors

      sudo dpkg -i Vercors_1.4.1_all.deb
      
- (Optional) To run the VerCors tool, go to a file with PVL and execute the command

      vercors --silicon *.pvl

## ICSC
Intel® Compiler for SystemC* (ICSC) translates synthesizable SystemC design into equvivalent SystemVerilog code. The official website can be found [here](https://github.com/intel/systemc-compiler).


- Open the Debian Terminal and install the requires prr-installation, Git, C++ (=>17) and CMake (=>3.13)
- Define ICSC folder, where /home/username/project is the ICSC home folder

      export ICSC_HOME=/home/username/project

- Install [Protobuf](https://github.com/protocolbuffers/protobuf/releases) (=>3.6.1) and [LLVM/Clang](https://releases.llvm.org/download.html#12.0.1) 12.0.1. on the ICSC folder
- Clone ICSC repository 

      git clone https://github.com/intel/systemc-compiler $ICSC_HOME/icsc

- On the terminal enter the ISCS folder installation: 

      cd $ICSC_HOME

- Download and install all required components 

      icsc/install.sh

- On the terminal enter the ISCS folder and setup *PATH* and *LD_LIBRARY_PATH* with the command

      source setenv.sh

- Build and install ICSC

      cd $ICSC_HOME/icsc
      mkdir build && cd build
      cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ICSC_HOME
      make -j8
      make install

- (Optional) Generate SV code for the available examples (counter is the design example): 

      cd $ICSC_HOME
      source setenv.sh
      cd build
      cmake ../
      ctest -R counter

## SBY
The SBY also known as SymbiYosys have its oficial website [here](https://yosyshq.readthedocs.io/projects/sby/en/latest/install.html). 
The installations steps are the follow:


- Open the Debian Terminal and install the requires pre-installation

      sudo apt-get install build-essential clang bison flex
      sudo apt-get install libreadline-dev gawk tcl-dev libffi-dev git
      sudo apt-get install graphviz xdot pkg-config python3 zlib1g-dev
      python3 -m pip install click
    
- Install [Yosys](https://yosyshq.net/yosys/)

      git clone https://github.com/YosysHQ/yosys
      cd yosys
      make -j$(nproc)
      sudo make install
    
- Install Boolector 

      git clone https://github.com/boolector/boolector
      cd boolector
      ./contrib/setup-lingeling.sh
      ./contrib/setup-btor2tools.sh
      ./configure.sh
      make -C build -j$(nproc)
      sudo cp build/bin/{boolector,btor*} /usr/local/bin/
      sudo cp deps/btor2tools/bin/btorsim /usr/local/bin/
    
- Install Z3 builder 

      git clone https://github.com/Z3Prover/z3.git
      cd z3
      python scripts/mk_make.py
      cd build
      make
      sudo make install
    
- Install SBY 

      git clone https://github.com/YosysHQ/sby
      cd sby
      sudo make install
    
- (Optional) Install GTKWave 

      sudo apt install gtkwave

- (Optional) On the SBY website you can find the [FIFO example](https://yosyshq.readthedocs.io/projects/sby/en/latest/quickstart.html) and the example can be reproduce. 