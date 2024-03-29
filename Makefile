#
# Makefile for dopamine-2020
#
# Requires : shellcheck
#
SHELL=/bin/bash

# The i3 config file to be installed.
I3CFG=$(HOME)/.i3/config

# The compton/picom config file to be installed.
COMPOSITORCFG=$(HOME)/.config/compton.conf

# The i3status config file to be installed.
I3STATUSCFG=$(HOME)/.i3status.conf
# Directory where helper scripts will be installed.
# 2021-09-19: "${HOME}/local/bin" is now deprecated.
I3BIN=$(HOME)/local/i3/bin

# The dunst config file to be installed.
NOTIFIERCFG=${HOME}/.config/dunst/dunstrc

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

.installconfigs:  $(I3CFG) $(I3STATUSCFG) $(COMPOSITORCFG) $(NOTIFIERCFG)

.installscripts: \
$(I3BIN)/i3-app-mode \
$(I3BIN)/i3-command-prompt \
$(I3BIN)/i3-config-scripts \
$(I3BIN)/i3-file-watcher \
$(I3BIN)/i3-dispatcher \
$(I3BIN)/i3-emacsclient \
$(I3BIN)/i3-focus-app-by-alias \
$(I3BIN)/i3-launcher \
$(I3BIN)/i3-keyboard \
$(I3BIN)/i3-list-windows \
$(I3BIN)/i3-marks \
$(I3BIN)/i3-mode \
$(I3BIN)/i3-mouse \
$(I3BIN)/i3-scratchpad \
$(I3BIN)/i3-transcribe \
$(I3BIN)/i3-triple-digit-command \
$(I3BIN)/i3-recorder \
$(I3BIN)/i3-status

.installextras: \
$(I3BIN)/tvheadend-start $(I3BIN)/my-file-watcher
.installflags: \
reloaded \
restarted


all :  .installdirs .installconfigs .installscripts .installextras .installflags

# .installflags
#
# Flags ensure that reload and restart are each performed no more than
# once and that all changes have been made beforehand.

reloaded: reload
	touch $@
	i3-msg "reload"

restarted: restart
	@touch $@
	@$(I3BIN)/i3-config-scripts restart

# It no longer necessary to run this script by hand after running
# 'make' but the automatic restart rules are "better safe than sorry"
# such that you may prefer to disable them to avoid visual disturbance
# upon restartafter any config change, even a bindsym, which is
# overkill. I intend to write better rules.
#
# Should discretionary manual invocation be your preference, comment
# out the entiree 'restarted:' rule immediately above this comment and
# use the 'wm' target immediately below instead.

wm:
	@$(I3BIN)/i3-config-scripts restart

# Note: An annoyance remains with the script: a dialog complains about
# the notification area being lost on first invocation. ToDo: Dismiss
# the dialog automatically assuming no fix for root cause.

# .installdirs

$(I3BIN):
	@install -m $(DIRMODE) -d $(I3BIN)

# .installconfigs

# This rule immediately modifies the recently installed file.
$(I3CFG):  i3-config \
	i3-config.d/cfg00 i3-config.d/cfg01 i3-config.d/cfg02 \
	i3-config.d/cfg03 i3-config.d/cfg04 i3-config.d/cfg05 \
	i3-config.d/cfg07 i3-config.d/cfg08 i3-config.d/cfg09 \
	i3-config.d/apps00 \
	i3-config.d/apps01
	@install -m $(CFGMODE)  i3-config $@
	@sed -e '/###INSERT_CFG00_HERE###/ {' -e 'r i3-config.d/cfg00' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG01_HERE###/ {' -e 'r i3-config.d/cfg01' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG02_HERE###/ {' -e 'r i3-config.d/cfg02' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG03_HERE###/ {' -e 'r i3-config.d/cfg03' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG04_HERE###/ {' -e 'r i3-config.d/cfg04' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG05_HERE###/ {' -e 'r i3-config.d/cfg05' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG07_HERE###/ {' -e 'r i3-config.d/cfg07' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG08_HERE###/ {' -e 'r i3-config.d/cfg08' -e 'd' -e '}' \
         -i   $(I3CFG)
	@sed -e '/###INSERT_CFG09_HERE###/ {' -e 'r i3-config.d/cfg09' -e 'd' -e '}' \
         -i   $(I3CFG)
	@touch restart

$(COMPOSITORCFG): compton.conf
	@install -m $(CFGMODE) compton.conf $@
	@touch restart

$(NOTIFIERCFG):  i3-config.d/dunstrc
	@$(I3BIN)/i3-config-scripts stop dunst
	@install -m $(CFGMODE) i3-config.d/dunstrc $@
	@$(I3BIN)/i3-config-scripts start dunst

$(I3STATUSCFG):  i3-status-config
	@install -m $(CFGMODE) i3-status-config $@
	@touch restart

# .installscripts

$(I3BIN)/i3-app-mode: \
	$(I3SCRIPTS)/i3-app-mode \
	$(I3SCRIPTS)/i3-app-mode.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-app-mode $(I3BIN)

$(I3SCRIPTS)/i3-app-mode.log: $(I3SCRIPTS)/i3-app-mode
	@shellcheck $(I3SCRIPTS)/i3-app-mode > $@

