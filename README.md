Emacs Powerpack README -- Currell Berry -- 9/15/2015
=================================================

Emacs Powerpack is an installer which bundles Emacs+MingW+Msys+Some optional default configurations for emacs.  The goal of emacs powerpack is to make it as easy as possible to set up a productive emacs-based development environment on a windows computer.
It is intended to get users up and running with emacs and a unix-like environment on windows as quickly as possible.

Download v0.2 alpha
-------------------------------------------------------------------
 
[Download link](https://mega.nz/#!J81CVaSR!DhVTulh0PsurA7S7NgLaKuZsKSaDsr_jvXOly3OsifM)

What Emacs Powerpack Does
-------------------------------------------------------------------
Once Emacs Powerpack is installed, several things should be accomplished for you:

1. You can type "emacs" in the start menu to find and launch emacs.
2. You can type "msys" in the start menu to find and launch msys, a bash shell configured for windows.
3. Context menus should have an "open with emacs" option.
4.  MinGW commands (gcc, gdb, etc...) should be available from cmd.
5. In addition to the msys-included shell commands such as find, grep, awk, sed, sh, gcc, gdb, etc..., you should have a selection of additional commands taken from ez-windows-ports which are chosen to provide additional useful/commonly-used unix functionality.
    1. man + man pages
        1. allows you to use M-x man just like you would on Linux.
    2. Emacs preconfigured with Msys as default shell.
    3. evil configuration? ;)
    4. more to come...
6. MinGW is added to PATH
7. Msys is added to path.
 
In summary, every piece of OS-provided functionality (examples are M-x man, M-x grep, M-x find, M-x shell) described in the Emacs manual should work exactly as advertised. 

This allows you to just work in emacs, and not worry about having windows underneath.

Installation Directions
---------------------------------------------------------------------
Which scenario are you?

1. I have not installed emacs or mingw on my system.
    Just download emacs powerpack and run the installer.  Emacs Powerpack will install both emacs and mingw for you.  Fire up emacs and everything, including os-provided features such as grep, sed, and find, should work as described in the emacs manual.

2. I am already using either emacs or mingw or both on my system.
    1. Emacs is among the programs I am already using:
        1. When you run emacs_powerpack installer, a new instance of emacs will be installed into program files.  Your preexisting .emacs file (if you have one) will not be touched.  Instead, emacs_powerpack will write a .emacs.sample file, which we suggest you take a look at. 
    2. MinGW is among the programs I am already using:
        1. Emacs powerpack installs MinGW at C:\MinGW.  If you have a preexisting instance of MinGW there, it will be overwritten by (merged with technically) this new one.  
	 
Notes
---------------------------------------------------------------------
In certain edge cases, you may have to restart windows before changes to PATH take effect.

Note that if "open with emacs" ever stops working it's probably because the .emacs.d/server/server file has gotten out of date (windows uses tcp to manage emacsclient connections, this is less robust than the method used on unix/linux.).  I have seen this occur when the computer crashes with emacs still running.  Delete the server file and try again.

