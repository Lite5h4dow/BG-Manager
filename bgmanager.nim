#[
  -----------------------------------------------------
  Background Manager V4 (Designed for Arch Linux)
  For i3 (might work with other stuff)
  By Lamar "Tony" Daughma
  -----------------------------------------------------
]#

import
  osproc, os, sequtils, strutils, random, parseopt, streams

include 
  displayImg, config

#Sets ~/wallpaper folder as default target
let 
  source = getHomeDir() / "Wallpapers"
  wallpapers = toSeq(walkDir(source))

discard existsOrCreateDir(source)

var
  parse = initOptParser("") # Gets commandline arguments(--long -s)
  time = 1 # Default time to switch between wallpapers


# Placeholder help
proc help():void =
  echo("bannannanna batman :P \nWorking Help Diag Incoming")


# Argument management:
# Parses all command-line arguments
for kind, key, val in parse.getopt():
  # Manages the kind of arguments it can handle.
  case kind
  # Your normal --long -s <short> args
  of cmdLongOption, cmdShortOption:
    # Does different things dependind on value of `key`
    case key
    # Time argument
    of "time", "t":
      time = parseInt(val)
    # Help dialogue, I'll have to learn how to make one now -_-
    of "help", "h":
      help()
    # Single image tool (for those that just want one image, idk why you need this but its here)
    of "single", "s":
      singleImg(val, wallpapers)
    # Random image tool
    of "random", "r":
      randomImg(if val == "": time else: parseInt(val), wallpapers)
    # Lists all images that it can display
    of "list", "l":
      listSrc(wallpapers)
    #runs initialise system
    of "init", "initialise", "i":
      discard existsOrCreateDir(source)
    #runs the config creation
    of "config","c":
      createConfig()
    #If no option supplied
    of "normal", "n", "":
      readConfig()


  # We don't need cmdArgument and cmdEnd indicates that end of command line reached/
  of cmdArgument, cmdEnd: assert(false)