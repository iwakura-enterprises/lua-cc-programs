-- Updater 0.1
-- Made by Iwakura Enterprises
--  // Made for CC: Tweaked //
-- Updates the Iwakura Enterprises software on the local machine.
--

local iwakuraSoftwarePath = "/iwakura/software"
local programRepository = "https://data.mayuna.dev/lua/"

local programName = arg[1]
local shouldInstall = arg[2] == "install"

-- check if /iwakura/software exists
if not fs.exists(iwakuraSoftwarePath) then
  print("Error: /iwakura/software directory does not exist.")
  return
end

-- check if /iwakura/software is a directory
if not fs.isDir(iwakuraSoftwarePath) then
  print("Error: /iwakura/software is not a directory.")
  return
end

-- check if programName is set
if not programName then
  print("Error: No program name set.")
  return
end

-- check if .lua extension is set
if not programName:match("%.lua$") then
  programName = programName .. ".lua"
end

local programFilePath = iwakuraSoftwarePath .. "/" .. programName

-- check if programName is a valid file
if not fs.exists(programFilePath) and not shouldInstall then
  print("Error: Program " .. programFilePath .. " does not exist.")
  return
end

-- Download the program
local response = http.get(programRepository .. programName)

if not response then
  print("Error: Could not download file " .. programRepository .. programName)
  return
end

if fs.exists(programFilePath) then
  fs.delete(programFilePath)
end

-- create new file
local file = fs.open(programFilePath, "w")
if not file then
  print("Error: Could not create file " .. programFilePath)
  response.close()
  return
end

-- write file
local data = response.readAll()
file.write(data)
file.close()
response.close()

print("File " .. programFilePath .. " downloaded from " .. programRepository .. programName)

if programName == "bootmanager.lua" then
  print("Installing BootManager...")
  local startupFilePath = "/startup"
  if fs.exists(startupFilePath) then
    print("Deleting old startup file...")
    fs.delete(startupFilePath)
  end

  -- copy /iwakura/software/bootmanager.lua to /startup
  fs.copy(programFilePath, startupFilePath)
  print("BootManager installed.")
end