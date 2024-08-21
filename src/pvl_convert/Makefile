JAVA = java # set the path to your java>16 installation
JAVA = /usr/lib/jvm/java-17-openjdk-amd64/bin/java

robot: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/robot/main.cpp -o ./examples/robot/main_ast
	if ! test -d ./results/robot/; \
	then mkdir -p ./results/robot/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/robot/main_ast.ast.xml -o ./results/robot/ 

half_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/half_adder/main.cpp -o ./examples/half_adder/main_ast
	if ! test -d ./results/half_adder/; \
	then mkdir -p ./results/half_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/half_adder/main_ast.ast.xml -o ./results/half_adder/ 

full_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/full_adder/main.cpp -o ./examples/full_adder/main_ast
	if ! test -d ./results/full_adder/; \
	then mkdir -p ./results/full_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/full_adder/main_ast.ast.xml -o ./results/full_adder/ 

bit2_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/bit2_adder/main.cpp -o ./examples/bit2_adder/main_ast
	if ! test -d ./results/bit2_adder/; \
	then mkdir -p ./results/bit2_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/bit2_adder/main_ast.ast.xml -o ./results/bit2_adder/ 

bit4_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/bit4_adder/main.cpp -o ./examples/bit4_adder/main_ast
	if ! test -d ./results/bit4_adder/; \
	then mkdir -p ./results/bit4_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/bit4_adder/main_ast.ast.xml -o ./results/bit4_adder/ 

bit8_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/bit8_adder/main.cpp -o ./examples/bit8_adder/main_ast
	if ! test -d ./results/bit8_adder/; \
	then mkdir -p ./results/bit8_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/bit8_adder/main_ast.ast.xml -o ./results/bit8_adder/ 

alu: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/alu/main.cpp -o ./examples/alu/main_ast
	if ! test -d ./results/alu/; \
	then mkdir -p ./results/alu/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/alu/main_ast.ast.xml -o ./results/alu/ 


all: robot half_adder full_adder bit2_adder bit4_adder bit8_adder alu


clean_robot:
	rm -f ./examples/robot/*.xml
	rm -f ./examples/robot/main_ast
	rm -rf ./results/robot


clean_half_adder:
	rm -f ./examples/half_adder/*.xml
	rm -f ./examples/half_adder/main_ast
	rm -rf ./results/half_adder

clean_full_adder:
	rm -f ./examples/full_adder/*.xml
	rm -f ./examples/full_adder/main_ast
	rm -rf ./results/full_adder

clean_bit2_adder:
	rm -f ./examples/bit2_adder/*.xml
	rm -f ./examples/bit2_adder/main_ast
	rm -rf ./results/bit2_adder

clean_bit4_adder:
	rm -f ./examples/bit4_adder/*.xml
	rm -f ./examples/bit4_adder/main_ast
	rm -rf ./results/bit4_adder

clean_bit8_adder:
	rm -f ./examples/bit8_adder/*.xml
	rm -f ./examples/bit8_adder/main_ast
	rm -rf ./results/bit8_adder
	
clean_alu:
	rm -f ./examples/alu/*.xml
	rm -f ./examples/alu/main_ast
	rm -rf ./results/alu

all_clean: clean_robot clean_half_adder clean_full_adder clean_bit2_adder clean_bit4_adder clean_bit8_adder clean_alu
	
	
	


