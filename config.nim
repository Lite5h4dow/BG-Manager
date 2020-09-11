import 
  os, streams, strutils, strformat

var
  configFolder = getHomeDir() / ".config"/"bg-manager"
  configFile = configFolder/"config"

type Mode = enum 
  randSelect=(1, "random"),
  single=(2, "single"), 
  ordered=(3, "manual")

type
  Config* = object
    folderPath* : string
    imgTimer*: int
    mode*: Mode
    singleImage*: string

#Creates config file
proc createConfig():void =
  #if config file dosent exist, create it
  discard existsOrCreateDir(configFolder)

  #make sure the config file dosent exists before writing to it.
  if fileExists(configFile):
    return
  
  writeFile(configFile, "# BG-Manager config")
  echo "Config file Created"
    
proc readConfig(defaultPath: string):Config =
  #makes sure the config file exists

  var userConfig: Config = Config(
    folderPath: defaultPath,
    imgTimer: 1,
    mode: Mode.randSelect,
    singleImage: ""
  )

  if not fileExists(configFile):
    createConfig()
    return

  var
    strm = newFileStream(configFile, fmRead)
    line = ""

  if isNil(strm):
    return

  while strm.readLine(line):
    if startsWith(line, "#") or strip(line).len() == 0:
      continue

    var confLine: seq[string] = split(strip(line), '=', 2)

    if confLine.len < 2:
      echo &"BG-Manager: The Following line is invalid. '{line}' Please Update your config File. This line will be ignored"
      continue

    var value : string = strip(confLine[1])

    case strip(confLine[0]):
      of "testVar":
        echo confLine[1]

      of "bgm.folder", "folder","wallpapers":
        userConfig.folderPath = value
      
      of "bgm.timer", "timer", "delay":
        try:
          userConfig.imgTimer = parseInt(value)
        except:
          echo &"BG-Manager: '{value}' is not a valid int, ignoring."

      of "bgm.mode", "mode":
        try:
          userConfig.mode = parseEnum[Mode](value)
        except:
          echo &"BG-Manager: '{value}' is not a valid mode name, ignoring."


          
  strm.close()
  return userConfig