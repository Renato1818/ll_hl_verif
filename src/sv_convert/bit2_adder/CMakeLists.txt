#******************************************************************************
# Copyright (c) 2020, Intel Corporation. All rights reserved.
# 
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception.
# 
# *****************************************************************************

cmake_minimum_required(VERSION 3.12)

enable_testing()

if(NOT DEFINED ENV{ICSC_HOME})
  message("ICSC_HOME is not defined!")
  return()
endif()

# Design template
project(bit2_adder)

## SVC package contains ScTool and SystemC libraries
find_package(SVC REQUIRED)

# C++ standard must be the same as in ScTool, $(SystemC_CXX_STANDARD) contains 17
set(CMAKE_CXX_STANDARD 17)

#include_directories($ENV{ICSC_HOME}/include)

# All synthesizable source files must be listed here (not in libraries)
add_executable(bit2_adder main.cpp)

# Add compilation options
# target_compile_definitions(bit2_adder PUBLIC -DMYOPTION)
# target_compile_options(bit2_adder PUBLIC -Wall)

# Add optional library, do not add SystemC library (it added by svc_target)
#target_link_libraries(bit2_adder sometestbenchlibrary)

# svc_target will create @full_adder_sctool executable that runs code generation 
# and @full_adder that runs general SystemC simulation
# ELAB_TOP parameter accepts hierarchical name of DUT  
# (that is SystemC name, returned by sc_object::name() method)
svc_target(bit2_adder INIT_LOCAL_VARS ELAB_TOP tb.dut_inst)
