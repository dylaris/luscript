-- Binary reader

local Reader = {}
Reader.__index = Reader

local function read_file(filename)
    local file = assert(io.open(filename, "rb"))
    local byte_string = file:read("a")
    io.close(file)
    local bytes = {}
    for i = 1, #byte_string do
        bytes[#bytes+ 1] = string.byte(byte_string, i)
    end
    return bytes
end

function Reader:new(arg)
    local obj = {}
    setmetatable(obj, self)

    if type(arg) == "table" then
        -- raw bytes
        obj.bytes = arg
    elseif type(arg) == "string" then
        -- filename
        obj.bytes = read_file(arg)
    else
        obj.bytes = {}
    end
    obj.offset = 0

    return obj
end

function Reader:read(size)
    if size <= 0 or self.offset >= #self.bytes then return nil end

    if self.offset+size > #self.bytes then
        size = #self.bytes - self.offset
    end

    local read_bytes = {}
    for i = 1, size do
        read_bytes[i] = self.bytes[i+self.offset]
    end
    self.offset = self.offset + size

    return read_bytes
end

return Reader
