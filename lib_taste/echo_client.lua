local socket = require("socket")

local client = socket.tcp()
client:settimeout(10)

local serv_addr = "127.0.0.1"
local port = 9190
client:connect(serv_addr, port)

print("Connected to echo server...")

while true do
    io.write("Enter message (q to quit): ")
    local msg = io.read()
    if msg == "q" then
        client:close()
        break
    end

    client:send(msg .. "\n")

    local response, err = client:receive("*l")
    if err then
        print("Server closed connection or error: " .. err)
        break
    end

    print("Echo from server: " .. response)
end
