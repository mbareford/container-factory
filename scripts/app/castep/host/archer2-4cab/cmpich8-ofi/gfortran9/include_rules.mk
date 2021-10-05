#
# Define inplicit rules for compilation and archive building.
#
#
# Not really a rule - but put here to avoid additional include file
CASTEP_LIB_SEARCH_PATH :=
#
# Add run-time library search paths to link flags
#
ifndef NATIVE_WINDOWS

ifneq ($(strip $(MATH_LIB_DIR)), )
CASTEP_LIB_SEARCH_PATH += -L"$(MATH_LIB_DIR)"
ifdef SUN
CASTEP_LIB_SEARCH_PATH += -R "$(MATH_LIB_DIR)"
else ifdef NAG
CASTEP_LIB_SEARCH_PATH += -Wl,-Wl,,-rpath="$(MATH_LIB_DIR)"
else ifdef LINUX
CASTEP_LIB_SEARCH_PATH += -Wl,-rpath="$(MATH_LIB_DIR)"
endif
endif

ifeq ($(FFT),fftw3)
CPPFLAGS := -I$(FFT_LIB_DIR)/../include -I/opt/cray/pe/mpich/8.0.16/ofi/gnu/9.1/include
endif
ifneq ($(strip $(FFT_LIB_DIR)), )
CASTEP_LIB_SEARCH_PATH += -L"$(FFT_LIB_DIR)"
ifdef SUN
CASTEP_LIB_SEARCH_PATH += -R "$(FFT_LIB_DIR)"
else ifdef NAG
CASTEP_LIB_SEARCH_PATH += -Wl,-Wl,,-rpath="$(FFT_LIB_DIR)"
else ifdef LINUX
CASTEP_LIB_SEARCH_PATH += -Wl,-rpath="$(FFT_LIB_DIR)"
endif
endif

ifneq ($(strip $(DLMG_LIB_DIR)), )
CASTEP_LIB_SEARCH_PATH += -L"$(DLMG_LIB_DIR)"
ifdef SUN
CASTEP_LIB_SEARCH_PATH += -R "$(DLMG_LIB_DIR)"
else ifdef NAG
CASTEP_LIB_SEARCH_PATH += -Wl,-Wl,,-rpath="$(DLMG_LIB_DIR)"
else ifdef LINUX
CASTEP_LIB_SEARCH_PATH += -Wl,-rpath="$(DLMG_LIB_DIR)"
endif
endif

endif
# end ifndef NATIVE_WINDOWS

# Tag on FoX's dependencies, if applicable
ifeq ($(XML),fox)
INC += $(shell FoX-config --fcflags)
LIBS += $(shell FoX-config --libs --wcml)
endif

OBJ_EXTN ?= o
LIB_EXTN ?= a
MOD_EXTN ?= mod
COND_COMPILE ?= $(ROOTDIR)/bin/compile_mod.pl
CMP      ?= $(ROOTDIR)/bin/compare_module_file.pl  -compiler $(COMPILER)
MKDEPF90 ?= $(ROOTDIR)/bin/mkdepf90.pl
ARFLAGSS ?= r
RANLIB   ?= ranlib

# Annihilate suffixes list and use only our own.  
# (Solaris picks up a bad implicit rule for modules otherwise)
#
.SUFFIXES:
.SUFFIXES: .$(LIB_EXTN) .$(OBJ_EXTN) .F90 .f90 .f .c .mod .exe

#
# Cancel implicit rules for Modula-2 (mod extension) and Fortran 77/fixed (.f)
#
%: %.mod

(%.mod): %mod

% : %.f

ifdef FORCHK
#
# Special rules for a "forcheck" run
# 
dependencies/%.f90mdeps dependencies/%.f90odeps: %.F90 | dependencies
	$(MKDEPF90) -obj_ext $(OBJ_EXTN) -src $< -depdir dependencies/

dependencies/%.f90mdeps dependencies/%.f90odeps: %.f90 | dependencies
	$(MKDEPF90) -obj_ext $(OBJ_EXTN) -src $< -depdir dependencies/

dependencies/%.f90mdeps dependencies/%.f90odeps: %.f | dependencies
	$(MKDEPF90) -obj_ext $(OBJ_EXTN) -src $< -depdir dependencies/

