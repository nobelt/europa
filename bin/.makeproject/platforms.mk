UNAME := $(shell uname)
OPT_FLAGS = -O3 -DEUROPA_FAST  -fno-strict-aliasing
LD_FLAGS = -O3  -fno-strict-aliasing

ifeq (1,$(FAST))
  BUILD_SUFFIX := _o
  CXXFLAGS += $(OPT_FLAGS)
  LDFLAGS += $(LD_FLAGS)
else
  ifeq (1,$(PROFILE))
    BUILD_SUFFIX := _o_p
    CXXFLAGS += -pg $(OPT_FLAGS)
    LDFLAGS += -pg $(LD_FLAGS)
  else
    BUILD_SUFFIX := _g
    CXXFLAGS += -ggdb3
  endif
endif

ifdef ANT_HOME
  ANT := $(ANT_HOME)/bin/ant
else
  ANT := ant
endif
SWIG := swig
RM := rm -rf
MV := mv
MKDIR := mkdir -p
CXX := g++
ifdef JAVA_HOME
  JAVA := $(JAVA_HOME)/bin/java
else
  JAVA := java
endif


RT_SUFFIX := _rt
LIB_PREFIX := lib
SHARED_LINK_FLAG := -shared
POSITION_INDEPENDENT_FLAG := -fPIC
DL_LIBRARY := -ldl
ANTLR_LIBRARY := -lantlr3c
PLATFORM_LIBS := 

ifneq (,$(findstring Linux,$(UNAME)))
  LINUX := 1
  LIB_EXT := so
  ifdef JAVA_HOME
    CXXFLAGS += -I"$(JAVA_HOME)/include"
    CXXFLAGS += -I"$(JAVA_HOME)/include/linux"
  endif
endif

ifneq (,$(findstring Darwin,$(UNAME)))
  DARWIN := 1
  LIB_EXT := dylib
  SHARED_LINK_FLAG := -dynamiclib
  ifdef $(JAVA_HOME)
    CXXFLAGS += -I"$(JAVA_HOME)/include"
  endif  
  CXXFLAGS += -I"/System/Library/Frameworks/JavaVM.framework/Headers"
  CXXFLAGS += -m64
  LDFLAGS += -m64
endif

ifneq (,$(findstring Solaris,$(UNAME)))
  SOLARIS := 1
  LIB_EXT := so
  ifdef $(JAVA_HOME)
    CXXFLAGS += -I"$(JAVA_HOME)/include"
  endif
endif

CXXFLAGS += $(POSITION_INDEPENDENT_FLAG) $(LOGGER_TYPE) -I$(EUROPA_HOME)/include/PLASMA -I$(EUROPA_HOME)/include/
LDFLAGS += $(POSITION_INDEPENDENT_FLAG) -L$(EUROPA_HOME)/lib
LOADLIBS += -lSystem$(BUILD_SUFFIX) \
            -lResource$(BUILD_SUFFIX) \
            -lNDDL$(BUILD_SUFFIX) \
            -lSolvers$(BUILD_SUFFIX) \
            -lRulesEngine$(BUILD_SUFFIX) \
            -lTemporalNetwork$(BUILD_SUFFIX) \
            -lPlanDatabase$(BUILD_SUFFIX) \
            -lConstraintEngine$(BUILD_SUFFIX) \
            -lUtils$(BUILD_SUFFIX) \
            -lTinyXml$(BUILD_SUFFIX) \
            $(DL_LIBRARY) \
            $(ANTLR_LIBRARY) \
	    $(PLATFORM_LIBS) 

vpath %.dylib $(EUROPA_HOME)/lib

