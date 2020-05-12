#
# Makefile
#
# Requires : shellcheck
#
SHELL=/bin/bash

# Installing each config in these two places is defensive programming.
# If someone can confirm Regolith's placement and naming of the i3
# config and i3status config, I'd like to support it. 

# The i3 config file to be installed..
I3CFG=$(HOME)/.i3/config

# The i3status config file to be installed. 
I3STATUSCFG=$(HOME)/.i3status.conf
# Directory where helper scripts will be installed.  I've tried to use
# absolute paths that take this into account so users don't have to.
# Including this directory on your ${PATH} is recommended.
I3BIN=$(HOME)/local/bin

# Local git repo directory, where the Makefile lives, and from where
# tt should be invoked.
DOPAMINE=$(shell readlink -f $(shell pwd))

# Generic helper scripts for i3 that everyone needs.
I3SCRIPTS=$(shell readlink -f "$(DOPAMINE)/i3scripts")
# Custom helper scripts for i3 for your niche use cases.
# I've included examples.
MYSCRIPTS=$(shell readlink -f "$(DOPAMINE)/myscripts")

# Install permissions for: directories, executables, configurations.
DIRMODE=755
EXEMODE=755
CFGMODE=644

.installdirs:  $(I3BIN)

.installconfigs:  $(I3CFG) $(I3STATUSCFG)

.installscripts: \
    $(I3BIN)/i3-command-prompt \
    $(I3BIN)/i3-file-watcher \
    $(I3BIN)/i3-dispatcher \
    $(I3BIN)/i3-focus-app-by-alias \
    $(I3BIN)/i3-mode \
    $(I3BIN)/i3-keyboard \
    $(I3BIN)/i3-mouse \
    $(I3BIN)/i3-scratchpad \
    $(I3BIN)/i3-list-windows \
    $(I3BIN)/i3-status

  .installextras:  $(I3BIN)/my-usb-disks


all :  .installdirs .installconfigs .installscripts .installextras
	@i3-msg  'mode "default"'

# .installdirs

$(i3BIN):
	@install -m $(DIRMODE) -d $(I3BIN)

# .installconfigs

$(I3CFG):  i3-config
	@mv $@ $@.save	
	@install -m $(CFGMODE)  i3-config $@
	@i3-msg 'mode "reload"'
	@sleep 2
	@i3-msg "reload"

$(I3STATUSCFG):  i3-status-config
	@mv $@ $@.save	
	@install -m $(CFGMODE)  i3-status-config $@
	@i3-msg 'mode "restart"'
	@sleep 2
	@i3-msg "restart"

# .installscripts

$(I3BIN)/i3-command-prompt: $(I3SCRIPTS)/i3-command-prompt
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-command-prompt $(I3BIN)

$(I3BIN)/i3-file-watcher: $(I3SCRIPTS)/i3-file-watcher
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-file-watcher $(I3BIN)

$(I3BIN)/i3-dispatcher: $(I3SCRIPTS)/i3-dispatcher
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-dispatcher $(I3BIN)

$(I3BIN)/i3-focus-app-by-alias: $(I3SCRIPTS)/i3-focus-app-by-alias
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-focus-app-by-alias $(I3BIN)

$(I3BIN)/i3-mode: $(I3SCRIPTS)/i3-mode
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-mode $(I3BIN)

$(I3BIN)/i3-keyboard: $(I3SCRIPTS)/i3-keyboard
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-keyboard $(I3BIN)

$(I3BIN)/i3-mouse: $(I3SCRIPTS)/i3-mouse
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-mouse $(I3BIN)

$(I3BIN)/i3-scratchpad: $(I3SCRIPTS)/i3-scratchpad
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-scratchpad $(I3BIN)

$(I3BIN)/i3-list-windows: $(I3SCRIPTS)/i3-list-windows
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-list-windows $(I3BIN)

$(I3BIN)/i3-status: $(I3SCRIPTS)/i3-status
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-status $(I3BIN)

# .installextras

$(I3BIN)/my-usb-disks: $(MYSCRIPTS)/my-usb-disks
	@install -m $(EXEMODE) $(MYSCRIPTS)/my-usb-disks $(I3BIN)

# Debug use only.
vars:
	@echo "$(DOPAMINE)\n$(I3CFG)\n$(I3STATUSCFG)\n$(I3SCRIPTS)\n$(MYSCRIPTS)\n"



#
# Done
#

