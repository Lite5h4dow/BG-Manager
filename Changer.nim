#-----------------------------------------------------
#Background AutoChanger (Designed for Arch Linux)
#For i3 (might work with other stuff)
#By Lamar "Tony" Daughma
#-----------------------------------------------------

import osproc
import os
import ospaths
import sequtils
import strutils
import random
import parseopt

#Sets ~/wallpaper folder as default target
let source = getHomeDir()/"Wallpapers"

if not existsDir(source) : #Makes Sure the folder is there
  createDir(source) #Makes it if it isnt

let wallpapers = toSeq(walkDir(source)) #Makes a Sequence containing the paths of all images in the folder
var
  target: string #Makes string variable to use later to contain the appended terminal instruction
  parse = initOptParser("") #Gets Commandline Arguments(--long -s)
  time:int=1 #makes time length variable(default 1[min])= 1

#placeholder help
proc help():void =
  echo("bannannanna batman :P")

#arg management:
for kind, key, val in parse.getopt(): #seperates the arguments in to their individual
  case kind #manages the kind of arguments it can handle.
  of cmdLongOption, cmdShortOption: #your normal --long -s <short> args
    case key #takes the Key to run their respective instructions
    of "time","t": #time Arg
      time = parseInt(val)
    of "help","h": #help Dialogue, ill have learn how to make one now -_-
      help()
  of cmdEnd: assert(false) #Makes sure nothing funky happens (idfk what this does yet, seems pretty vital tho)
  else: #if anyone sees this, they done fucked up.
    echo("idfk something went wrong man.")
    help()



while true: #starts main loop
  randomize() #makes sure the random int is refreshed
  target ="feh --bg-scale "&wallpapers[random(high(wallpapers))].path #appends full terminal instruction to "target"
  discard execProcess(target)
  #runs the terminal command (Note execProcess will try to return something, we dont need it so we use discard to run the function and get rid of the pesky result, it will cause an error otherwise)
  sleep(time*60000) #sleeps for a while (1min by default, might change it)
