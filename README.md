# dopamine-2020 - Customising the i3 tiling window manager.

## What's in the repository?

This repository consists of the config and scripts i'm using with i3
 4.18.1 on Xubuntu 20.04 LTS.

## Disclaimers
At the moment (May 2020) the repo is just an offsite backup for code
  refactoring that started back in ISO week 18 when 20.04 LTS appeared.
  I expect to release by  ISO week 23 (1st June 2020).

## Ambitions

The config file is almost 100% compatible with the standard i3
keybindings. You can install it and be able to use i3 immediately.

The config file and scripts have "magic comments", postprocessing
directives that can, for example, select different key bindings for
one machine versus another. That's the ambition, anyway.

I greatly admire the i3 mission statement about clean code.
I'm not in their league, but I've tried to make the code modular and maintainable.
If nothing else, it's commented and documented.

## Why dopamine?

Dopamine is a chemical that functions as a neurotransmitter. I have
Parkinson's Disease ("PD") because my brain cells that make dopamine
are dying prematurely.  Lack of dopamine causes the hand and arm
tremors and the overall slowness of movement typical of Parkinson's Disease.
I've been told "dopamine" is an evocative name, so I'm re-using it.

The i3 window manager lets me address the ergonomics of a user
interface for people with PD.  I want to share both the code and

lthe lessons learned, what works and what doesn't.

I also think people without PD will find it useful.
This is the third such repository I've made.
This time, I'm hoping to make it easy for people to download and run.

## Installation
Dopamine wants to be installed anywhere beneath ${HOME}, in a
directory accessible to git.  Decide in which directory the git clone
will be done, change to that directory and  do:

git clone git@github.com:EllaTheCat/dopamine-2020.git

## "make"
- Install the GNU Make package provided by your Linux distro.
- Run "make" from within the dopamine-2020 directory;
this deploys the config and script files stored there.

In more detail, "make"
copies files from  the dopamine-2020  directory to the standard places,
modifies the copies with your customisations,
sets the file permissions,
runs the i3 config reload and
i3 window manager restart commands,
but each of these is done **only** when necessary.

## "make -n"
The "make -n" command causes the program to print out what it would do
when invoked simply as "make".  This is worth knowing because you can
see beforehand what "make" will do.

## Classic default mode bindings
By default, the i3 config file includes a set of $mod+keysym bindings
corresponding to the bindings described in the i3 User's Guide.  I
realised that without these, a user would struggle to use i3, and
hence would not persevere with their evaluation.

Conversely, I find modifier+key bindings difficult, and don't want to
operate them accidentally, so I'd prefer to remove them.

## Building a custom i3 config

Looking at i3-config you'll see several "magic comments":

    ###INSERT_GFG00_HERE###
    ###INSERT_GFG01_HERE###

The Makefile first deploys "i3-config"  as "$HOME/.i3/config" and
then runs sed scripts that perform in-place replacement of any
magic comments with the contents of the files they reference.
These "cfg" files live in "i3-config.d'.

There's nothing to stop competent users editing "cfg" files, and this
is to be encouraged. Use ".git/info/exclude" to prevent overwriting.

I concede that the decisions about the contents of each "cfg" file
will need reviewing, so "i3-config" won't become stable in git
overnight. Eggs, omelettes.

## Multiple machines, one config
Posts on /r/i3wm show there's quite a demand for this. It is going to
happen, but not at first release in June, because things need to shake
down and stabilise first. Here's how and why it works:

Before i3 starts, "make" runs. It only updates the config to tailor it
to the machine once, so most of the time "make" exits immediately and
has no inpact on startup time.

If you are nervous about running "make" at startup, I would be, the
safer way to proceed is to log out, drop to the Linux console, run
"make" and then either log in again or restart/shutdown.

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
When not in default mode  the word  Primary or Secondary is shown on a
tab next to the workspace tabs. The same word  appears on the title bar
of the currently focused window.  You can change focus and the name
follows.  If that's not enough, the screen dims slightly in Primary
mode and a lttle bit more for Secondary mode.

## Command prompt
The command prompt is a dmenu. It is invoked with the key sequence
Menu, Tab, it then reads two characters, and forwards them. It can also
be invoked by KP_Insert, which configures the numpad to read in two
 or three digits.

Both methods timeout after four seconds and send a key event
equivalent to pressing Enter (Return). My PD makes the delay
acceptable and the automatic Enter key appreciated.
The delay is  implemented wth sleep() and configurable.
The Enter key automation can be disabled.
