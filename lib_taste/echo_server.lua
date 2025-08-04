local socket = require("socket")

local port = 9190
local server = assert(socket.bind("*", port))
print("Echo server started on " .. port)

while true do
    local client = server:accept()
    client:settimeout(10)

    print("Connected client...")

    while true do
        local data, err = client:receive("*l")
        if err then
            print("Client disconnected or error: " .. err)
            break
        end
        print("Received: " .. data) 
        client:send(data .. "\n")
    end

    client:close()
end
