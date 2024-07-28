# How to Use

## Converter to PVL

Manually: 
Go to folder src/pvl_convert/ (ex. Robot)

    java -jar sc2ast.jar -f  ./examples/simple_robot/main.cpp -o ./examples/simple_robot/main_ast
    java -jar sc2pvl.jar -i ./examples/simple_robot/main_ast.ast.xml -o ./results/simple_robot/ -tr 1

Automaticlly:

    make robot

To test:
Go to the folder were pvl is and

    vercors --silicon *.pvl

## Vercors

Go to the folder src/verif_vercors and choose a desing folder

    vercors-1 --silicon *.pvl

For progress display plus run time:

    vercors-1 --silicon --progress *.pvl



## ICSC

Go to folder of installation (/home/renato/project)
Change CMakeLists.txt file
    add_subdirectory(designs/DUT)     # DUT == name design

Go to folder: /home/renato/project/designs
Add folder Design's name (follow template as example)
Add to the folder DUT.h + main.cpp + CMakeLists.txt as template example
Edit CMakeLists.txt file, change DUT.h and main.cpp if need

    export ICSC_HOME=/home/renato/project
    cd $ICSC_HOME
    source setenv.sh                   # setup PATH and LD_LIBRARY_PATH
    
    cd build   
    cmake ../                          # prepare Makefiles in Release mode
    ctest -R counter  

For debug:

    ctest -R counter --rerun-failed --output-on-failure 

Result inside folder:  $ICSC_HOME/build/designs


## SBY
Or SymbiYosys.
The oficial website is [this](https://yosyshq.readthedocs.io/projects/sby/en/latest/install.html). 

Go to the folder src/verif_sby

Run the fifo example: (docs/examples/fifo)

    sby -f fifo.sby

Go to test_ll/Makefile to see examples

