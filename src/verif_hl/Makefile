JAVA = java # set the path to your java>16 installation
JAVA = /usr/lib/jvm/java-17-openjdk-amd64/bin/java

ast:
	$(JAVA) -jar sc2ast.jar -f  ./examples/simple_fifo/prod_cons.cpp -o ./examples/simple_fifo/main_ast
	$(JAVA) -jar sc2ast.jar -f  ./examples/simple_robot/main.cpp -o ./examples/simple_robot/main_ast
	$(JAVA) -jar sc2ast.jar -f  ./examples/ABSASR/ABS_tb.cpp -o ./examples/ABSASR/main_ast



fifo: 	ast
	if ! test -d ./results/simple_fifo/; \
	then mkdir -p ./results/simple_fifo/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/simple_fifo/main_ast.ast.xml -o ./results/simple_fifo/ -tr 1


robot: 	ast
	if ! test -d ./results/simple_robot/; \
	then mkdir -p ./results/simple_robot/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/simple_robot/main_ast.ast.xml -o ./results/simple_robot/ -tr 1000000
	
absasr: ast
	if ! test -d ./results/ABSASR/; \
	then mkdir -p ./results/ABSASR/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/ABSASR/main_ast.ast.xml -o ./results/ABSASR/ -tr 1

all: fifo robot absasr

clean:
	rm -f ./examples/simple_fifo/*.xml
	rm -f ./examples/simple_fifo/main_ast
	rm -rf ./results/simple_fifo
	rm -f ./examples/simple_robot/*.xml
	rm -f ./examples/simple_robot/main_ast
	rm -rf ./results/simple_robot
	rm -f ./examples/ABSASR/*.xml
	rm -f ./examples/ABSASR/main_ast
	rm -rf ./results/ABSASR

######### NEW ###############


new_all: fifo robot absasr des nand


alu: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/alu/main_tb.cpp -o ./examples/alu/main_ast
	if ! test -d ./results/alu/; \
	then mkdir -p ./results/alu/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/alu/main_ast.ast.xml -o ./results/alu/ 


nand: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/nand/nand.cc -o ./examples/nand/main_ast
	if ! test -d ./results/nand/; \
	then mkdir -p ./results/nand/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/nand/main_ast.ast.xml -o ./results/nand/ 


des: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/des/main.cpp -o ./examples/des/main_ast
	if ! test -d ./results/des/; \
	then mkdir -p ./results/des/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/des/main_ast.ast.xml -o ./results/des/ -tr 1000


old_fifo: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/old_fifo/prod_cons.cpp -o ./examples/old_fifo/main_ast
	if ! test -d ./results/old_fifo/; \
	then mkdir -p ./results/old_fifo/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/old_fifo/main_ast.ast.xml -o ./results/old_fifo/ -tr 1
	
arith_oper: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/arithmetic_oper/complex1.cpp -o ./examples/arithmetic_oper/main_ast
	if ! test -d ./results/arithmetic_oper/; \
	then mkdir -p ./results/arithmetic_oper/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/arithmetic_oper/main_ast.ast.xml -o ./results/arithmetic_oper/ -tr 1

ppd: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/ppd/ppd_tb.cpp -o ./examples/ppd/main_ast
	if ! test -d ./results/ppd/; \
	then mkdir -p ./results/ppd/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/ppd/main_ast.ast.xml -o ./results/ppd/ -tr 1


half_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/half_adder/main_tb.cpp -o ./examples/half_adder/main_ast
	if ! test -d ./results/half_adder/; \
	then mkdir -p ./results/half_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/half_adder/main_ast.ast.xml -o ./results/half_adder/ 

md5: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/md5/md5_tb.cpp -o ./examples/md5/main_ast
	if ! test -d ./results/md5/; \
	then mkdir -p ./results/md5/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/md5/main_ast.ast.xml -o ./results/md5/ -tr 1

rng: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/rng/main_tb.cpp -o ./examples/rng/main_ast
	if ! test -d ./results/rng/; \
	then mkdir -p ./results/rng/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/rng/main_ast.ast.xml -o ./results/rng/ 
	
full_adder: 	
	$(JAVA) -jar sc2ast.jar -f  ./examples/full_adder/main_tb.cpp -o ./examples/full_adder/main_ast
	if ! test -d ./results/full_adder/; \
	then mkdir -p ./results/full_adder/; \
	fi
	$(JAVA) -jar sc2pvl.jar -i ./examples/full_adder/main_ast.ast.xml -o ./results/full_adder/ 


new_all_clean: clean-absasr clean-alu clean-des clean-nand clean-fifo clean-robot clean-arith_oper clean-ppd clean-half_adder clean-md5 clean-rng clean-full_adder_adder

clean-absasr:
	rm -f ./examples/ABSASR/*.xml
	rm -f ./examples/ABSASR/main_ast
	rm -rf ./results/ABSASR

clean-alu:
	rm -f ./examples/alu/*.xml
	rm -f ./examples/alu/main_ast
	rm -rf ./results/alu

clean-des:
	rm -f ./examples/des/*.xml
	rm -f ./examples/des/main_ast
	rm -rf ./results/des

clean-nand:
	rm -f ./examples/nand/*.xml
	rm -f ./examples/nand/main_ast
	rm -rf ./results/nand

clean-fifo:
	rm -f ./examples/simple_fifo/*.xml
	rm -f ./examples/simple_fifo/main_ast
	rm -rf ./results/simple_fifo

clean-robot:
	rm -f ./examples/simple_robot/*.xml
	rm -f ./examples/simple_robot/main_ast
	rm -rf ./results/simple_robot
	
clean-arith_oper:
	rm -f ./examples/arithmetic_oper/*.xml
	rm -f ./examples/arithmetic_oper/main_ast
	rm -rf ./results/arithmetic_oper

clean-ppd:
	rm -f ./examples/ppd/*.xml
	rm -f ./examples/ppd/main_ast
	rm -rf ./results/ppd

clean-half_adder:
	rm -f ./examples/half_adder/*.xml
	rm -f ./examples/half_adder/main_ast
	rm -rf ./results/half_adder

clean-md5:
	rm -f ./examples/md5/*.xml
	rm -f ./examples/md5/main_ast
	rm -rf ./results/md5

clean-rng:
	rm -f ./examples/rng/*.xml
	rm -f ./examples/rng/main_ast
	rm -rf ./results/rng

clean-full_adder_adder:
	rm -f ./examples/full_adder/*.xml
	rm -f ./examples/full_adder/main_ast
	rm -rf ./results/full_adder


	
	
	


