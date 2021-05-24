#-*- mode: makefile; mode: font-lock; vc-back-end: mercurial -*-
#=================================================================#
# Top level Makefile 
#=================================================================#
# $Id$
#-----------------------------------------------------------------#
#
# This build system requires GNU make version 3.82 or later (3.81
# works but does fully support varying compiler options on a per-file basis,
# and will create an under-optimised build for some builds).
#
# Usage: Main targets are
#
#  make castep      : build just castep executable in obj/$(ARCH)/castep
#  make tools       : build analysis and interpretation tools in obj/$(ARCH)
#  make             : default target builds BOTH castep and tools in serial, just
#                     castep in mpi mode.
#  make install     : install compiled CASTEP into bin/$ARCH directory.
#  make install-tools :                tools
#  make clean       : delete executables and object files in preparation for rebuild from scratch
#  make check-quick : run quicker subset of test suite
#  make check       : run full version of test suite
#  make test        : compile unit test suite (for developers only)
#  make dist        : assemble a tarball CASTEP.tar.gz from the current source tree.
#
# The following hairy GNU make stuff defines macros ${\n} and ${ } for a newline and a space which we will use for error 
# message formatting. See http://www.cmcrossroads.com/ask-mr-make/8442-gnu-make-escaping-a-walk-on-the-wild-side
#
define \n


endef
space := \\ 
${space} := ${space}# ${ } is a space. Neat huh?
#
#  Automatically detect which platform we are compiling on
#
ifeq ($(origin CASTEP_ARCH),environment)
  ARCH := $(CASTEP_ARCH)
else ifeq ($(origin F90),environment)
  ARCH := $(shell bin/arch -c $(F90))
else ifeq ($(origin F90),command line)
  ARCH := $(shell bin/arch -c $(F90))
else
  ARCH := $(shell bin/arch)
endif
ifeq ($(findstring Unknown compiler:,$(ARCH)),Unknown compiler:)
$(error ARCH=$(ARCH)$(\n)If this is an MPI wrapper please also specify ARCH explicitly)
endif

###############################################################################
# Customisable variables to select choice of libraries in section below
#     Read the file README.INSTALL for a discussion
###############################################################################
# Sets the communications architecture: Options are serial, mpi

COMMS_ARCH := mpi 

#
# Uncomment to disable System V shared memory /MPI optimizations if FreeIPC.f90/.c fail to compile
#
#NOSYSV := true


# Sets the FFT routines to use : Options generic, vendor, fftw3, default, mkl, acml
# N.B.  If ACML or MKL FFTs are used then MATHLIBS must use the same libraries.

FFT := fftw3
FFTLIBDIR := /opt/cray/pe/fftw/3.3.8.8/x86_rome/lib

# Selects an optimised or debug build : options: debug, intermediate, fast, coverage

BUILD := fast 

# Choose CPU target instruction set: HOST for this processor or PORTABLE

TARGETCPU := host

# Which LAPACK and BLAS to use : Options : "openblas","acml","atlas","cxml","default","essl",
#	"generic","mkl","scilib","scs","scsl","sunperf","vendor"

MATHLIBS := scilib
MATHLIBDIR := /opt/cray/pe/libsci/20.10.1.2/GNU/9.1/x86_64/lib

# Choose whether to use system install of spglib or to build it.
# Valid strings are "compile" or "system"

SPGLIB := compile

# Choose whether to use system install of libxc or to build it.
# Valid strings are "none", "compile" or "system"

LIBXC := none

# Choose whether to use system install of DL_MG or to build it.
# Valid strings are "none", "compile" or "system"

DL_MG := compile

# Sets the XML routines to use: Options are fox, dummy
# ('fox' requires FoX version 3.2 from http://uszla.me.uk/FoX/)

XML := dummy

# Grimme D3 library support. Options are none or compile
GRIMMED3 := none

# Choose static or dynamic linking of libraries (Linux only)
LINKMODE := dynamic 

