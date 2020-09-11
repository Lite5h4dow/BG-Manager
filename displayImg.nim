import 
  osproc, os, strutils, random

var mode : seq[string] = @["--bg-scale ", "--bg-tile "]

type filePath = tuple[kind:PathComponent, path:string]

proc listSrc(wallpapers:seq[filePath]):void =
  var counter : int
  for i in wallpapers:
    counter += 1
    echo intToStr(counter) & ": " & i.path

proc singleImg(i: string, wallpapers: seq[filePath]):void =
  if i == "":
    listSrc(wallpapers)
    while true:
      echo "Select an image (1-" & intToStr(high(wallpapers) + 1) & "): "
      var select = readLine(stdin)
      if parseInt(select) - 1  < high(wallpapers) :
        discard execProcess("feh " & mode[0] & wallpapers[parseInt(select) - 1].path)
        break
      else:
        echo "Please a Valid Entry"

  else:
    if parseInt(i) - 1 < high(wallpapers) :
      discard execProcess("feh " & mode[0] & wallpapers[parseInt(i) - 1].path)
    else:
      echo "selection invalid"


proc randomImg(timer: int, wallpapers: seq[filePath]):void =
  echo wallpapers
  if wallpapers.len <= 0:
    echo "no images in directory"
    return

  while true:
    randomize()
    var r = rand(high(wallpapers))
    var index = 
      if r < 0:
        0 
      elif r > (wallpapers.len() - 1): 
        (wallpapers.len() - 1)
      else: r
    var selection = wallpapers[index]
    discard execProcess("feh " & mode[0] & selection.path)
    sleep(timer * 60000)