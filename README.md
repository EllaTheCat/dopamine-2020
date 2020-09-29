# dopamine-2020 - Customising the i3 tiling window manager.

## What's in the repository?

This repository consists of the config and scripts I'm using with i3
 4.18.1 on Xubuntu 20.04 LTS.

## Disclaimer

I took the opportunity to refactor my i3 config and scripts into this
new repository after installing the latest versions of distro and i3.
Everything is on git master not on topic branches.

## Ambitions

- The default configuration is close to being 100% compatible with the
standard i3 keybindings as shown in the i3 user's guide. You can use
it immediately.

- The config file and scripts have "magic comments". These are
postprocessing directives that could, for example, customise a single
base configuration for different users or different machines.

- I greatly admire the i3 mission statement about clean code.  I'm not
in their league, but I've tried to make the code modular and
maintainable.  If nothing else, it's commented and documented.

## Why dopamine?

Dopamine is a chemical that functions as a neurotransmitter in human
brains. I have Parkinson's Disease ("PD") because the cells that make
dopamine in my brain are dying prematurely.  Lack of dopamine causes
the hand and arm tremors and the overall slowness of movement typical
of Parkinson's Disease.

The i3 window manager lets me address the ergonomics of a user
interface for people with PD.  I want to share both the code and the
lessons learned, what works and what doesn't, because I'm no expert,
just an enthusiast. Plus you lucky people without PD might like it!

This is the third such repository I've made. This time, I'm hoping to
make it easy for people to download and run, either as a whole or in
standalone pieces.

## Installation
Dopamine wants to be installed anywhere beneath ${HOME}, in a
directory accessible to git.  Decide in which directory the git clone
 will be done, change to that directory and do:

    git clone git@github.com:EllaTheCat/dopamine-2020.git
    make

## Running "make"

- Copies config files from your local repository to where i3 expects
  them at runtime.
- Copies script files from your local repository to a folder that
  should be on your ${PATH}. I chose ${HOME}/local/bin precisely
  because no-one else does, in order to avoid conflicts. Feel free to
  make it a symlink to ${HOME}/bin or whatever.
- Modifies the copies with your customisations.
- Sets the runtime file and folder permissions.
- Runs the i3 reload command should the i3 config have changed.
- Runs the i3 restart command when i3-status or i3bar has changed.

## Running "make -n"

- Performs a dry-run, printing to the console whatever commands
would have been executed without the "-n" argument.


## Classic default mode bindings
By default, the i3 config file includes a set of $mod+keysym bindings
corresponding to the bindings described in the i3 User's Guide.  I
realised that without these, a user would struggle to use i3, and
hence would not persevere with their evaluation.

Conversely, I find modifier+key bindings difficult, and don't want to
operate them accidentally, so I'd prefer to remove them.

## Building a custom i3 config

Looking at i3-config you'll see several "magic comments":

    ###INSERT_CFG00_HERE###
    ###INSERT_CFG01_HERE###

The Makefile first deploys "i3-config"  as "$HOME/.i3/config" and
then runs sed scripts that perform in-place replacement of any
magic comments with the contents of the files they reference.
These "cfg" files live in "i3-config.d':

- cfg00 - Classic bindings
- cfg01 - Numpad bindings
- cfg02 - Cluster bindings.
- cfg03 - Reserved
- cfg04 - Primary bindings
- cfg05 - Secondary bindings
- cfg06 - Reserved
- cfg07 - Settings (non-executable)
- cfg08 - Settings (executable)
- cfg09 - Settings (i3bar, debug mode)

There's nothing to stop competent users editing "cfg" files, and this
is to be encouraged, but don't forget measures to prevent overwriting
by 'git pull'.

I concede that the decisions about the contents of each "cfg" file
will need reviewing, so "i3-config" won't become stable in git
overnight. Eggs, omelettes.

## Three modes, one key to bind them

In addition to "default" mode, this config adds Primary and Secondary
modes. There are other modes, like resize, but they aren't essential.
The Menu key cycles round the three essential modes :

    default -> Primary -> Secondary -> default

and the spacebar goes back to default.

## Primary mode
This mode does much the same as default mode.  The difference is the
difference between emacs and vi, modifiers versus modes, two handed
versus one handed. Easier for people with PD.

## Secondary mode
This mode is used for settings. It's quite sparse, which may help
laptop users.

## Mode and modifier symmetry
The left Windows key behaves like Menu when pressed solo and Super_L
when modifying another key, thanks to "xcape".  It's important for
accessibility to have both behaviours avaiiable on either side.  Both
Alt keys are mapped to Escape when used solo; it follows that Win and
Alt can be swapped as some users prefer.

## Mode indication
When not in default mode  the word Primary or Secondary is shown on a
tab next to the workspace tabs. The same word  appears on the title bar
of the currently focused window.  You can change focus and the name
follows.  If that's not enough, the screen dims slightly in Primary
mode and a little bit more for Secondary mode.

## Command prompt
The command prompt is a dmenu. It is invoked with one of the key
sequences {Menu, Tab}, or {Menu, backslash} when the layout makes it
comfortable.  It then reads two characters, and forwards them to the
"i3-filewatcher" script (q.v.).

The command prompt can also be invoked by KP_Insert, which configures
the numpad to read in two or three digits, and as before, forwards
them to the "i3-filewatcher" script..

Both methods timeout after four seconds and send a key event
equivalent to pressing Enter (Return). My PD makes the delay
acceptable and the automatic Enter key appreciated.
The delay is implemented wth sleep() and configurable.
The Enter key automation can be disabled.

## Tasker, AutoVoice, AutoTools, AutoShare
Tasker is a popular android application that lets users write programs
to run on their phone or tablet. AutoVoice is a Tasker plugin for
speech-to-text. AutoTools is a Tasker plugin that provides "ssh".
AutoShare lets you share (for example) a link from a TV EPG so you can
play the show on your PC.

## File Watcher
The file watcher watches the file "/dev/shm/$USER/i3/command".
Whenever the command prompt or Tasker writes a command to that file,
the command is forwarded to the dispatcher for processing.  There is
no acknowledgement for commands.

## Dispatcher
The dispatcher receives a command sent by the file watcher, and uses
pattern matching to invoke command-specific scripts.

## Focus App By Alias.
A command alias typically consists of two characters that refer to a
command and its parameters. Typing the command alias switches to the
running application, launching it if not already running.

This looked easy but the implementation has required the "Window
Change Monitor". This is an i3-msg subscription to window events and a
monitor that marks the focused window with the workspace name.

There should be only one window per output marked with the name of the
workspace. Two marks with the same name on the same workspace is a
major bug. Zero marks is a minor bug because the system usually
recovers.

Note: This wasn't easy to get working, and strictly speaking it still
doesn't work immediately after startup, but two or three window events
let it settle down.

## Launcher
The launcher starts and stops media playback from files or tvheadend
streams.

## Transcribe
This is a niche feature, speech to text, that just happens to be
important for EllaTheCat.

On the phone, saying "OK Google" triggers speech to text. The
resulting lowercase text is written to the File Watcher via the ssh
conection just like commands are. Eventually punctuated text appears
in an Emacs buffer "Clipboard".

Work is in progress to provide a simple editor operated by voice.

## Services
The "i3-config-scripts" file tidies up the management of "services"
that run in the background. It is introduced at the very end of the
i3-coonfig file.

    i3-config-scripts \
        start|stop|restart|status compton|dunst|marks|commands

Crikey it's fast! The effort involved in creating a tidy script has
paid off.
