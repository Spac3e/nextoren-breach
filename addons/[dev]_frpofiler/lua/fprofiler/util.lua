--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[dev]_frpofiler/lua/fprofiler/util.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


-- Try to find the function represented by a string
function FProfiler.funcNameToObj(str)
    if isfunction(str) then return str end

    local times = FProfiler.Internal.getCallCounts()
    for func, _ in pairs(times) do
        if tostring(func) == str then return func end
    end

    local tbl = _G
    local exploded = string.Explode(".", str, false)
    if not exploded or not exploded[1] then return end

    for i = 1, #exploded - 1 do
        tbl = (tbl or {})[exploded[i]]
        if not istable(tbl) then return end
    end

    local func = (tbl or {})[exploded[#exploded]]

    if not isfunction(func) then return end

    return func
end

-- Read a file
function FProfiler.readSource(fname, startLine, endLine)
    if not file.Exists(fname, "GAME") then return "" end
    if startLine < 0 or endLine < 0 or endLine < startLine then return "" end

    local f = file.Open(fname, "r", "GAME")

    for i = 1, startLine - 1 do f:ReadLine() end

    local res = {}
    for i = startLine, endLine do
        table.insert(res, f:ReadLine() or "")
    end

    return table.concat(res, "\n")
end
