#
# Makefile (i3scripts)
#
# - This Makefile points "make" to the top level Makefile.
# - Expect to see this in the i3scripts and myscripts folders.
#

toplevel=$(shell dirname $(shell readlink -f $(shell pwd)))

all:  
	make -f $(toplevel)/Makefile -C  $(toplevel)

#
# Done.
#