%.mod: %.$(OBJ_EXTN)
	touch $@

castep.lis: castep.f90
	$(F90) -l $@  $(FFLAGSC)  $< $(FCINCC) ; touch $*.mod && touch $(byproduct)

.F90.lis:
	$(F90) -l $@  $(FFLAGS)  $< $(FCINC) ; touch $*.mod && touch $(byproduct)

.f90.lis:
	$(F90) -l $@  $(FFLAGS)  $< $(FCINC) ; touch $*.mod && touch $(byproduct)

.f.lis:
	$(F90) -l $@  $(FFLAGS)  $< $(FCINC) ; touch $*.mod && touch $(byproduct)

else ifdef NATIVE_WINDOWS
#
# Rules for compiling on Windows with a native windows compiler, such as Ifort.
# Need special handling of filenames containing backslashes
#

# GNU Make pattern rule for generating dependency lists
dependencies/%.f90mdeps dependencies/%.f90odeps: %.F90 | dependencies
	$(MKDEPF90) -obj_ext $(OBJ_EXTN) -src $< -depdir dependencies/

dependencies/%.f90mdeps dependencies/%.f90odeps: %.f90 | dependencies
	$(MKDEPF90) -obj_ext $(OBJ_EXTN) -src $< -depdir dependencies/

dependencies/%.f90mdeps dependencies/%.f90odeps: %.f | dependencies
	$(MKDEPF90) -obj_ext $(OBJ_EXTN) -src $< -depdir dependencies/

# Native windows compilers under cygwin.  Need to translate filename syntax.
define run_f90
@$(COND_COMPILE) -fc "$(F90) -c $(FFLAGS)  $(subst /,\\\\,$(subst /cygdrive/c/,c:/,$<))  $(F90_SHELL_REDIR)" \
	    -provides "$*.$(OBJ_EXTN) $(byproduct)" \
	    -requires "$^" \
	    -cmp "$(CMP)"
endef

%.$(OBJ_EXTN): %.mod

%.$(OBJ_EXTN): %.F90
	$(run_f90)

%.$(OBJ_EXTN): %.f90
	$(run_f90)

%.$(OBJ_EXTN): %.f
	$(run_f90)

%.exe:	%.$(OBJ_EXTN)
	$(F90) -o $@  $(subst /,\\\\,$<) $(CASTEP_LIB_SEARCH_PATH) $(LD_FLAGS) $(LIBS)

else
#
# Linux, unix etc with forward-slash filenames.
#
# GNU Make pattern rule for generating dependency lists
dependencies/%.f90mdeps dependencies/%.f90odeps: %.F90 | dependencies
	$(MKDEPF90) -src $< -depdir dependencies/

dependencies/%.f90mdeps dependencies/%.f90odeps: %.f90 | dependencies
	$(MKDEPF90) -src $< -depdir dependencies/

dependencies/%.f90mdeps dependencies/%.f90odeps: %.f | dependencies
	$(MKDEPF90) -src $< -depdir dependencies/

%.o: %.mod

# %.mod rule:
#
# The first dependency should be the associated object file,
# but it will be added explicitly by including the auto-generated
# module-dependency file.
#
# Having the .mod file depend on its object file ensures a proper
# dependency graph.
#
# The condition should never occur in practice unless
# something goes terribly wrong with the %.o rule, but it is good
# practice to handle that situation.
#
%.mod:
	@if [ ! -s $@ ] ; then \
	  printf "\n\t%s\n\t%s\n\n" \
	       "$@ doesn't exist or is of zero size." \
	       "Deleting $< -- Restart MAKE and try again" 1>&2 ; \
	  $(RM) $< $(@)* ; \
	  exit 1; \
	fi

define run_f90
@$(COND_COMPILE) -fc "$(F90) -c $(FFLAGS) $< $(F90_SHELL_REDIR)" \
	    -provides "$*.o $(byproduct)" \
	    -requires "$^" \
	    -cmp "$(CMP)"
endef

%.o: %.F90
	$(run_f90)

%.o: %.f90
	$(run_f90)

%.o: %.f
	$(run_f90)

.o:
	$(F90) -o $@ $(LD_FLAGS) $< $(CASTEP_LIB_SEARCH_PATH) $(LIBS)

endif