###############################################################################
# E N D  O F  B U I L D  C U S T O M I Z A T I O N   S E C T I O N
# Shouldn't need to change anything below here
###############################################################################
#
#
# CASTEP's "architecture" string ARCH take the form "OS"_"architecture"_"compiler", for example
#  "linux_ia32_ifort11".  The automatically detected architecture can be overridden by,
#
#   make castep ARCH=linux_x86_64_gfortran
#
# or by setting the shell environment variable CASTEP_ARCH (e.g. export CASTEP_ARCH=linux_ia32_ifort11
# in the BASH shell). This allows building, for example both 32 and 64-bit versions or using multiple
# compilers from the same set of sources. Different subdirectories are created under "obj" so there
# will be no clash. A list of valid architectures may be obtained by
#
#   make ARCH=
#
# and a list of which are available on a particular machine may be obtained by running the command script
#
#   bin/arch -a
#
# Each "architecture" is defined by a file of that name (with a ".mk" suffix) in the "obj/platforms"
# directory, and a new architecture may be created simply by creating the $(NEWARCH).mk file in
# "obj/platforms". That is the place where compiler flags, library names etc are all set and where
# any modifications can be made.  Please send any new architecture files or improvements in
# build flags to dominik.jochym@stfc.ac.uk.
#
# It is sometimes desirable to have more than one object/build tree for a given ARCH, for example to
# test different compiler versions, FFT, MATHLIBS or MPI versions etc. This may be accomplished by
#
#    make ARCH=... SUBARCH=vvv
#
# which creates an separate object tree "obj/${ARCH}--vvv" and "obj/${ARCH}--vvv.mk". 
#
# SPECIFYING LINK PATHS FOR LAPACK, BLAS AND FFT LIBRARIES:
#
# The variables MATHLIBS and FFT are used to customize the libraries used, and these may be 
# set either by editing this file (below) or by specifying, e.g. MATHLIBS=mkl on the Make command line.
# In many cases the build also requires the information on the actual path used, and there are two
# mechanisms to set this.
# 1. On the Make command line - eg MATHLIBS=openblas MATHLIBDIR=/usr/local/lib
# 2. If MATHLIBDIR is not specified, then the Makefile run will prompt for a path
#    which is also saved in a file and used for subsequent builds.
# A similar set of options exists for FFT and FFTLIBDIR
#
# SPECIFYING LINK PATHS FOR THE DL_MG LIBRARY:
#
# By default, CASTEP will build using the version of DL_MG packaged with CASTEP. This is the
# recommended configuration.
#
# If you wish to compile without DL_MG, you can specify DL_MG=none on the Make command line and
# CASTEP will compile with multigrid solver functionality disabled.
#
# If you wish to use a system library, you can specify DL_MG=system on the Make command line. You
# may then either (i) specify DLMGLIBDIR to give the path to your system DL_MG library; or
# (ii) interactively enter the path when prompted by make (as with MATHLIBDIR above). Note that
# the path you give should contain BOTH the DL_MG library (e.g. libdlmg.a) and the module file
# dl_mg.mod (for DL_MG v2.0.x, the default build will place both of these files in the directory
# specified by DLMG_LIBDIR in DL_MG's Makefile).
#
# DEBUGGING:  
#
#   make MAKEDEBUG=1
#
# invokes a debugging mode to print out WHY a particular file is or is not rebuilt.
#
#  
#
#.SILENT:
#
# This master makefile can't be parallel because of interactive prompts on first call
#

.NOTPARALLEL:
.PHONY: all castep test tools utilities install install-tools spec doc clean clean_all distclean version test_arch dist make_prereq check check-simple check-full check-quick buildinfo python python-install ford-doc
#
# Makefile debugging commands - from http://www.ddj.com/development-tools/197003338
#
ifdef MAKEDEBUG
OLD_SHELL := $(SHELL)
SHELL = $(warning Building $@$(if $<, (from $<))$(if $?, ($? newer)))$(OLD_SHELL) 
endif

print-%: ; @echo $* is $($*)
#
# Strip any extraneous trailing spaces.
#
COMMS_ARCH := $(strip $(COMMS_ARCH))
FFT        := $(strip $(FFT))
BUILD      := $(strip $(BUILD))
TARGETCPU  := $(strip $(TARGETCPU))
MATHLIBS   := $(strip $(MATHLIBS))
XML        := $(strip $(XML))
SPGLIB     := $(strip $(SPGLIB))
LIBXC      := $(strip $(LIBXC))
DL_MG      := $(strip $(DL_MG))
#
# Quote any spaces in the current directory pathname 
#
ROOTDIR    := $(subst $(space),\$(space),$(PWD))

BASE_ARCH:=$(ARCH)
SUBARCH:=$(COMMS_ARCH)
ifneq ($(SUBARCH),)
override ARCH:=$(ARCH)--$(SUBARCH)
endif
#

OBJ_DIR := obj/$(ARCH)
CHECK_DIR := Test
INSTALL_DIR ?= $(realpath bin)/$(ARCH)

export ARCH
export CASTEP_ARCH
export SUBARCH
export BUILD
export TARGETCPU
export COMMS_ARCH
export FFT
export MATHLIBS
export ROOTDIR
export INSTALL_DIR
export SPGLIB
export SPGLIB_SOURCE
export LIBXC
export LIBXC_SOURCE
export GRIMMED3
export GRIMMED3_SOURCE
export DL_MG
export DL_MG_SOURCE
export CC
export LINKMODE

