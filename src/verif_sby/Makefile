
#export ROOT=$PWD/quickstart

new_all: fifo robot

fifo: 	
	sudo sby -f fifo_test/FPV.sby 

robot: 	
	sudo sby -f robot/FPV.sby 

wave_robot:
	gtkwave robot/FPV_prv/engine_0/trace.vcd noskip.gtkw


alu: 	
	sby -f alu/FPV.sby 

half_adder:
	sby -f half_adder/FPV.sby

wave_alu:
	gtkwave alu/FPV_prv/engine_0/trace.vcd

#new_all_clean: clean_todo 

#clean_todo:
#	rm -f ./examples/ABSASR/*.xml
#	rm -f ./examples/ABSASR/main_ast
#	rm -rf ./results/ABSASR

	
	
	
	


