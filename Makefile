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
    $(I3BIN)/i3-launcher \
    $(I3BIN)/i3-keyboard \
    $(I3BIN)/i3-mode \
    $(I3BIN)/i3-mouse \
    $(I3BIN)/i3-scratchpad \
    $(I3BIN)/i3-list-windows \
    $(I3BIN)/i3-status

  .installextras:  \
	$(I3BIN)/my-tvheadend \
	$(I3BIN)/my-usb-disks

all :  .installdirs .installconfigs .installscripts .installextras


# .installdirs

$(i3BIN):
	@install -m $(DIRMODE) -d $(I3BIN)

# .installconfigs

# This rule immediately modifies the recently installed file.
$(I3CFG):  i3-config \
	i3-config.d/cfg00 i3-config.d/cfg01 i3-config.d/cfg02 \
	i3-config.d/cfg04 i3-config.d/cfg05 \
	i3-config.d/cfg07 i3-config.d/cfg08
	@install -m $(CFGMODE)  i3-config $@
	@sed -e '/###INSERT_CFG00_HERE###/ {' -e 'r i3-config.d/cfg00' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG01_HERE###/ {' -e 'r i3-config.d/cfg01' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG02_HERE###/ {' -e 'r i3-config.d/cfg02' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG04_HERE###/ {' -e 'r i3-config.d/cfg04' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG05_HERE###/ {' -e 'r i3-config.d/cfg05' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG07_HERE###/ {' -e 'r i3-config.d/cfg07' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG08_HERE###/ {' -e 'r i3-config.d/cfg08' -e 'd' -e '}' \
         -i   $(I3CFG)
	@i3-msg 'mode "reload"'
	@sleep 2
	@i3-msg 'mode "default"'
	@i3-msg "reload"

$(I3STATUSCFG):  i3-status-config
	@install -m $(CFGMODE)  i3-status-config $@
	@i3-msg 'mode "restart"'
	@sleep 2
	@i3-msg 'mode "default"'
	@i3-msg "restart"
	@sleep 2
	@i3-msg "exec --no-startup-id xfce4-panel --restart"

# .installscripts

$(I3BIN)/i3-command-prompt: \
	$(I3SCRIPTS)/i3-command-prompt \
	$(I3SCRIPTS)/i3-command-prompt.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-command-prompt $(I3BIN)

$(I3SCRIPTS)/i3-command-prompt.log: $(I3SCRIPTS)/i3-command-prompt
	@shellcheck $(I3SCRIPTS)/i3-command-prompt > $@

$(I3BIN)/i3-file-watcher:  \
	$(I3SCRIPTS)/i3-file-watcher \
	$(I3SCRIPTS)/i3-file-watcher.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-file-watcher $(I3BIN)

$(I3SCRIPTS)/i3-file-watcher.log: $(I3SCRIPTS)/i3-file-watcher
	@shellcheck $(I3SCRIPTS)/i3-file-watcher > $@

$(I3BIN)/i3-dispatcher: \
	$(I3SCRIPTS)/i3-dispatcher \
	$(I3SCRIPTS)/i3-dispatcher.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-dispatcher $(I3BIN)

$(I3SCRIPTS)/i3-dispatcher.log: $(I3SCRIPTS)/i3-dispatcher
	@shellcheck $(I3SCRIPTS)/i3-dispatcher > $@

# This rule immediately modifies the recently installed file.
$(I3BIN)/i3-focus-app-by-alias: \
	$(I3SCRIPTS)/i3-focus-app-by-alias \
	$(I3SCRIPTS)/i3-focus-app-by-alias.log  \
	apps00
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-focus-app-by-alias $(I3BIN)
	@sed -e '/###INSERT_APPS00_HERE###/ {' -e 'r apps00' -e 'd' -e '}' \
         -i   $(I3BIN)/i3-focus-app-by-alias