export XML
ifeq ($(NOSYSV),true)
export NOSYSV
endif
#
# Default targets. Only build tools in serial. Don't call forcheck on utilities
#
ifeq ($(ARCH),forcheck)
all:	castep tools
else
ifeq ($(COMMS_ARCH),mpi)
all:     castep utilities
install: install-castep install-utilities
else ifeq ($(findstring -XT,$(ARCH)),-XT)
all:     castep
install: install-castep
else ifeq ($(findstring _blrts-,$(ARCH)),_blrts-)
all:     castep
install: install-castep
else
all:     castep tools utilities
install: install-castep install-tools install-utilities
endif
endif
#
# The actual build targets
#
castep: make_prereq buildinfo
	$(MAKE) -C "$(OBJ_DIR)" ARCH=$(ARCH) castep

coverage: make_prereq
	$(MAKE) -C "$(OBJ_DIR)" ARCH=$(ARCH) coverage

check-simple: make_prereq
	$(MAKE) -C "$(CHECK_DIR)" ARCH=$(ARCH) check-simple

check:  make_prereq
	$(MAKE) -C "$(CHECK_DIR)" ARCH=$(ARCH) check-simple

check-full: make_prereq
	$(MAKE) -C "$(CHECK_DIR)" ARCH=$(ARCH) check-full

check-quick: make_prereq
	$(MAKE) -C "$(CHECK_DIR)" ARCH=$(ARCH) check-quick

test:  make_prereq
	$(MAKE) -C "$(OBJ_DIR)" ARCH=$(ARCH) test

tools:  make_prereq buildinfo
	$(MAKE) -C "$(OBJ_DIR)" ARCH=$(ARCH) tools

utilities:  make_prereq
	$(MAKE) -C "Utilities" ARCH=$(ARCH) all

install-castep:
	$(MAKE) -C "$(OBJ_DIR)" ARCH=$(ARCH) install-castep

install-tools:
	$(MAKE) -C "$(OBJ_DIR)" ARCH=$(ARCH) install-tools

install-utilities:
	$(MAKE) -C Utilities ARCH=$(ARCH) install

clean:
	rm -f *~
	-$(MAKE) -C $(OBJ_DIR) ARCH=$(ARCH) clean
	-$(MAKE) -C Utilities  ARCH=$(ARCH) clean
	-$(MAKE) -C Spec clean
	-$(MAKE) -C Doc clean

clean_all : test_arch version clean
	$(MAKE) -C "$(CHECK_DIR)" ARCH=$(ARCH) spotless
	rm -rf $(OBJ_DIR)

