local path = {}

-- Join multiple path parts intelligently
function path.join(...)
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

  return path.norm(result)
end

-- Normalize path separators to /
function path.norm(p)
  return p:gsub("\\", "/"):gsub("/+", "/")
end

-- Get directory name of path
function path.dirname(p)
  p = path.norm(p)
  local dir = p:match("^(.+)/[^/]+$")
  if not dir then
    if p:match("^/[^/]+$") then
      return "/"
    end
  end
  return dir or "."
end

-- Get filename part
function path.basename(p, ext)
  p = path.norm(p)
  local name = p:match("[^/]+$") or ""
  if ext then
    name = name:gsub(ext .. "$", "")
  end
  return name
end

-- Get file extension (without dot)
function path.extname(p)
  local ext = p:match("%.([^/%.]+)$")
  return ext or ""
end

-- Get absolute path (basic version)
function path.abspath(p)
  if path.isabs(p) then
    return path.norm(p)
  end
  return path.join(os.getenv("PWD") or ".", p)
end

-- Check if path is absolute
function path.isabs(p)
  p = path.norm(p)
  return p:sub(1, 1) == "/" or p:match("^%a:[/\\]") ~= nil
end

-- Split path into (dir, name)
function path.split(p)
  return path.dirname(p), path.basename(p)
end

-- Split filename and extension
function path.splitext(p)
  local base = path.basename(p)
  local ext = path.extname(p)
  if ext ~= "" then
    base = base:sub(1, #base - #ext - 1)
  end
  return path.dirname(p) .. "/" .. base, ext
end

return path
