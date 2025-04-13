-- Setup 0.1
-- Made by Iwakura Enterprises
--  // Made for CC: Tweaked //
-- Sets up the computer for use with the Iwakura Enterprises software.
--

local reinstall = arg[1] == "reinstall"
local skipReboot = arg[2] == "skip_reboot"

local iwakuraSoftwarePath = "/iwakura/software"
local startupFilePath = "/startup";
local programRepository = "https://data.mayuna.dev/lua/"

print("Setup 0.1")
print("Made by Iwakura Enterprises")
print("")
print("Reinstalling: " .. tostring(reinstall))
print("")
print("Checking out file system...")

-- check if /iwakura exists
if not fs.exists("/iwakura") then
  print("Creating /iwakura directory...")
  fs.makeDir("/iwakura")
else
  print("/iwakura directory already exists.")
end

-- check if /iwakura/software exists

if not fs.exists(iwakuraSoftwarePath) then
  print("Creating " .. iwakuraSoftwarePath .. " directory...")
  fs.makeDir(iwakuraSoftwarePath)
else
  print(iwakuraSoftwarePath .. " directory already exists.")
end

-- check if reinstall
if reinstall then
  print("Reinstalling software...")

  -- delete all files in /iwakura/software
  local softwareDir = fs.list(iwakuraSoftwarePath)
  for _, file in ipairs(softwareDir) do
    if not fs.isDir(iwakuraSoftwarePath .. "/" .. file) then
      print("Deleting file: " .. file)
      fs.delete(iwakuraSoftwarePath .. "/" .. file)
    end
  end
end

-- Modify shell.path
print("Modifying shell.path...")
local shellPath = shell.path()
local newShellPath = shellPath .. ":" .. iwakuraSoftwarePath
shell.setPath(newShellPath)

-- Install programs
print("Installing programs...")

-- list of program names
local programs = {
  "file_fetcher.lua",
  "setup.lua",
  "updater.lua",
  "bootmanager.lua"
}

-- download each program
for _, program in ipairs(programs) do
  local url = programRepository .. program
  local dest = iwakuraSoftwarePath .. "/" .. program

  -- check if file exists
  if fs.exists(dest) and not reinstall then
    print("File " .. dest .. " already exists. Skipping...")
    goto continue
  end

  -- download file
  local response = http.get(url)

  if not response then
    print("Error: Could not download file " .. url)
    goto continue
  end

  -- check if file exists and delete it
  if fs.exists(dest) then
    print("Deleting file " .. dest .. "...")
    fs.delete(dest)
  end

  -- create new file
  local file = fs.open(dest, "w")
  if not file then
    print("Error: Could not create file " .. dest)
    response.close()
    goto continue
  end

  -- write file
  local data = response.readAll()
  file.write(data)
  file.close()
  response.close()

  print("File " .. program .. " installed.")
  ::continue::
end

-- Install bootmanager
print("Installing BootManager...")
if fs.exists(startupFilePath) then
  if not reinstall then
    print("Startup file already exists and not reinstalling! Skipping...")
  else
    print("Deleting old startup file...")
    fs.delete(startupFilePath)
  end
end

-- copy /iwakura/software/bootmanager.lua to /startup
local bootManagerFile = fs.open(iwakuraSoftwarePath .. "/bootmanager.lua", "r")
if not bootManagerFile then
  print("Error: Could not open file " .. iwakuraSoftwarePath .. "/bootmanager.lua")
  return
end
local startupFile = fs.open(startupFilePath, "w")
if not startupFile then
  print("Error: Could not create file " .. startupFilePath)
  bootManagerFile.close()
  return
end
local data = bootManagerFile.readAll()
startupFile.write(data)
startupFile.close()
bootManagerFile.close()

print("BootManager installed.")
print("Please, specify the startup program in /autoexec.info")

-- Finish setup
print("Setup complete.")

if not skipReboot then
  print("Reboot?")
  local shouldReboot = read()

  if shouldReboot == "y" or shouldReboot == "Y" then
    print("Rebooting...")
    os.reboot()
  end
end

print("Exiting setup...")