spotless distclean: clean
	$(MAKE) -C "$(CHECK_DIR)" ARCH=$(ARCH) spotless
	for file in obj/platforms/*.mk; do  f=$${file///platforms} && f=$${f/%.mk/--*.mk} && $(RM) $$f && f=$${f%.mk} && $(RM) -r $$f && $(RM) -r $${f/obj/bin}; done

spec: 
	$(MAKE) -C Spec

doc:
	$(MAKE) -C Doc
	$(MAKE) -C Utilities doc
#
# Targets to build libxc and spglib libraries
#
LIBSOURCE_ROOT := ../../LibSource
LIBXC_SOURCE   := $(LIBSOURCE_ROOT)/libxc-2.2.0
SPGLIB_SOURCE  := $(LIBSOURCE_ROOT)/spglib-1.13.0
GRIMMED3_SOURCE := $(LIBSOURCE_ROOT)/dftd3-lib-0.9.2/lib
DL_MG_SOURCE   := $(LIBSOURCE_ROOT)/dl_mg-2.0.3
ifeq ( $(filter linux_x86_64_%-XT,$(ARCH)),"")
CROSS_COMPILE  :=
else
CROSS_COMPILE  := --host=x86_64-unknown-linux-gnu
endif
ifneq ($(ARCH),forcheck)
ifeq ($(LIBXC),compile)
$(OBJ_DIR)/libxc.a: $(OBJ_DIR)/libxc/Makefile
	$(MAKE) -C $(OBJ_DIR)/libxc && $(MAKE) -C $(OBJ_DIR)/libxc install-exec install-data
$(OBJ_DIR)/libxc/Makefile:
	cd $(OBJ_DIR)/libxc && ../$(LIBXC_SOURCE)/configure $(CROSS_COMPILE) FC=$(FC) CC=$(CC) CFLAGS=-fPIC --enable-fortran=yes --enable-shared=no --libdir=$(PWD)/$(OBJ_DIR) --bindir=$(PWD)/$(OBJ_DIR) --includedir=$(PWD)/$(OBJ_DIR)
endif
ifeq ($(SPGLIB),compile)
$(OBJ_DIR)/libsymspg.a: $(OBJ_DIR)/spglib/Makefile
	$(MAKE) -C $(OBJ_DIR)/spglib install-exec
$(OBJ_DIR)/spglib/Makefile:
	cd $(OBJ_DIR)/spglib && ../$(SPGLIB_SOURCE)/configure $(CROSS_COMPILE) FC=$(FC) CC=$(CC) CFLAGS="-fPIC" --enable-shared=no --libdir=$(PWD)/$(OBJ_DIR)
endif
ifeq ($(DL_MG),compile)
# Set DLMG_LIB_DIR to local library directory. This is added to the library and
# module search paths), and should contain libdlmg.a and dl_mg.mod. Since the
# build (target castep) is executed by running make within OBJ_DIR, this is a
# path relative to OBJ_DIR. In this top-level Makefile, when DL_MG=compile, the
# path to the DL_MG library directory is thus $(OBJ_DIR)/$(DLMG_LIBDIR)
ifeq ($(origin DLMGLIBDIR),undefined)
export DLMG_LIB_DIR := $(strip dl_mg/lib)
else
$(error DLMGLIBDIR must not be defined when DL_MG=compile)
endif
$(OBJ_DIR)/$(DLMG_LIB_DIR)/libdlmg.a: $(OBJ_DIR)/exists 
	$(MAKE) -C ${OBJ_DIR}/dl_mg -f ../$(DL_MG_SOURCE)/Makefile CASTEP_ROOT=$(ROOTDIR) CASTEP_ARCH=$(ARCH) MG_ROOTDIR=../$(DL_MG_SOURCE) VPATH=../$(DL_MG_SOURCE)/src:$(VPATH) PLATFORM=castep
endif
endif

#
# Targets to prepare distribution tarballs.
#
TAR := $(shell if which gnutar 1>/dev/null 2> /dev/null; then echo gnutar; else echo tar; fi )

CASTEP_VERSION := $(shell awk '/version_number =/ {print $$6}' Source/Utility/license.F90)
ARCHIVE_ROOT := CASTEP-$(CASTEP_VERSION)
SCRIPTS_ROOT := scripts-$(CASTEP_VERSION)

#
# Conditional handling if tar does not have "transform" option.
#
WD := $(shell basename ${PWD})
TAR_HAS_XFORM:=$(shell if $(TAR) --transform="s/xx/yy/" -cf /dev/null lib 2> /dev/null; then echo yes; else echo no; fi )
ifeq ($(TAR_HAS_XFORM),yes)
TAR_XFORM := --transform="s@$(WD)/@$(ARCHIVE_ROOT)/@"
TAR_XFORM_SCR := --transform="s@.*/@$(SCRIPTS_ROOT)/@"
else
TARXFORM :=
endif
TAR_EXCLUDES := --exclude="Test/Pseudo/*/*OTF.usp" \
		--exclude="Test/*/*/*_OTF.usp" \
		--exclude="Test/*/*/test.err.*" \
		--exclude="Test/*/*/test.out.*" \
		--exclude="Test/*/*/*-out.cell" \
		--exclude="lib/cif2cell/*" \
		--exclude="Utilities/cif2cell/build/*" \
		--exclude="*.orig" \
		--exclude="*.rej" \
		--exclude="*.pyc" \
		--exclude="*.aux" \
		--exclude="*.toc" \
		--exclude="*.lof" \
		--exclude="*.lot" \
		--exclude="*.log" \
		--exclude="*.dvi" \
		--exclude="*-eps-converted-to.pdf" \
		--exclude="*~"

dist:	$(ARCHIVE_ROOT).tar.gz

scripts:  $(SCRIPTS_ROOT).tar.gz

%.gz:	%
	gzip $<

%.bz2:	%
	bzip2 $<

%.xz:	%
	xz $<

