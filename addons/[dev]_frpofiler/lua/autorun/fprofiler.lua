--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[dev]_frpofiler/lua/autorun/fprofiler.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

FProfiler = {}
FProfiler.Internal = {}
FProfiler.UI = {}

AddCSLuaFile()
AddCSLuaFile("fprofiler/cami.lua")
AddCSLuaFile("fprofiler/gather.lua")
AddCSLuaFile("fprofiler/report.lua")
AddCSLuaFile("fprofiler/util.lua")
AddCSLuaFile("fprofiler/prettyprint.lua")

AddCSLuaFile("fprofiler/ui/model.lua")
AddCSLuaFile("fprofiler/ui/frame.lua")
AddCSLuaFile("fprofiler/ui/clientcontrol.lua")
AddCSLuaFile("fprofiler/ui/servercontrol.lua")

include("fprofiler/cami.lua")

CAMI.RegisterPrivilege{
    Name = "FProfiler",
    MinAccess = "superadmin"
}


include("fprofiler/prettyprint.lua")
include("fprofiler/util.lua")
include("fprofiler/gather.lua")
include("fprofiler/report.lua")


if CLIENT then
    include("fprofiler/ui/model.lua")
    include("fprofiler/ui/frame.lua")
    include("fprofiler/ui/clientcontrol.lua")
    include("fprofiler/ui/servercontrol.lua")
else
    include("fprofiler/ui/server.lua")
end
