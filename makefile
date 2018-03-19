
######################################INCLUDES#################################

#######################################VARS####################################
GENERIC=generic
SRCS=$(wildcard *.cpp)
LD_FLAGS=-Wl,--start-group -lclangAST -lclangAnalysis -lclangBasic\
-lclangDriver -lclangEdit -lclangFrontend -lclangFrontendTool\
-lclangLex -lclangParse -lclangSema -lclangEdit -lclangASTMatchers\
-lclangRewrite -lclangRewriteFrontend -lclangStaticAnalyzerFrontend\
-lclangStaticAnalyzerCheckers -lclangStaticAnalyzerCore\
-lclangSerialization -lclangToolingCore -lclangTooling -lstdc++ -lLLVMRuntimeDyld -lm -Wl,--end-group
LD_FLAGS+=$(shell $(LLVM_CONF) --ldflags --libs --system-libs)
CXX=clang++
CXX?=clang++
CC?=clang
LLVM_CONF?=llvm-config
SHELL:=/bin/bash
MAKEFLAGS+=--warn-undefined-variables
EXTRA_CXX_FALGS=-I$(shell $(LLVM_CONF) --src-root)/tools/clang/include -I$(shell $(LLVM_CONF) --obj-root)/tools/clang/include\
 -std=c++1z -stdlib=libstdc++ -UNDEBUG -fexceptions


CXX_FLAGS=$(shell $(LLVM_CONF) --cxxflags)
CC_FLAGS=
EXTRA_CC_FLAGS=

CXX_FLAGS+=$(EXTRA_CXX_FALGS)
LD_FLAGS+=$(EXTRA_LD_FLAGS)
CC_FLAGS+=$(EXTRA_CC_FLAGS)
######################################RULES####################################
.DEFAULT: all

.PHONY: all clean help depend

all: $(GENERIC)

depend: .depend

.depend:$(SRCS)
	rm -f ./.depend
	$(CXX) -MM $(CXX_FLAGS) $^ > ./.depend

-include ./.depend

.cpp.o:
	$(CXX) -v $(CXX_FLAGS) -c $< -o $@

$(GENERIC): $(GENERIC).o
	$(CXX) -v $^ $(LD_FLAGS) -o $@

clean:
	rm -f *.o *~ $(GENERIC)
	rm ./.depend

help:
	@echo 'All is the defualt target.'
	@echo 'Clean runs clean.'
