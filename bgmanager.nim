#[
  -----------------------------------------------------
  Background Manager V4 (Designed for Arch Linux)
  For i3 (might work with other stuff)
  By Lamar "Tony" Daughma
  -----------------------------------------------------
]#

import
  osproc, os, ospaths, sequtils, strutils, random, parseopt

#Sets ~/wallpaper folder as default target
let source = getHomeDir() / "Wallpapers"

discard existsOrCreateDir(source)

let wallpapers = toSeq(walkDir(source))

var
  mode : seq[string]
  parse = initOptParser("") # Gets commandline arguments(--long -s)
  time = 1 # Default time to switch between wallpapers
  loop = true

mode = @["--bg-scale ", "--bg-tile "]

# Placeholder help
proc help() =
  echo("bannannanna batman :P \nWorking Help Diag Incoming")

proc randomImg() =
  while true:
    randomize()
    discard execProcess("feh " & mode[0] & wallpapers[random(high(wallpapers))].path)
    sleep(time * 60000)

proc listSrc() =
  var counter : int
  for i in wallpapers:
    counter += 1
    echo intToStr(counter) & ": " & i.path

proc singleImg(i: string) =
  if i == "":
    listSrc()
    while loop == true:
      loop = false
      echo "Select an image (1-" & intToStr(high(wallpapers) + 1) & "): "
      var select = readLine(stdin)
      if parseInt(select) - 1  < high(wallpapers) :
        discard execProcess("feh " & mode[0] & wallpapers[parseInt(select) - 1].path)
      else:
        echo "Please a Valid Entry"
        loop = true
  else:
    if parseInt(i) - 1 < high(wallpapers) :
      discard execProcess("feh " & mode[0] & wallpapers[parseInt(i) - 1].path)
    else:
      echo "selection invalid"


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
      echo()
      singleImg(val)
    # Random image tool
    of "random", "r", "":
      randomImg()
    # Lists all images that it can display
    of "list", "l":
      listSrc()
    of "init", "initialise", "i":
      discard existsOrCreateDir(source)
  # We don't need cmdArgument and cmdEnd indicates that end of command line reached
  of cmdArgument, cmdEnd: assert(false)
