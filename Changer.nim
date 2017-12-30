#-----------------------------------------------------
#Background Manager V3 (Designed for Arch Linux)
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

proc randomImg():void=
  while true: #starts main loop
    randomize() #makes sure the random int is refreshed
    target ="feh --bg-scale "&wallpapers[random(high(wallpapers))].path #appends full terminal instruction to "target"
    discard execProcess(target)
    #[
    runs the terminal command (Note execProcess will try to return something, we dont need it so we use discard to run 
    the function and get rid of the pesky result, it will cause an error otherwise)
    ]#
    sleep(time*60000) #sleeps for a while (1min by default, might change it)

proc listSrc():void= #this litterally just lists all the files.
  var itter:int #makes a counter we can use
  for item in wallpapers: #just goes through every item in wallpapers sequence
    itter += 1 #adds one to the counter
    echo intToStr(itter)&": " & extractFilename(item.path) # numbers each entry and prints it to terminal (E.G 1: file.png)

proc singleImg(i:string):void=
  #[
  Here is the idea for single mode. since i have already have a file system i can use it for name tests. so here is the psuedo code:

  see if user has given a file name with the argument.
    if no argument is given it will list all the images
    you can select onw with a number
  if a file name is given, it will test the name and then it will display that image.
  if the file name fails to be recognised then it will act as if there was no image given.
  ]#

  block search: #creates block so if we find the image we need, we can GTFO before starting the manual search
    var loop : bool = true
    for img in wallpapers: # for loop to start testing vs the sequence
      if i == extractFilename(img.path): #checks to see if the given arguments value is in the list of files in the
        discard(execProcess("feh --bg-scale "&img.path)) #10/10 IGN,image found and changing to selection
        break search #GTFO before the manual search starts
    while loop: #just incase the user changes thier mind
      listSrc() #lists all the images and numbers them fore selection
      echo "enter input: "
      var
        input = readLine(stdin) #Gets Selection
        selection = parseInt(input) - 1 #converts string to int then subtracts one since we added 1 during the count in listSrc()
      echo "you sure?[Y/n]: "
      var confirm = readLine(stdin) #gets conformation
      case toLowerAscii(confirm): #makes it all lowercase, saves us going thorough all versions
        of "","y","yes": #in case of yes
          discard(execProcess("feh --bg-scale "&wallpapers[selection].path)) #sets the selected wallpaper
          break search #GTFO
        of "n","no": #in case of no
          echo"alrighty, Exiting."
          break search #Just GTFO
        else:
          loop = true


#arg management:
for kind, key, val in parse.getopt(): #seperates the arguments in to their individual
  case kind #manages the kind of arguments it can handle.
  of cmdLongOption, cmdShortOption: #your normal --long -s <short> args
    case key #takes the Key to run their respective instructions
    of "time","t": #time Arg
      time = parseInt(val)
    of "help","h": #help Dialogue, ill have learn how to make one now -_-
      help()
    of "single","s": #single Image tool (for those that just want one image, idk why you need this but its here)
      singleImg(val)
    of "random","r": #random image tool
      randomImg()
    of "list", "l": #lists all images that it can display
      listSrc()
  of cmdEnd: assert(false) #Makes sure nothing funky happens (idfk what this does yet, seems pretty vital tho)
  else: #if anyone sees this, they done fucked up.
    echo("idfk something went wrong man.")
    help()
