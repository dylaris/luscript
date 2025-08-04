-- Usage: lua flag_parser.lua --hello -gv v1 v2 v3

local function get_flag_name(input)
    return input:match("^-+(.*)$")
end

local function callback(flags, flagname, action, ...)
    if flags[flagname] then action(...) end
end

local function parse_flags()
    local flags = {}
    for i = 1, #arg do
        local flagname = get_flag_name(arg[i])
        if flagname then
            local flag = {}
            flag.name = flagname
            flag.value = {}
            while true do
                i = i + 1
                if i > #arg then break end
                if get_flag_name(arg[i]) then
                    i = i - 1
                    break
                else
                    table.insert(flag.value, arg[i])
                end
            end
            flags[flagname] = flag
        end
    end
    return flags
end

local function dump_flags(flags)
    for _, flag in pairs(flags) do
        print(string.format("> %-20s", flag.name))
        for j = 1, #flag.value do
            print(">>>", flag.value[j])
        end
    end
end

local function main()
    local flags = parse_flags()
    -- dump_flags(flags)

    callback(flags, "hello", function () print("hello world") end)
    callback(flags, "gv", function (flag)
        io.write("The values of flag 'gv': ")
        for i = 1, #flag.value do
            io.write(tostring(flag.value[i]), " ")
        end
        io.write("\n")
    end, flags["gv"])
end

main()
