import 
  os, streams, strutils

var
  configFolder = getHomeDir() / ".config/bg-manager"
  configFile = configFolder/"config"
  
#Creates config file
proc createConfig():void =
  #if config file dosent exist, create it
  discard existsOrCreateDir(configFolder)

  #make sure the config file dosent exists before writing to it.
  if fileExists(configFile):
    return
  
  writeFile(configFile, "# BG-Manager config")
  echo "Config file Created"
    
proc readConfig():void =
  #makes sure the config file exists
  if not fileExists(configFile):
    createConfig()
    return

  var
    strm = newFileStream(configFile, fmRead)
    line = ""

  if isNil(strm):
    return

  while strm.readLine(line):
    if not startsWith(line, "#") and strip(line).len() > 0:
      var confLine: seq[string] = split(strip(line), '=',2)

      case strip(confLine[0]):
        of "testVar":
          echo confLine[1]

      
    
  strm.close()