#
# Some OSes have a limit on the number of arguments to a command.
# (i.e. Too many file names once the glob is expanded.)
# We split the tar command to work around this.
#
$(ARCHIVE_ROOT).tar:
		@bin/mkbuildinfo.pl Source/Utility/buildinfo.f90 > /dev/null
		cd .. && $(TAR) -cf $(WD)/$(ARCHIVE_ROOT).tar \
		$(TAR_XFORM) \
		$(TAR_EXCLUDES) \
		$(WD)/LICENCE.md \
		$(WD)/LICENCE.pdf \
		$(WD)/README.INSTALL \
		$(WD)/RELEASE.NOTES \
		$(WD)/Makefile \
		$(WD)/bin/arch \
		$(WD)/bin/*.pl \
		$(WD)/bin/*.py \
		$(WD)/bin/*.sh \
		$(WD)/bin/compilername \
		$(WD)/lib \
		$(WD)/Source/castep.f90 \
		$(WD)/Source/Utility/*.c \
		$(WD)/Source/Utility/*.tmpl \
		$(WD)/Source/Utility/*.*90 \
		$(WD)/Source/Fundamental/*.[fF]90 \
		$(WD)/Source/Functional/*.[fF]90 \
		$(WD)/Source/Test/*.[fF]90 \
		$(WD)/Source/Test/Inputs \
		$(WD)/Source/Test/Outputs \
		$(WD)/Source/Tools/
		cd .. && $(TAR) -rf $(WD)/$(ARCHIVE_ROOT).tar \
		$(TAR_XFORM) \
		$(TAR_EXCLUDES) \
		$(WD)/LibSource/ \
		$(WD)/Spec/ \
		$(WD)/Doc/ \
		$(WD)/Examples/ \
		$(WD)/Results/ \
		$(WD)/obj/include_*.mk \
		$(WD)/obj/Makefile \
		$(WD)/obj/Makefile.python \
		$(WD)/obj/platforms
		cd .. && $(TAR) -rf $(WD)/$(ARCHIVE_ROOT).tar \
		$(TAR_XFORM) \
		$(TAR_EXCLUDES) \
		${WD}/Test/jobconfig ${WD}/Test/userconfig ${WD}/Test/README ${WD}/Test/Makefile \
		$(WD)/Test/*/*/*.cell $(WD)/Test/*/*/*.param $(WD)/Test/*/*/*.recpot $(WD)/Test/*/*/*.realpot \
		$(WD)/Test/*/*/*.DAT $(WD)/Test/*/*/*.usp $(WD)/Test/*/*/*.uspcc $(WD)/Test/*/*/*.uspso \
		$(WD)/Test/*/*/*.UPF $(WD)/Test/*/*/Si2-phonon.check-* $(WD)/Test/*/*/*.pimd \
		$(WD)/Test/Pseudopotentials \
		$(WD)/Utilities/atat_castep_interface $(WD)/Utilities/bader $(WD)/Utilities/BoltzTrap \
		$(WD)/Utilities/CASTEPconv $(WD)/Utilities/c2x $(WD)/Utilities/castepdos $(WD)/Utilities/cellsymm \
		$(WD)/Utilities/cif2cell $(WD)/Utilities/cteprouts $(WD)/Utilities/cube_tools \
		$(WD)/Utilities/effective_mass_calculator $(WD)/Utilities/elastic_constants $(WD)/Utilities/emacs_mode \
		$(WD)/Utilities/Makefile $(WD)/Utilities/mdtep $(WD)/Utilities/optados $(WD)/Utilities/README $(WD)/Utilities/scripts $(WD)/Utilities/ShengBTE \
		$(WD)/Utilities/obj/make.system $(WD)/Utilities/obj/include_rules.mk

$(SCRIPTS_ROOT).tar:
		@if [ ! -x "$(INSTALL_DIR)" ]; then echo "$(INSTALL_DIR)" " does not exist.  Create [y/n]?." && read ANS && if [ "$$ANS" = "Y" -o "$$ANS" = "y" ]; then /bin/mkdir -p  "$(INSTALL_DIR)"; fi;fi
		$(MAKE) -C Utilities ARCH=$(ARCH) install
		cd .. && $(TAR) -cf $(WD)/$(SCRIPTS_ROOT).tar \
		$(TAR_XFORM_SCR) \
		$(INSTALL_DIR)/awk_elf_to_xsf \
		$(INSTALL_DIR)/c2x \
		$(INSTALL_DIR)/castep2cell \
		$(INSTALL_DIR)/castep2cssr \
		$(INSTALL_DIR)/castep2pdb \
		$(INSTALL_DIR)/castep2shak \
		$(INSTALL_DIR)/castep2shx \
		$(INSTALL_DIR)/castep2xsf \
		$(INSTALL_DIR)/castep2xtl \
		$(INSTALL_DIR)/castep2xyz \
		$(INSTALL_DIR)/castepconv.py \
		$(INSTALL_DIR)/castep.py \
		$(INSTALL_DIR)/cconv \
		$(INSTALL_DIR)/cell2cell \
		$(INSTALL_DIR)/cell2pdb \
		$(INSTALL_DIR)/cell2sgroup \
		$(INSTALL_DIR)/cell2shx \
		$(INSTALL_DIR)/cell2xsf \
		$(INSTALL_DIR)/cell2xtl \
		$(INSTALL_DIR)/cell2xyz \
		$(INSTALL_DIR)/ceteprouts.pm \
		$(INSTALL_DIR)/cif2cell \
		$(INSTALL_DIR)/CijUtil.py \
		$(INSTALL_DIR)/cssr2cell \
		$(INSTALL_DIR)/cssr2gulp \
		$(INSTALL_DIR)/den2grd \
		$(INSTALL_DIR)/den2xplor \
		$(INSTALL_DIR)/den2xsf \
		$(INSTALL_DIR)/dispersion.pl \
		$(INSTALL_DIR)/dos.pl \
		$(INSTALL_DIR)/elastics.py \
		$(INSTALL_DIR)/elementdata.py \
		$(INSTALL_DIR)/ESPInterfaces.py \
		$(INSTALL_DIR)/generate_strain.py \
		$(INSTALL_DIR)/geom2dcd \
		$(INSTALL_DIR)/geom2pdbseq \
		$(INSTALL_DIR)/geom2xsf \
		$(INSTALL_DIR)/geom2xyz.pl \
		$(INSTALL_DIR)/pdb2cell \
		$(INSTALL_DIR)/pdb2pdb \
		$(INSTALL_DIR)/pdb2shak \
		$(INSTALL_DIR)/pdb2shx \
		$(INSTALL_DIR)/pdb2xtl \
		$(INSTALL_DIR)/perl_md.pl \
		$(INSTALL_DIR)/perl_pimd.pl \
		$(INSTALL_DIR)/phonon2xyz \
		$(INSTALL_DIR)/pimerge.pl \
		$(INSTALL_DIR)/rotate_Albite.py \
		$(INSTALL_DIR)/rotCij.py \
		$(INSTALL_DIR)/shx2cell \
		$(INSTALL_DIR)/spacegroupdata.py \
		$(INSTALL_DIR)/test-CijUtil.py \
		$(INSTALL_DIR)/uctools.py \
		$(INSTALL_DIR)/utils.py \
		$(INSTALL_DIR)/vasp2cell \
		$(INSTALL_DIR)/vasp2pdb \
		$(INSTALL_DIR)/xtl2cell \
		$(INSTALL_DIR)/xtl2cssr \
		$(INSTALL_DIR)/xtl2pdb \
		$(INSTALL_DIR)/xtl2sgroup \
		$(INSTALL_DIR)/xtl2shx

