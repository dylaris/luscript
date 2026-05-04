--==============================================================
-- table extend
--==============================================================

-- Filter array elements with a predicate function
function table.filter(arr, fn)
  local res = {}
  for _, v in ipairs(arr) do
    if fn(v) then table.insert(res, v) end
  end
  return res
end

-- Map array elements to new values
function table.map(arr, fn)
  local res = {}
  for i, v in ipairs(arr) do
    res[i] = fn(v, i)
  end
  return res
end

-- Iterate and modify array elements in-place
function table.each(arr, fn)
  for i, v in ipairs(arr) do
    arr[i] = fn(v, i)
  end
end

-- Slice array from start to stop (supports negative indices)
function table.slice(arr, start, stop)
  local res = {}
  local len = #arr
  start = start < 0 and len + start + 1 or start
  stop = stop < 0 and len + stop + 1 or stop

  for i = start, stop do
    table.insert(res, arr[i])
  end
  return res
end

-- Check if array contains a value
-- extract: optional func to get compare key from item
function table.contains(arr, val, extract)
  for _, item in ipairs(arr) do
    local v = extract and extract(item) or item
    if v == val then
      return true
    end
  end
  return false
end

-- Return new array with unique elements
-- extract: optional func to generate unique key
function table.unique(arr, extract)
  local seen = {}
  local res = {}

  for _, item in ipairs(arr) do
    local v = extract and extract(item) or item
    if not seen[v] then
      seen[v] = true
      table.insert(res, item)
    end
  end

  return res
end

-- Deep copy with circular reference protection
function table.copy(t, cache)
  cache = cache or {}
  if type(t) ~= "table" or cache[t] then
    return t
  end

  local res = {}
  cache[t] = res

  for k, v in pairs(t) do
    res[table.copy(k, cache)] = table.copy(v, cache)
  end

  return res
end

-- Reverse array in-place
function table.reverse(arr)
  local i, j = 1, #arr
  while i < j do
    arr[i], arr[j] = arr[j], arr[i]
    i = i + 1
    j = j - 1
  end
  return arr
end

-- Find first element matching predicate
function table.find(arr, fn)
  for i, v in ipairs(arr) do
    if fn(v, i) then
      return v, i
    end
  end
  return nil
end

-- Get index of value (optional extract key)
function table.indexof(arr, val, extract)
  for i, item in ipairs(arr) do
    local v = extract and extract(item) or item
    if v == val then
      return i
    end
  end
  return -1
end

-- Remove element by value (first occurrence)
function table.removeval(arr, val, extract)
  local idx = table.indexof(arr, val, extract)
  if idx > 0 then
    return table.remove(arr, idx)
  end
  return nil
end

-- Flatten nested tables with specified depth (default: 1 level)
function table.flatten(arr, depth)
  depth = depth or 1
  local res = {}

  local function flatten(t, d)
    if type(t) == "table" and d > 0 then
      for _, v in pairs(t) do
        flatten(v, d - 1)
      end
    else
      table.insert(res, t)
    end
  end

  flatten(arr, depth)
  return res
end

-- Check if table is empty
function table.empty(t)
  return next(t) == nil
end

-- Get all keys of a table
function table.keys(t)
  local res = {}
  for k in pairs(t) do
    table.insert(res, k)
  end
  return res
end

-- Get all values of a table
function table.values(t)
  local res = {}
  for _, v in pairs(t) do
    table.insert(res, v)
  end
  return res
end

-- Shuffle array in-place using Fisher-Yates algorithm (unbiased)
function table.shuffle(arr)
  local len = #arr
  for i = len, 2, -1 do
    local j = math.random(i)
    arr[i], arr[j] = arr[j], arr[i]
  end
  return arr
end

--==============================================================
-- string extend
--==============================================================

-- Split string by separator
function string.split(str, sep)
  sep = sep or "%s"
  local res = {}
  for s in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(res, s)
  end
  return res
end

-- Check if string contains substring
function string.contains(str, substr)
  return string.find(str, substr, 1, true) ~= nil
end

-- Trim whitespace
function string.trim(str)
  return str:match("^%s*(.-)%s*$")
end

-- Check if string starts with prefix
function string.startswith(str, prefix)
  return str:sub(1, #prefix) == prefix
end

-- Check if string ends with suffix
function string.endswith(str, suffix)
  return str:sub(-#suffix) == suffix
end

--==============================================================
-- math extend
--==============================================================

-- Clamp value between min and max
function math.clamp(val, min, max)
  return math.max(min, math.min(max, val))
end

-- Map value from one range to another
function math.map(val, in_min, in_max, out_min, out_max)
  return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

-- Round to nearest integer
function math.round(val)
  return val >= 0 and math.floor(val + 0.5) or math.ceil(val - 0.5)
end

--==============================================================
-- os extend
--==============================================================

os.path = {}

-- Join multiple path parts intelligently
function os.path.join(...)
  local parts = {...}
  local result = ""

  for _, p in ipairs(parts) do
    local is_absolute = p:match("^[/\\]") or p:match("^%a:[/\\]")

    if is_absolute then
      result = p
    else
      if result == "" or result:match("[/\\]$") then
        result = result .. p
      else
        result = result .. "/" .. p
      end
    end
  end

  return os.path.norm(result)
end

-- Normalize path separators to /
function os.path.norm(p)
  return p:gsub("\\", "/"):gsub("/+", "/")
end

-- Get directory name of path
function os.path.dirname(p)
  p = os.path.norm(p)
  local dir = p:match("^(.+)/[^/]+$")
  if not dir then
    if p:match("^/[^/]+$") then
      return "/"
    end
  end
  return dir or "."
end

-- Get filename part
function os.path.basename(p, ext)
  p = os.path.norm(p)
  local name = p:match("[^/]+$") or ""
  if ext then
    name = name:gsub(ext .. "$", "")
  end
  return name
end

-- Get file extension (without dot)
function os.path.extname(p)
  local ext = p:match("%.([^/%.]+)$")
  return ext or ""
end

-- Get absolute path (basic version)
function os.path.abspath(p)
  if os.path.isabs(p) then
    return os.path.norm(p)
  end
  return os.path.join(os.getenv("PWD") or ".", p)
end

-- Check if path is absolute
function os.path.isabs(p)
  p = os.path.norm(p)
  return p:sub(1, 1) == "/" or p:match("^%a:[/\\]") ~= nil
end

-- Split path into (dir, name)
function os.path.split(p)
  return os.path.dirname(p), os.path.basename(p)
end

-- Split filename and extension
function os.path.splitext(p)
  local base = os.path.basename(p)
  local ext = os.path.extname(p)
  if ext ~= "" then
    base = base:sub(1, #base - #ext - 1)
  end
  return os.path.dirname(p) .. "/" .. base, ext
end
