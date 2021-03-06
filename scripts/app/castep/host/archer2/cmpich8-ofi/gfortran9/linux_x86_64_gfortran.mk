#
# gfortran under linux.
#
LINUX = true
#
# ID for "compare_module.pl script
#
COMPILER=GNU-gfortran-on-LINUX
#
ifeq ($(COMMS_ARCH),mpi)
CC   := gcc
F90  := gfortran
#
# Choose compiler for openmpi, mpich, intel and platform MPI
#
export OMPI_FC   ?= gfortran
export MPICH_F90 ?= gfortran
export I_MPI_F90 ?= gfortran
export MPI_F90   ?= gfortran
else
F90 ?= gfortran
endif
#
# Flag to specify module path search directory
#
MODULE_PREFIX=-I
#
#  Extension for object files  ".o" for unix
#
OBJ_EXTN = o
#
# General flags
#
FFLAGS_E = -fconvert=big-endian -fno-realloc-lhs -fopenmp -fPIC
#
# Optimiser, performance and debugging flags
#
ifeq ($(BUILD),debug)
OPT = -Ddebug -O0 -g -fbounds-check -fbacktrace -Wall -Waliasing -Wsurprising -Wline-truncation -Wno-tabs -Wno-uninitialized -Wno-unused-dummy-argument -Wno-unused -Wno-character-truncation
else ifeq ($(BUILD),coverage)
OPT = -O1 -g -fbacktrace --coverage
else ifeq ($(BUILD),intermediate)
OPT = -Og -g -fbacktrace
else
OPT = -O3 -funroll-loops -fno-signed-zeros -g -fbacktrace

ifeq ($(TARGETCPU),portable)
OPT_CPU = -mavx
else
OPT_CPU = -march=native
endif

endif

MPI_ROOT = /opt/cray/pe/mpich/8.0.16/ofi/gnu/9.1
MPI_INC = -I$(MPI_ROOT)/include
MPI_LIBS = -L$(MPI_ROOT)/lib -lmpi -lmpifort

#
# Don't change this line
#
FFLAGS = $(FFLAGS_E) $(OPT) $(OPT_CPU) $(DEFS) $(INC) $(MPI_INC)

#
# Libraries
#
ifeq ($(MATHLIBS),default)
override MATHLIBS=generic
endif
#
# Intel MKL - static link
#
ifeq ($(MATHLIBS),mkl)
MATH_LIBS =  -Wl,--start-group -lmkl_gf_lp64 -lmkl_sequential -lmkl_core  -Wl,--end-group
DYNAMIC_LIBS = -lpthread -ldl
endif
#
# AMD ACML
#
ifeq ($(MATHLIBS),acml)
MATH_LIBS = -lacml
DYNAMIC_LIBS = -lrt
endif
#
# OpenBLAS (descendent of Kashushige Goto's fast assembler BLAS)
#
ifeq ($(MATHLIBS),openblas)
MATH_LIBS = -lopenblas
endif
#
# ATLAS BLAS
#
ifeq ($(MATHLIBS),atlas)
#  Link with the ATLAS blas and LAPACK routines.
MATH_LIBS = -llapack -lf77blas -lcblas -latlas
endif
#
# SciLib BLAS
#
ifeq ($(MATHLIBS),scilib)
MATH_LIBS = -lsci_gnu -lsci_gnu_mpi_mp
endif
#
# Generic Fortran BLAS
#
ifeq ($(MATHLIBS),generic)
MATH_LIBS = -llapack -lblas 
endif

#
# FFT libs
#
ifeq ($(FFT),default)
override FFT = generic
endif
ifeq ($(FFT),fftw)
FFT_LIBS = -lfftw
endif
ifeq ($(FFT),fftw3)
FFT_LIBS = -lfftw3
endif
#
# Any additional libraries required. 
#
EXTRA_LIBS := -lsymspg 
#
# Optional libXC flags
#
ifneq ($(LIBXC),none)
EXTRA_LIBS := -lxcf90 -lxc $(EXTRA_LIBS)
endif
#
# Optional DL_MG flags
#
ifneq ($(DL_MG),none)
EXTRA_LIBS := -ldlmg $(EXTRA_LIBS)
endif
#
# Link-time options. Add any additional library search directories here.
#
LD_FLAGS = -static-libgfortran $(OPT) -fopenmp
## Total libraries -- should not need to change this.
# CASTEP_LIBS should be set up by specific makefiles.
#
ifeq ($(LINKMODE),static)
LIBS = $(CASTEP_LIBS) -Wl,-Bstatic $(MPI_LIBS) $(FFT_LIBS) $(MATH_LIBS) $(COMMS_LIB) $(EXTRA_LIBS) -Wl,-Bdynamic $(DYNAMIC_LIBS)
else
LIBS = $(CASTEP_LIBS) $(MPI_LIBS) $(FFT_LIBS) $(MATH_LIBS) $(COMMS_LIB) $(EXTRA_LIBS) $(DYNAMIC_LIBS)
endif
#
# Code Coverage
#
GENERATE_COVERAGE := lcov --directory . --capture --output-file castep.info && genhtml --ignore-errors source -o Coverage castep.info