#######################################################################
# 
# Targets for setting up prerequisite build tree and variables
#
#
# Variables to read previously chosen library and install directory/paths from save files
#
FFTLIBDIRFILE  := $(OBJ_DIR)/fftlibdir.$(FFT)
MATHLIBDIRFILE := $(OBJ_DIR)/mathlibdir.$(MATHLIBS)
DLMGLIBDIRFILE := $(OBJ_DIR)/dlmglibdir.$(DL_MG)
#
# Allow override specification of MATHLIBDIR=. FFTLIBDIR= on command line, including null strings for non-interactive builds.
#
ifeq ($(origin MATHLIBDIR),undefined)
export MATH_LIB_DIR := $(strip $(shell if [ -f $(MATHLIBDIRFILE) ] ; then cat $(MATHLIBDIRFILE); fi))
else
export MATH_LIB_DIR := $(strip $(MATHLIBDIR))
endif
#
ifeq ($(origin FFTLIBDIR),undefined)
export FFT_LIB_DIR  := $(strip $(shell if [ -f $(FFTLIBDIRFILE) ]  ; then cat $(FFTLIBDIRFILE); fi))
else
export FFT_LIB_DIR  := $(strip $(FFTLIBDIR))
endif
#
ifeq ($(origin DLMGLIBDIR),undefined)
ifneq ($(DL_MG),compile)
# DLMG_LIB_DIR is set earlier, if DL_MG=compile
export DLMG_LIB_DIR  := $(strip $(shell if [ -f $(DLMGLIBDIRFILE) ]  ; then cat $(DLMGLIBDIRFILE); fi))
endif
else
export DLMG_LIB_DIR  := $(strip $(DLMGLIBDIR))
endif
#
# Top-level Target to set up all prerequisites
#
PREREQUISITES := version test_arch comms_choice fft_choice mathlib_choice build_choice xml_choice spglib_choice libxc_choice dl_mg_choice $(OBJ_DIR)/exists $(MATHLIBDIRFILE) $(FFTLIBDIRFILE) $(DLMGLIBDIRFILE)
ifneq ($(ARCH),forcheck)
ifeq ($(LIBXC),compile)
PREREQUISITES := $(PREREQUISITES) $(OBJ_DIR)/libxc.a
endif
ifeq ($(SPGLIB),compile)
PREREQUISITES := $(PREREQUISITES) $(OBJ_DIR)/libsymspg.a
endif
ifeq ($(DL_MG),compile)
PREREQUISITES := $(PREREQUISITES) $(OBJ_DIR)/$(DLMG_LIB_DIR)/libdlmg.a
endif
endif
make_prereq: $(PREREQUISITES)
#fft_choice build_choice mathlib_choice xml_choice

#
# The following hairy GNU make stuff defines macros ${\n} and ${ } for a newline and a space which we will use for error 
# message formatting. See http://www.cmcrossroads.com/ask-mr-make/8442-gnu-make-escaping-a-walk-on-the-wild-side
#
define \n


endef
null :=
space := ${null} ${null}
${space} := ${space}# ${ } is a space. Neat huh?
#
# Can't run with older versions of Make so abort
#
version:
        $(if $(filter $(MAKE_VERSION),3.70 3.71 3.72 3.72.1 3.73 3.74 3.75 3.76 3.76.1 3.77 3.78.1 3.79 3.79.1 3.80),\
        $(error This makefile requires GNU make version 3.82 or later (found $(MAKE_VERSION))),)
ifneq ($(ARCH),forcheck)
        $(if $(filter $(MAKE_VERSION),3.81),\
        $(warning GNU make version 3.82 or later is recommended: proceeding with Make $(MAKE_VERSION)\
	 ${\n}Some modules may be compiled at unnecessarily low optimisation level${\n}),)
