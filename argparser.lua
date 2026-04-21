local ArgParser = {}
ArgParser.__index = ArgParser

function ArgParser:new(description)
    local obj = {}
    setmetatable(obj, self)
    self.desc = description or ""
    self.options = {}
    self.map = {}
    return obj
end

-- config = {
--     nargs = "+"/n            -- "+" means any
--     default = value          -- table is allowed
--     help = string            -- help description
--     required = true/false    -- option is required or not
-- }
function ArgParser:add(short_name, long_name, config)
    local opt = {
        short = short_name,
        long = long_name,
        args = {},
        default = config.default or nil,
        nargs = config.nargs or 0,
        help = config.help or "",
        required = config.required or false,
        used = false,
    }
    self.map[short_name] = opt
    self.map[long_name] = opt
    table.insert(self.options, opt)
end

local function isopt(s)
    return not not (s:match("^%-%w$") or s:match("^%-%-%w+"))
end

local function split()
    local opts = {}
    local index = 1
    while index <= #arg do
        local name = arg[index]
        if isopt(name) then
            local opt = { name = name, args = {} }
            index = index + 1
            while index <= #arg do
                local a = arg[index]
                if not isopt(a) then
                    table.insert(opt.args, a)
                    index = index + 1
                else
                    break
                end
            end
            local key, value = name:match("^(%-%-[^=]+)=(.*)")
            if key then
                opt.name = key
                table.insert(opt.args, value)
            end
            table.insert(opts, opt)
        else
            index = index + 1
        end
    end
    return opts
end

function ArgParser:print()
    if self.desc then
        print("<<< " .. self.desc .. " >>>")
    end
    for _, opt in ipairs(self.options) do
        print(opt.short, opt.long, opt.nargs, opt.help)
    end
end

function ArgParser:parse()
    local opts = split()
    for _, raw_opt in ipairs(opts) do
        local opt = self.map[raw_opt.name]
        -- option is valid or not
        if opt then
            opt.used = true
            -- copy args (default or passed)
            for _, arg in ipairs(raw_opt.args) do
                table.insert(opt.args, arg)
            end
            if #opt.args == 0 and opt.nargs ~= 0 then
                if type(opt.default) ~= "table" then
                    table.insert(opt.args, opt.default)
                else
                    for _, arg in ipairs(opt.default) do
                        table.insert(opt.args, arg)
                    end
                end
            end
            -- check the number of args
            if not opt.nargs == "+" and #opt.args ~= opt.nargs then
                print("option: " .. opt.long .. " required [" .. opt.nargs .. "] args, but get " .. #opt.args .. " actually")
                os.exit(1)
            end
        else
            print("unknown option: " .. raw_opt.name)
            os.exit(1)
        end
    end

    local required_is_ok = true
    for _, opt in ipairs(self.options) do
        if opt.required == true and opt.used == false then
            required_is_ok = false
            print("option " .. opt.long .. " is required, but not used")
        end
    end
    if not required_is_ok then os.exit(1) end

    return self.options
end

return ArgParser


--[[ example
local ArgParser = require("argparser")

local parser = ArgParser:new("testing")

parser:add("-h", "--help",    { help = "print this information" })
parser:add("-d", "--depth",   { nargs = 1, default = 1 })
parser:add("-p", "--path",    { nargs = 1, default = "." })
parser:add("-f", "--files",   { nargs = "+" })
parser:add("-x", "--exclude", { nargs = 3, required = true })

parser:print()

local opts = parser:parse()

for _, opt in ipairs(opts) do
    local arg_string = ""
    for _, arg in ipairs(opt.args) do
        arg_string = arg_string .. tostring(arg) .. ", "
    end
    print(opt.short, opt.long, opt.default, #opt.args, arg_string)
end

print(parser.map["-h"].used)
print(parser.map["-p"].used)
--]]
