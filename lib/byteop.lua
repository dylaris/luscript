local byteop = {}

local function check(little_endian, bytes, bytes_len)
  if type(little_endian) ~= "boolean" then
    return false
  end
  if type(bytes) ~= "table" then
    return false
  end
  if bytes_len and #bytes ~= bytes_len then
    return false
  end

  for i = 1, #bytes do
    local b = bytes[i]
    if type(b) ~= "number" or b < 0 or b > 255 then
      return false
    end
  end
  return true
end

function byteop.to_u16(bytes, little_endian)
  little_endian = little_endian ~= nil and little_endian or true
  if not check(little_endian, bytes, 2) then
    return
  end

  if little_endian then
    return (bytes[2] << 8) | bytes[1]
  else
    return (bytes[1] << 8) | bytes[2]
  end
end

function byteop.to_u32(bytes, little_endian)
  little_endian = little_endian ~= nil and little_endian or true
  if not check(little_endian, bytes, 4) then
    return
  end

  if little_endian then
    return (bytes[4] << 24) | (bytes[3] << 16) | (bytes[2] << 8) | bytes[1]
  else
    return (bytes[1] << 24) | (bytes[2] << 16) | (bytes[3] << 8) | bytes[4]
  end
end

function byteop.to_u64(bytes, little_endian)
  little_endian = little_endian ~= nil and little_endian or true
  if not check(little_endian, bytes, 8) then
    return
  end

  if little_endian then
    return (bytes[8] << 56) | (bytes[7] << 48) |
         (bytes[6] << 40) | (bytes[5] << 32) |
         (bytes[4] << 24) | (bytes[3] << 16) |
         (bytes[2] <<  8) | bytes[1]
  else
    return (bytes[1] << 56) | (bytes[2] << 48) |
         (bytes[3] << 40) | (bytes[4] << 32) |
         (bytes[5] << 24) | (bytes[6] << 16) |
         (bytes[7] <<  8) | bytes[8]
  end
end

function byteop.to_string(bytes)
  if not check(true, bytes) then
    return
  end

  local arr = {}
  for i = 1, #bytes do
    arr[i] = string.format("\\x%02x", bytes[i])
  end
  return table.concat(arr)
end

return byteop
