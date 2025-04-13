-- BootManager 0.1
-- Made by Iwakura Enterprises
--  // Made for CC: Tweaked //
-- BootManager is a program that manages the boot process of the computer.

local iwakuraSoftwarePath = "/iwakura/software"
local startupProgramNameFile = "/autoexec.info"
local isStartupFile = shell.getRunningProgram() == "startup"

if not isStartupFile then
  print("Cannot run BootManager from the command line.")
  print("Please, rename this program to startup.")
  return
end

print("BootManager 0.1")
print("Made by Iwakura Enterprises")
print("Booting...")

-- Set shell path
print("Modifying shell.path...")
local shellPath = shell.path()
local newShellPath = shellPath .. ":" .. iwakuraSoftwarePath
shell.setPath(newShellPath)

print("Checking for startup program...")

if fs.exists(startupProgramNameFile) then
  print("Startup program found.")
  local startupPrograms = {}

  -- Read the startup program names from the file
  local startupFile = fs.open(startupProgramNameFile, "r")
  if not startupFile then
    print("Error: Could not open startup program file.")
    return
  end

  -- Read each line and add it to the startup programs list
  while true do
    local line = startupFile.readLine()
    if not line then break end
    -- check if line is empty, skip it
    if line:match("^%s*$") then
      goto continue
    end
    -- check if line starts with #, skip it
    if line:sub(1, 1) == "#" then
      goto continue
    end
    table.insert(startupPrograms, line)
    ::continue::
  end

  print("Startup programs: " .. table.concat(startupPrograms, ", "))

  -- Check if the startup program exists
  for _, startupProgram in ipairs(startupPrograms) do
    -- Run the startup program
    local startupProgramHandle = shell.run(startupProgram)
    if not startupProgramHandle then
      print("Error: Could not run startup program " .. startupProgram)
    end
  end
else
  print("No autoexec.info file found.")
end