package.cpath = "3rdparty/?.so;" .. package.cpath
local lfs = require "lfs"

if not arg[1] then
    print("./lisk.lua [DIR]")
    return
end

local function format_size(bytes)
    local units = { "B", "KB", "MB", "GB", "TB" }
    local unit_index = 1
    local size = bytes
    while size >= 1024 and unit_index < #units do
        size = size / 1024
        unit_index = unit_index + 1
    end
    if size == math.floor(size) then
        return string.format("%d%s", size, units[unit_index])
    else
        return string.format("%.2f%s", size, units[unit_index])
    end
end

local dir = arg[1]
local option = arg[2]

local kvs = {}

local function collect(dir)
    for filename in lfs.dir(dir) do
        if filename ~= "." and filename ~= ".." then
            local filepath = dir .. "/" .. filename
            local attr = lfs.attributes(filepath)
            table.insert(kvs, { path = filepath, name = filename, size = attr.size })
            if attr.mode == "directory" then collect(filepath) end
        end
    end
end

collect(dir)

table.sort(kvs, function (a, b)
    return a.size > b.size
end)

local sum_size = 0

local str = ""

for _, kv in ipairs(kvs) do
    str = str .. string.format("\n%-" .. 10 .. "s %s", format_size(kv.size), kv.path)
    sum_size = sum_size + kv.size
end

print("[cwd: " .. dir .. "]")
print("[num: " .. #kvs .. "]")
print("[sum: " .. format_size(sum_size) .. "]")
print(str)