endif
#
# Validation of customization preferences
#
comms_choice:
	$(if $(filter-out serial mpi,$(COMMS_ARCH)), $(error COMMS_ARCH should be one of "mpi","serial" (not $(COMMS_ARCH))) )

fft_choice:
	$(if $(filter-out generic vendor fftw3 default mkl acml,$(FFT)), \
              $(error FFT should be one of "generic" "vendor", "fftw3", "default", "mkl", "acml" (not $(FFT))) )

mathlib_choice:
	$(if $(filter-out acml atlas cxml default essl generic openblas mkl scilib scs scsl sunperf vendor,$(MATHLIBS)),\
              $(error MATHLIBS should be one of "acml","atlas","cxml","default","essl","generic","openblas ","mkl","scilib","scs","scsl","sunperf","vendor" (not $(MATHLIBS))) )

build_choice:
	$(if $(filter-out coverage debug intermediate fast coverage,$(BUILD)), \
             $(error BUILD should be one of "coverage","debug", "intermediate", "fast", "coverage" (not $(BUILD))) )

spglib_choice:
	$(if $(filter-out compile system,$(SPGLIB)), $(error SPGLIB should be one of "compile","system" (not $(SPGLIB))) )

libxc_choice:
	$(if $(filter-out none compile system,$(LIBXC)), $(error LIBXC should be one of "none","compile","system" (not $(LIBXC))) )

dl_mg_choice:
	$(if $(filter-out none compile system,$(DL_MG)), $(error DL_MG should be one of "none","compile","system" (not $(DL_MG))) )

xml_choice:
	$(if $(filter-out fox dummy,$(XML)), $(error XML should be one of "fox","dummy" (not $(XML))) )

# This rule tests if the architecture we are compiling on is supported

ARCH_SUPPORTED := $(subst .mk,,$(shell cd obj/platforms && ls *.mk))

test_arch:
	$(if $(filter ${BASE_ARCH},${ARCH_SUPPORTED}),,$(error Unsupported architecture "${BASE_ARCH}": Architecture should be one of \
                   [${\n}$(subst ${ },${\n},${ARCH_SUPPORTED})]))

ifneq ($(origin F90), undefined)
FC := $(F90)
else
FC := $(shell bin/compilername $(BASE_ARCH) $(MATHLIBS))
endif
ifneq ($(origin OMPI_FC), undefined)
FC := $(OMPI_FC)
else
FC := $(shell bin/compilername $(BASE_ARCH) $(MATHLIBS))
endif
#
# Target to build the platform-specific object tree
#
CP      := cp

$(OBJ_DIR)/exists:
	if [ -d $(OBJ_DIR) ]; then mv  $(OBJ_DIR)  $(OBJ_DIR).bak; fi
	mkdir $(OBJ_DIR)  $(OBJ_DIR)/dependencies $(OBJ_DIR)/spglib $(OBJ_DIR)/libxc $(OBJ_DIR)/dl_mg $(OBJ_DIR)/python
	$(CP) obj/Makefile $(OBJ_DIR)
	$(CP) obj/Makefile.python $(OBJ_DIR)/python/Makefile
	if [ -f Source/Utility/buildinfo.f90 ]; then $(CP) Source/Utility/buildinfo.f90 $(OBJ_DIR) ; fi
	if [ $(ARCH) = $(BASE_ARCH) -o ! -f obj/$(ARCH).mk ]; then $(CP) obj/platforms/$(BASE_ARCH).mk  obj/$(ARCH).mk; fi
	touch $(OBJ_DIR)/exists

buildinfo:
	@bin/mkbuildinfo.pl $(OBJ_DIR)/buildinfo.f90

##
# Targets to enquire of the builder where LAPACK/BLAS and FFT libraries are stored.
# They are serially dependent for use with "make -j"
#
$(MATHLIBDIRFILE):
ifeq ($(origin MATHLIBDIR),undefined)
ifneq ($(MATHLIBS),default)
	$(info ***********************************************************************************)
	$(info Please enter directory where $(MATHLIBS) LAPACK and BLAS libraries are kept:)
	$(info ${ }     Hit the "return" key if these are in the default linker path.)
	$(info ${ }     The value you enter will be stored and used in future compiles.)
	$(info ${ }     Delete file $(MATHLIBDIRFILE) to remove saved value.)
	$(eval MATH_LIB_DIR := $(strip $(shell read MATH_LIB_DIR && echo $$MATH_LIB_DIR > $(MATHLIBDIRFILE) && echo $$MATH_LIB_DIR)))
else
	@echo "" > $(MATHLIBDIRFILE)
endif
else
endif

