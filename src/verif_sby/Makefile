
#export ROOT=$PWD/quickstart

new_all: robot alu half_adder full_adder


robot: 	
	sby -f robot/FPV.sby 

alu: 	
	sby -f alu/FPV.sby 

half_adder:
	sby -f half_adder/FPV.sby

full_adder:
	sby -f full_adder/FPV.sby

#Example for debbug
#Need gtwave install
wave_alu:
	gtkwave alu/FPV_prv/engine_0/trace.vcd



	
	
	
	


