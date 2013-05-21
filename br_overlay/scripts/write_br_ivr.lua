#!/usr/bin/lua

local fs = 1

local path_arg
local uuid
local var_table = {
        uuid="file",
        context="the_context",
        destination_number="destination_number",
        caller_id_name="caller_id_name",
        caller_id_number="the caller_id_number",
        network_addr="the network address",
        ani="ani",
        aniii="aniii",
        rdnis="the rdnis",
        source="the source",
        chan_name="chan_name",
        }

if fs==1 then
    path_arg = argv[1]
    uuid = session:getVariable("uuid")
else
    path_arg = '.'
    uuid = "file"
end

function log(level,msg)
    if fs==1 then
        freeswitch.consoleLog(level, msg .. "\n")
    else
        print(msg)
    end
end

if path_arg==nil or uuid==nil then
    log("info", "write_br_vars: nil path or no uuid")
    return
end

local path = path_arg .. '/' .. uuid

local fh = io.open(path, "w")
if fh==nil then
    log("info", "path not found [" .. path .. "]")
    return
end

log("info", "writing to [" .. path .. "]:")

local key,value
for key,value in pairs(var_table) do
    if fs==1 then
        value = session:getVariable(key)
    end
    fh:write(key..": "..value.."\n")
end
fh:write("_done: _".."\n")

fh:close()

