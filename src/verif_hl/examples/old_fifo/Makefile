UNIT = prod_cons

OBJS = $(UNIT).o 
TARGET = $(UNIT)

# installation path
STATE_HOME = ../..
SC2AST = $(STATE_HOME)/sc2ast.jar
SC2UPPAAL = $(STATE_HOME)/sc2uppaal.jar

CXX = g++
CC = gcc

ARCH ?= $(shell uname -m)
ifeq ($(ARCH),x86_64)
LIBDIR = $(SYSTEMC_HOME)/lib-linux64
else
LIBDIR = $(SYSTEMC_HOME)/lib-linux
endif

RPATH = -Wl,-rpath=$(LIBDIR)
INCDIR = -I$(SYSTEMC_HOME)/include -I$(SYSTEMC_HOME)/include/tlm_core
LIBS =  -lsystemc -lm $(EXTRA_LIBS)

all: $(TARGET)

$(TARGET): $(OBJS)
	 $(CXX) $(INCDIR) -L $(LIBDIR) $(RPATH) -o $@ $(OBJS) $(LIBS)

$(UNIT).o: $(UNIT).cpp 
	 $(CXX) $(INCDIR) -g -c -Wno-deprecated $< -o $@

ast:
	java -jar $(SC2AST) -f  $(UNIT).cpp -o $(UNIT)

uppaal:
	java -jar $(SC2AST) -f  $(UNIT).cpp -o $(UNIT)
	java -jar $(SC2UPPAAL) -i $(UNIT).ast.xml -o $(UNIT).uppaal.xml

clean:
	rm -f $(OBJS) $(TARGET) *~
