local MAX_WIDTH = 16

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

local function convert_to_printable(code)
    if code >= 32 and code <= 126 then
        return string.char(code)
    end
    return "."
end

local function format_print(start, current, line_bytes)
    local offset = start

    local ascii_code = {}
    local binary_code = {}

    for i = 1, #line_bytes do
        binary_code[i] = string.format("%02X", line_bytes[i])
        ascii_code[i] = convert_to_printable(line_bytes[i])
    end

    ascii_code = table.concat(ascii_code)
    binary_code = table.concat(binary_code, " ")

    local format_string = "%08d  " .. string.format("%%-%ds", 3*MAX_WIDTH-1) .. "  |%s|"
    print(string.format(format_string, offset, binary_code, ascii_code))
end

local function format_dump(bytes)
    local size = #bytes
    if size == 0 then return end

    local start, current = 0, 0
    while start < size do
        start = current
        local line = {}
        while current < size and current - start < MAX_WIDTH do
            current = current + 1
            line[#line+1] = bytes[current]
        end
        format_print(start, current, line)
        if current >= size then break end
    end
end

if #arg ~= 1 then
    io.stderr:write("Usage: lua dump_binary.lua <FILE>")
else
    local filename = arg[1]
    local bytes = read_file(filename)
    format_dump(bytes)
end