$(I3SCRIPTS)/i3-focus-app-by-alias.log: $(I3SCRIPTS)/i3-focus-app-by-alias
	@shellcheck $(I3SCRIPTS)/i3-focus-app-by-alias > $@

$(I3BIN)/i3-launcher: \
	$(I3SCRIPTS)/i3-launcher \
	$(I3SCRIPTS)/i3-launcher.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-launcher $(I3BIN)

$(I3SCRIPTS)/i3-launcher.log: $(I3SCRIPTS)/i3-launcher
	@shellcheck $(I3SCRIPTS)/i3-launcher  > $@

$(I3BIN)/i3-keyboard: \
	$(I3SCRIPTS)/i3-keyboard \
	$(I3SCRIPTS)/i3-keyboard.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-keyboard $(I3BIN)

$(I3SCRIPTS)/i3-keyboard.log: $(I3SCRIPTS)/i3-keyboard
	@shellcheck $(I3SCRIPTS)/i3-keyboard > $@

$(I3BIN)/i3-mode: \
	$(I3SCRIPTS)/i3-mode \
	$(I3SCRIPTS)/i3-mode.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-mode $(I3BIN)

$(I3BIN)/i3-mouse: \
	$(I3SCRIPTS)/i3-mouse \
	$(I3SCRIPTS)/i3-mouse.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-mouse $(I3BIN)

$(I3SCRIPTS)/i3-mouse.log: $(I3SCRIPTS)/i3-mouse
	@shellcheck $(I3SCRIPTS)/i3-mouse > $@

$(I3BIN)/i3-scratchpad: \
	$(I3SCRIPTS)/i3-scratchpad \
	$(I3SCRIPTS)/i3-scratchpad.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-scratchpad $(I3BIN)

$(I3SCRIPTS)/i3-scratchpad.log: $(I3SCRIPTS)/i3-scratchpad
	@shellcheck $(I3SCRIPTS)/i3-scratchpad > $@

$(I3BIN)/i3-list-windows: \
	$(I3SCRIPTS)/i3-list-windows \
	$(I3SCRIPTS)/i3-list-windows.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-list-windows $(I3BIN)

$(I3SCRIPTS)/i3-list-windows.log: $(I3SCRIPTS)/i3-list-windows
	@shellcheck $(I3SCRIPTS)/i3-list-windows > $@

$(I3BIN)/i3-status: \
	$(I3SCRIPTS)/i3-status \
	$(I3SCRIPTS)/i3-status.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-status $(I3BIN)
	@i3-msg 'mode "restart"'
	@sleep 2
	@i3-msg 'mode "default"'
	@i3-msg "restart"
	@sleep 2
	@i3-msg "exec --no-startup-id xfce4-panel --restart"

$(I3SCRIPTS)/i3-status.log: $(I3SCRIPTS)/i3-status
	@shellcheck $(I3SCRIPTS)/i3-status > $@

# .installextras

$(I3BIN)/my-tvheadend: \
	$(MYSCRIPTS)/my-tvheadend \
	$(MYSCRIPTS)/my-tvheadend.log
	@install -m $(EXEMODE) $(MYSCRIPTS)/my-tvheadend $(I3BIN)

$(MYSCRIPTS)/my-tvheadend.log: $(MYSCRIPTS)/my-tvheadend
	@shellcheck $(MYSCRIPTS)/my-tvheadend > $@

(I3BIN)/my-usb-disks: \
	$(MYSCRIPTS)/my-usb-disks \
	$(MYSCRIPTS)/my-usb-disks.log
	@install -m $(EXEMODE) $(MYSCRIPTS)/my-usb-disks $(I3BIN)

$(MYSCRIPTS)/my-usb-disks.log: $(MYSCRIPTS)/my-usb-disks
	@shellcheck $(MYSCRIPTS)/my-usb-disks > $@

# Debug use only.
vars:
	@echo "$(DOPAMINE)\n$(I3CFG)\n$(I3STATUSCFG)\n$(I3SCRIPTS)\n$(MYSCRIPTS)\n"

#
# Done
#