$(I3BIN)/i3-command-prompt: \
	$(I3SCRIPTS)/i3-command-prompt \
	$(I3SCRIPTS)/i3-command-prompt.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-command-prompt $(I3BIN)

$(I3SCRIPTS)/i3-command-prompt.log: $(I3SCRIPTS)/i3-command-prompt
	@shellcheck $(I3SCRIPTS)/i3-command-prompt > $@

$(I3BIN)/i3-config-scripts: \
	$(I3SCRIPTS)/i3-config-scripts \
	$(I3SCRIPTS)/i3-config-scripts.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-config-scripts $(I3BIN)

$(I3SCRIPTS)/i3-config-scripts.log: $(I3SCRIPTS)/i3-config-scripts
	@shellcheck $(I3SCRIPTS)/i3-config-scripts > $@

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

$(I3BIN)/i3-emacsclient: \
	$(I3SCRIPTS)/i3-emacsclient \
	$(I3SCRIPTS)/i3-emacsclient.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-emacsclient $(I3BIN)

$(I3SCRIPTS)/i3-emacsclient.log: $(I3SCRIPTS)/i3-emacsclient
	@shellcheck $(I3SCRIPTS)/i3-emacsclient > $@

# This rule immediately modifies the recently installed file.
$(I3BIN)/i3-focus-app-by-alias: \
	$(I3SCRIPTS)/i3-focus-app-by-alias \
	$(I3SCRIPTS)/i3-focus-app-by-alias.log  \
	i3-config.d/apps00
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-focus-app-by-alias $(I3BIN)
	@sed -e '/###INSERT_APPS00_HERE###/ {' -e 'r i3-config.d/apps00' -e 'd' -e '}' \
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

$(I3BIN)/i3-list-windows: \
	$(I3SCRIPTS)/i3-list-windows \
	$(I3SCRIPTS)/i3-list-windows.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-list-windows $(I3BIN)

$(I3SCRIPTS)/i3-list-windows.log: $(I3SCRIPTS)/i3-list-windows
	@shellcheck $(I3SCRIPTS)/i3-list-windows > $@

$(I3BIN)/i3-marks: \
	$(I3SCRIPTS)/i3-marks \
	$(I3SCRIPTS)/i3-marks.log \
	i3-config.d/apps01
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-marks $(I3BIN)
	@touch restart

$(I3SCRIPTS)/i3-marks.log: $(I3SCRIPTS)/i3-marks
	@shellcheck $(I3SCRIPTS)/i3-marks > $@

$(I3BIN)/i3-mode: \
	$(I3SCRIPTS)/i3-mode \
	$(I3SCRIPTS)/i3-mode.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-mode $(I3BIN)

$(I3SCRIPTS)/i3-mode.log: $(I3SCRIPTS)/i3-mode
	@shellcheck $(I3SCRIPTS)/i3-mode > $@

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

$(I3BIN)/i3-transcribe: \
	$(I3SCRIPTS)/i3-transcribe \
	$(I3SCRIPTS)/i3-transcribe.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-transcribe $(I3BIN)

$(I3SCRIPTS)/i3-transcribe.log: $(I3SCRIPTS)/i3-transcribe
	@shellcheck $(I3SCRIPTS)/i3-transcribe > $@

$(I3BIN)/i3-triple-digit-command: \
	$(I3SCRIPTS)/i3-triple-digit-command \
	$(I3SCRIPTS)/i3-triple-digit-command.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-triple-digit-command $(I3BIN)

$(I3SCRIPTS)/i3-triple-digit-command.log: $(I3SCRIPTS)/i3-triple-digit-command
	@shellcheck $(I3SCRIPTS)/i3-triple-digit-command > $@

$(I3BIN)/i3-recorder: \
	$(I3SCRIPTS)/i3-recorder \
	$(I3SCRIPTS)/i3-recorder.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-recorder $(I3BIN)

$(I3SCRIPTS)/i3-recorder.log: $(I3SCRIPTS)/i3-recorder
	@shellcheck $(I3SCRIPTS)/i3-recorder > $@

$(I3BIN)/i3-status: \
	$(I3SCRIPTS)/i3-status \
	$(I3SCRIPTS)/i3-status.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-status $(I3BIN)
	@touch restart

$(I3SCRIPTS)/i3-status.log: $(I3SCRIPTS)/i3-status
	@shellcheck $(I3SCRIPTS)/i3-status > $@

$(I3BIN)/i3-reserved: \
	$(I3SCRIPTS)/i3-reserved \
	$(I3SCRIPTS)/i3-reserved.log
	@install -m $(EXEMODE) $(I3SCRIPTS)/i3-reserved $(I3BIN)

$(I3SCRIPTS)/i3-reserved.log: $(I3SCRIPTS)/i3-reserved
	@shellcheck $(I3SCRIPTS)/i3-reserved > $@

# .installextras

# Using a pattern rule for the extras avoids the need for editing the
# Makefile when the user adds or removes a script. Unfortunately I
# can't redirect the shellcheck output to a file, but any shellcheck
# errors are displayed. Shellcheck errors will prevent installation.

$(I3BIN)/%: $(MYSCRIPTS)/%
	@shellcheck $<
	@install -m $(EXEMODE) $< $(I3BIN)

$(I3CONFIG)/i3status.conf : $(I3SCRIPTS)/i3-status
	@echo "Workaround for bug tbc."
	@touch $<
#
# Done.
#
