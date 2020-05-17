# dopamine-2020 - Customising the i3 tiling window manager.

## What's in the repository?

This repository consists of the config and scripts i'm using with i3
 4.18.1 on Xubuntu 20.04 LTS.

The config file is almost 100% compatible with the standard i3
keybindings/ You can install it and be able to use i3 immediately.

- At the moment (May 2020) the repo is just an offsite backup for code
  refactoring that started back in ISO week 18 when 20.04 LTS appeared.
  I expect  things tol be stable by  ISO week 23 (1st June 2020).
h
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

## Make
- Install the "GNU make" package provided by your Linux distro.
- Run "make" from within the dopamine-2020 directory;
this deploys the config and script files stored there.

In more detail, "make"
copies files from  the dopamine-2020  directory to the standard places,
modifies the copies with your customisations,
sets the file permissions,
runs the i3 config reload and
i3 window manager restart commands,
but **only** when necessary.

## Classic default mode bindings
By default, the i3 config file includes a set of $mod+keysym bindings
corresponding to the bindings described in the i3 User's Guide.  I
realised that without these, a user would struggle to use i3, and
hence would not persevere with their evaluation.

Conversely, I find modifier+key bindings difficult, and don't want to
operate them accidentally, so I'd prefer to remove them.

## Building a custom i3 config
Consider the "cfg" files in the dopamine-2020 directory.  For example,
cfg00 has  the "classic default mode" bindings,
cfg01 has "numeric keypad" bindings.

Looking at i3scripts/i3-config you'll see several "magic comments":

    ###INSERT_GFG00_HERE###
    ###INSERT_GFG01_HERE###

The Makefille first deploys "i3-config"  as "$HOME/.i3/config" and
then runs sed scripts that perform in-place replacement of any
magic comments with the contents of the files they reference.

There's nothing to stop competent users editing "cfg" files, and this
is to be encouraged. Use ".git/info/exclude" to prevent overwriting.

## Three modes, one key tobind them
