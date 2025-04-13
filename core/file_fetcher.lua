-- File Fetcher 0.1
-- Made by Iwakura Enterprises
--  // Made for CC: Tweaked //
-- Fetches files from a remote server and updates them on the local machine.
--

-- take the URL from the command line
local prefixUrl = "https://data.mayuna.dev/lua/"
local urlOrFileName = arg[1]
local dest = arg[2]
local shouldRun = false

-- check if only the first variable is set
if urlOrFileName and not dest then
  -- check if urlOrFileName ends with !
  if urlOrFileName:sub(-1) == "!" then
    -- remove the last character
    urlOrFileName = urlOrFileName:sub(1, -2)
    shouldRun = true
  end

  dest = urlOrFileName
  urlOrFileName = prefixUrl .. urlOrFileName
end

if not urlOrFileName or not dest then
  print("Usage: file_fetcher <url> <dest>")
  return
end

-- delete old file
if fs.exists(dest) then
  fs.delete(dest)
end

-- download file
local response = http.get(urlOrFileName)

if not response then
  print("Error: Could not download file " .. urlOrFileName)
  return
end

-- create new file
local file = fs.open(dest, "w")
if not file then
  print("Error: Could not create file " .. dest)
  response.close()
  return
end

-- write file
local data = response.readAll()
file.write(data)
file.close()
response.close()

print("File " .. dest .. " downloaded from " .. urlOrFileName)

if shouldRun then
  -- run the file
  local program = shell.resolveProgram(dest)
  if program then
    shell.run(program)
  else
    print("Error: Could not run file " .. dest)
  end
end