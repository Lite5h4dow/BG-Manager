import 
  osproc, os, strutils, random

var mode : seq[string] = @["--bg-scale ", "--bg-tile "]

proc listSrc(wallpapers:seq[tuple[kind:PathComponent, path:string]]):void =
  var counter : int
  for i in wallpapers:
    counter += 1
    echo intToStr(counter) & ": " & i.path

proc singleImg(i: string, wallpapers: seq[tuple[kind:PathComponent, path:string]]):void =
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


proc randomImg(timer: int, wallpapers: seq[tuple[kind:PathComponent, path:string]]):void =
  while true:
    randomize()
    discard execProcess("feh " & mode[0] & wallpapers[rand(high(wallpapers))].path)
    sleep(timer * 60000)