local lfs = require("lfs")

-- get current directory
local current_dir = lfs.currentdir()
print("current directory: " .. current_dir)

-- list all files and sub directories in current directory
for file in lfs.dir(".") do
    if file ~= "." and file ~= ".." then
        print(file)
    end
end

-- get the attribute of file
local attr = lfs.attributes("count_words.lua")
if attr then
    print("Type: " .. attr.mode)
    print("Size: " .. attr.size)
    print("Last modified: " .. os.date("%c", attr.modification))
else
    print("File not found")
end

-- create a directory
local success, err = lfs.mkdir("new_dir")
if success then
    print("Directory created successfully.")
else
    print("Failed to create directory: " .. err)
end

-- delete empty directory
success, err = lfs.rmdir("new_dir")
if success then
    print("Directory removed successfully.")
else
    print("Failed to remove directory: " .. err)
end

-- traverse a directory
local function traverse_dir(dir)
    for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
            local path = dir .. "/" .. file
            local attr = lfs.attributes(path)
            if attr.mode == "directory" then
                print("Directory: " .. path)
                traverse_dir(path)
            else
                print("File: " .. path)
            end
        end
    end
end

traverse_dir(".")

