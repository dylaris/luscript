local byteop = {}

local function check(little_endian, bytes, bytes_len)
    if type(little_endian) ~= "boolean" then return false end
    if type(bytes) ~= "table" then return false end
    if bytes_len and #bytes ~= bytes_len then return false end
    return true
end

function byteop.to_u16(little_endian, bytes)
    if not check(little_endian, bytes, 2) then return end

    if little_endian then
        return (bytes[2] << 8) | bytes[1]
    else
        return (bytes[1] << 8) | bytes[2]
    end
end

function byteop.to_u32(little_endian, bytes)
    if not check(little_endian, bytes, 4) then return end

    if little_endian then
        return (bytes[4] << 24) | (bytes[3] << 16) | (bytes[2] << 8) | bytes[1]
    else
        return (bytes[1] << 24) | (bytes[2] << 16) | (bytes[3] << 8) | bytes[4]
    end
end

function byteop.to_u64(little_endian, bytes)
    if not check(little_endian, bytes, 8) then return end

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

function byteop.to_string(little_endian, bytes)
    if not check(little_endian, bytes) then return end

    local array = {}
    for i = 1, #bytes do
        array[#array+1] = string.format("\\x%02x", bytes[i])
    end

    if little_endian then
        for i = 1, math.floor(#bytes/2) do
            local left = i
            local right = #bytes - i + 1
            local tmp = array[left]
            array[left] = array[right]
            array[right] = tmp
        end
    end

    return table.concat(array)
end

return byteop
