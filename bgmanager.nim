#[
  -----------------------------------------------------
  Background Manager V3 (Designed for Arch Linux)
  For i3 (might work with other stuff)
  By Lamar "Tony" Daughma
  -----------------------------------------------------
]#

import osproc
import os
import ospaths
import sequtils
import strutils
import random
import parseopt

randomize()


#Sets ~/wallpaper folder as default target
let source = getHomeDir() / "Wallpapers"

proc initialise() =
  if not existsDir(source):
    createDir(source)

initialise()

let wallpapers = toSeq(walkDir(source))

var
  parse = initOptParser("") # Gets commandline arguments(--long -s)
  time = 1 # Default time to switch between wallpapers

# Placeholder help
proc help() =
  echo("bannannanna batman :P")

proc randomImg() =
  while true:
    # Constructs our command
    let target = "feh --bg-scale " & wallpapers[rand(high(wallpapers))].path 
    # Runs the terminal command. Note that execProcess returns command output 
    # and we don't need it so we use discard.
    discard execProcess(target)
    # Sleeps for a while (1min by default, might change it)
    sleep(time * 60000)

proc listSrc() =
  var itter: int
  for item in wallpapers:
    itter += 1
    # Numbers each entry and prints it to terminal (E.G 1: file.png)
    echo $itter, ": ", extractFilename(item.path)

proc singleImg(i: string) =
  ##[
  Here is the idea for single mode. Since I have already have a file system I
  can use it for name tests. So here is the pseudo code:
  See if user has given a file name with the argument.
    If no argument is given it will list all the images
    you can select own with a number
  If a file name is given it will test the name and then it will display that image.
  If the file name fails to be recognised then it will act as if there was no image given.
  ]##

  var loop = true
  for img in wallpapers:
    # Checks to see if the given arguments value is in the list of files
    if i == extractFilename(img.path):
      # 10/10 IGN,image found and changing to selection
      discard(execProcess("feh --bg-scale "&img.path))
      return
  
  while loop:
    loop = false
    listSrc()
    echo "Please enter your selection: "
    # Gets user selection and converts it to int
    var selection = parseInt(readLine(stdin)) - 1
    echo "Are you sure? [Y/n]: "
    var confirm = readLine(stdin)
    case toLowerAscii(confirm):
      of "", "y", "yes":
        # Sets the selected wallpaper
        discard(execProcess("feh --bg-scale " & wallpapers[selection].path))
      of "n", "no":
        echo "Alrighty, exiting."
      else:
        # Ask for confirmation again
        loop = true

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
      singleImg(val)
    # Random image tool
    of "random", "r", "":
      randomImg()
    # Lists all images that it can display
    of "list", "l":
      listSrc()
    of "init", "initialise", "i":
      initialise()
  # We don't need cmdArgument and cmdEnd indicates that end of command line reached
  of cmdArgument, cmdEnd: assert(false)

help()
