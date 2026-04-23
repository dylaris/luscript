local M = {}

function M.iota(start)
    local n = start or 0
    return function()
        local cur = n
        n = n + 1
        return cur
    end
end

function M.enum(...)
    local names = {...}
    local tbl = {}
    for i = 1, #names do
        tbl[names[i]] = i - 1
    end
    setmetatable(tbl, {
        __newindex = function() error("enum is readonly") end,
        __index = tbl,
    })
    return tbl
end

local function is_single_char(c)
    return type(c) == "string" and #c == 1
end

function M.is_digit(c)
    return is_single_char(c) and c >= '0' and c <= '9'
end

function M.is_lower(c)
    return is_single_char(c) and c >= 'a' and c <= 'z'
end

function M.is_upper(c)
    return is_single_char(c) and c >= 'A' and c <= 'Z'
end

function M.is_alnum(c)
    return M.is_digit(c) or M.is_lower(c) or M.is_upper(c)
end

function M.is_alpha(c)
    return M.is_lower(c) or M.is_upper(c)
end

function M.is_whitespace(c)
    if not c then return false end
    return c == ' ' or c == '\t' or c == '\n' or c == '\r'
end

return M