$(FFTLIBDIRFILE):
ifeq ($(origin FFTLIBDIR),undefined)
ifneq ($(FFT),generic)
ifneq ($(FFT),default)
	$(info ***********************************************************************************)
	$(info Please enter directory where $(FFT) FFT libraries are kept:)
	$(info ${ }     Hit the "return" key if these are in the default linker path.)
	$(info ${ }     The value you enter will be stored and used in future compiles.)
	$(info ${ }     Delete file $(FFTLIBDIRFILE) to remove saved value.)
	$(eval FFT_LIB_DIR := $(strip $(shell read FFT_LIB_DIR && echo $$FFT_LIB_DIR > $(FFTLIBDIRFILE) && echo $$FFT_LIB_DIR)))
else
	@echo "" > $(FFTLIBDIRFILE)
endif
else
	@echo "" > $(FFTLIBDIRFILE)
endif
endif

$(SPGLIBDIRFILE):
ifeq ($(origin SPGLIBDIR),undefined)
ifneq ($(SPGLIBS),compile)
	$(info ***********************************************************************************)
	$(info Please enter directory where $(SPGLIBS) libraries are kept:)
	$(info ${ }     Hit the "return" key if these are in the default linker path.)
	$(info ${ }     The value you enter will be stored and used in future compiles.)
	$(info ${ }     Delete file $(SPGLIBDIRFILE) to remove saved value.)
	$(eval SPG_LIB_DIR := $(strip $(shell read SPG_LIB_DIR && echo $$SPG_LIB_DIR > $(SPGLIBDIRFILE) && echo $$SPG_LIB_DIR)))
else
	@echo "" > $(SPGLIBDIRFILE)
endif
else
endif

$(LIBXCLIBDIRFILE):
ifneq ($LIBXC),none)
ifeq ($(origin LIBXCLIBDIR),undefined)
ifneq ($(LIBXC),compile)
	$(info ***********************************************************************************)
	$(info Please enter directory where $(LIBXC) libraries are kept:)
	$(info ${ }     Hit the "return" key if these are in the default linker path.)
	$(info ${ }     The value you enter will be stored and used in future compiles.)
	$(info ${ }     Delete file $(LIBXCLIBDIRFILE) to remove saved value.)
	$(eval LIBXC_LIB_DIR := $(strip $(shell read LIBXC_LIB_DIR && echo $$LIBXC_LIB_DIR > $(LIBXCLIBDIRFILE) && echo $$LIBXC_LIB_DIR)))
else
	@echo "" > $(LIBXCLIBDIRFILE)
endif
else
endif
else
endif

$(DLMGLIBDIRFILE):
ifneq ($(DL_MG),none)
ifeq ($(origin DLMGLIBDIR),undefined)
ifneq ($(DL_MG),compile)
	$(info ***********************************************************************************)
	$(info Please enter directory where DL_MG library is kept:)
	$(info ${ }     Hit the "return" key if these are in the default linker path.)
	$(info ${ }     The value you enter will be stored and used in future compiles.)
	$(info ${ }     Delete file $(DLMGLIBDIRFILE) to remove saved value.)
	$(eval DLMG_LIB_DIR := $(strip $(shell read DLMG_LIB_DIR && echo $$DLMG_LIB_DIR > $(DLMGLIBDIRFILE) && echo $$DLMG_LIB_DIR)))
else
	@echo "" > $(DLMGLIBDIRFILE)
endif
endif
endif

python: castep
	$(MAKE) -C $(OBJ_DIR)/python ARCH=$(ARCH) python

python-install:
	$(MAKE) -C $(OBJ_DIR)/python ARCH=$(ARCH) python-install

ford-doc:
# Clean old Ford Doc
	rm -rf Doc/Ford
# Switch to ford documentation style
	for i in Utility Fundamental Functional; do \
		mkdir -p Utilities/FordDoc/tmp/$$i; \
		mkdir -p Doc/Ford/$$i; \
		files=`ls Source/$$i/*0`; \
		for j in $$files; do \
			Utilities/FordDoc/castep_ford.pl $$j > Utilities/FordDoc/tmp/$$i/$${j##*/}; \
		done; \
	done
	Utilities/FordDoc/castep_ford.pl -c Source/Fundamental/cell.f90  > Utilities/FordDoc/tmp/Fundamental/cell.f90
	mkdir -p Utilities/FordDoc/tmp/Main
	mkdir -p Doc/Ford/Main
	Utilities/FordDoc/castep_ford.pl Source/castep.f90 > Utilities/FordDoc/tmp/Main/castep.f90
	for i in Utility Fundamental Functional Main; do \
		ford Utilities/FordDoc/ford_doc_$$i.md; \
	done
# Move CASTEP main docs back to main
	mv Doc/Ford/Main/* Doc/Ford/
	rmdir Doc/Ford/Main
# Clean up
	rm -rf Utilities/FordDoc/tmp/

# This target allows printing of named varialbes
# e.g. make print-ARCH
# Useful for debugging!
print-%:
	@echo '$*=$($*)'
	@echo '  origin = $(origin $*)'
	@echo '  flavor = $(flavor $*)'
	@echo '   value = $(value  $*)'
