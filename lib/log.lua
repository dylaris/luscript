local log = {}

log.DEBUG = 0
log.INFO  = 1
log.WARN  = 2
log.ERROR = 3
log.QUIET = 100

log.min_level = log.INFO

local output_handle = io.stderr
local hold_output_handle = false

local function level_tostring(level)
  if level == log.DEBUG then
    return "DEBUG"
  elseif level == log.INFO then
    return "INFO"
  elseif level == log.WARN then
    return "WARN"
  elseif level == log.ERROR then
    return "ERROR"
  else
    return "UNKNOWN"
  end
end

function log.to(target)
  if hold_output_handle and output_handle then
    output_handle:close()
  end

  if type(target) == "string" then
    local f = io.open(target, "a")
    if not f then
        error("log.set_output: cannot open file " .. target)
    end
    output_handle = f
    hold_output_handle = true
  else
    output_handle = target
    hold_output_handle = false
  end
end

function log.cleanup()
  if hold_output_handle and output_handle then
    output_handle:close()
  end
end

function log.time()
  return os.date("%Y-%m-%d %H:%M:%S")
end

function log.write(level, msg)
  if type(level) ~= "number" then
    error("log.write: invalid level (log.DEBUG/log.INFO/log.WARN/log.ERROR)")
  end
  output_handle:write(string.format("[%s] %-5s %s\n", log.time(), level_tostring(level), msg))
  output_handle:flush()
end

function log.debug(msg)
  if log.min_level > log.DEBUG then return end
  log.write(log.DEBUG, msg)
end

function log.info(msg)
  if log.min_level > log.INFO then return end
  log.write(log.INFO, msg)
end

function log.warn(msg)
  if log.min_level > log.WARN then return end
  log.write(log.WARN, msg)
end

function log.error(msg)
  if log.min_level > log.ERROR then return end
  log.write(log.ERROR, msg)
end

return log
