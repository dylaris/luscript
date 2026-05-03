local Reader = {}
Reader.__index = Reader

local function read_file(filename)
  local file, err = io.open(filename, "rb")
  assert(file, "open file failed: " .. tostring(err))

  local data = file:read("*a")
  file:close()

  local bytes = {}
  for i = 1, #data do
    bytes[i] = string.byte(data, i)
  end
  return bytes
end

function Reader.new(arg)
  local obj = setmetatable({}, Reader)
  obj.offset = 0

  if type(arg) == "table" then
    obj.bytes = arg
  elseif type(arg) == "string" then
    obj.bytes = read_file(arg)
  else
    obj.bytes = {}
  end

  return obj
end

function Reader:reset()
  self.offset = 0
end

function Reader:seek(pos)
  if pos < 0 then
    pos = 0
  end
  local max = #self.bytes
  if pos > max then
    pos = max
  end
  self.offset = pos
end

function Reader:move(n)
  self:seek(self.offset + n)
end

function Reader:read(size)
  if not size or size <= 0 or self.offset >= #self.bytes then
    return nil
  end

  local remain = #self.bytes - self.offset
  if size > remain then
    size = remain
  end

  local res = {}
  for i = 1, size do
    res[i] = self.bytes[self.offset + i]
  end

  self.offset = self.offset + size
  return res
end

return Reader
