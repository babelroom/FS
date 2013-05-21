#!/usr/bin/lua

local path_arg = argv[1]
local key_arg = argv[2]
--local path_arg = './foo'
--local key_arg = '123'

if path_arg==nil or key_arg==nil then
    freeswitch.consoleLog("info", "read_br_kv: nil argument\n")
    return
end

local path = path_arg .. '/' .. key_arg

local fh = io.open(path, "r")
if fh==nil then
    freeswitch.consoleLog("info", "path not found [" .. path .. "]\n")
    return
end

freeswitch.consoleLog("info", "reading from [" .. path .. "]:\n")

while true do
    local line = fh:read("*l")
    if line==nil then break end
    _, _, key, value = string.find(line, "([^:]*):%s*(.*)")
--    print("key=["..key.."], value=["..value.."]")
    freeswitch.consoleLog("info", "\tkey=["..key.."], value=["..value.."]\n")
    session:setVariable('BR-'..key, value)
end

fh:close()

