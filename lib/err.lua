local err = {}

function err.println(message)
  io.stderr:write(tostring(message) .. "\n")
end

function err.print(message)
  io.stderr:write(tostring(message))
end

function err.fatal(message)
  io.stderr:write(tostring(message) .. "\n")
  os.exit(1)
end

return err
